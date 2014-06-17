class Subscription < ActiveRecord::Base
  include SubscriptionHelper
  belongs_to :organization
  has_many :payments
  attr_accessible :account_id,:subscription_plan_id,:subscribable_id,:subscribable_type,:expire_on,:started_on

  SUBSCRIBABLE_TYPE_ACCOUNT = 'Account'

  belongs_to :subscription_plan, :class_name => "SubscriptionPlan"
  belongs_to :subscribable, :polymorphic => true
  belongs_to :credit_card, :dependent => :destroy, :class_name => "CreditCard"
  # has_many :coupon_redemptions, :conditions => "coupon_redemptions.expired_on IS NULL", :class_name => "CouponRedemption", :foreign_key => :subscription_id, :dependent => :destroy
  # has_many :coupons, :through => :coupon_redemptions, :conditions => "coupon_redemptions.expired_on IS NULL"

  # Auditing
  has_many :transactions, :class_name => "AccountTransaction", :foreign_key => :subscription_id

  scope :paid, includes(:subscription_plan).where("subscription_plans.rate_cents > 0")
  scope :due, lambda {
    where(['paid_through <= ?', Date.today]) # could use the concept of a next retry date
  }
  scope :expired, lambda {
    where(['expire_on >= paid_through AND expire_on <= ?', Date.today])
  }

  before_validation :set_paid_through
  before_validation :set_started_on

  after_create  :audit_create
  after_update  :audit_update
  after_destroy :audit_destroy

  validates_presence_of :subscribable_id,:subscribable_type
  # validates_associated  :subscribable
  # validates_presence_of :subscription_plan
  validates_presence_of :paid_through, :if => :paid?
  validates_presence_of :started_on


  def usage
    (self.expire_on - self.paid_through).to_i
  end

  def original_plan
    @original_plan ||= ::SubscriptionPlan.find_by_id(subscription_plan_id_was) unless subscription_plan_id_was.nil?
  end

  def set_paid_through
    if subscription_plan_id_changed? && !paid_through_changed?
      if paid?
        if new_record?
          # paid + new subscription = in free trial
          self.paid_through = Date.today + Freemium.days_free_trial
          self.in_trial = true
        elsif !self.in_trial? && self.original_plan && self.original_plan.paid?
          # paid + not in trial + not new subscription + original sub was paid = calculate and credit for remaining value
          value = self.remaining_value(original_plan)
          self.paid_through = Date.today
          self.credit(value)
        else
          # otherwise payment is due today
          self.paid_through = Date.today
          self.in_trial = false
        end
      else
        # free plans don't pay
        self.paid_through = nil
      end
    end
    true
  end


  def set_started_on
    self.started_on = Date.today if subscription_plan_id_changed?
  end

  def audit_create
    ::SubscriptionChange.create(:reason => "new",
                                :subscribable_id => self.subscribable_id,
                                :subscribable_type => self.subscribable_type,
                                :new_subscription_plan_id => self.subscription_plan_id,
                                :new_rate => self.rate,
                                :original_rate => Money.empty)
  end

  def audit_update
    if self.subscription_plan_id_changed?
      return if self.original_plan.nil?
      reason = self.original_plan.rate > self.subscription_plan.rate ? (self.expired? ? "expiration" : "downgrade") : "upgrade"
      ::SubscriptionChange.create(:reason => reason,
                                  :subscribable_id => self.subscribable_id,
                                  :subscribable_type => self.subscribable_type,
                                  :original_subscription_plan_id => self.original_plan.id,
                                  :original_rate => self.rate(:plan => self.original_plan),
                                  :new_subscription_plan_id => self.subscription_plan.id,
                                  :new_rate => self.rate)
    end
  end

  def audit_destroy
    ::SubscriptionChange.create(:reason => "cancellation",
                                :subscribable_id => self.subscribable_id,
                                :subscribable_type => self.subscribable_type,
                                :original_subscription_plan_id => self.subscription_plan_id,
                                :original_rate => self.rate,
                                :new_rate => Money.empty)
  end

  public

  ##
  ## Class Methods
  ##

  module ClassMethods
    # expires all subscriptions that have been pastdue for too long (accounting for grace)
    def expire
      self.expired.select{|s| s.paid?}.each(&:expire!)
    end
  end

  ##
  ## Rate
  ##

  def rate(options = {})
    options = {:date => Date.today, :plan => self.subscription_plan}.merge(options)

    return nil unless options[:plan]
    value = options[:plan].rate
    value
  end

  def paid?
    return false unless rate
    rate.cents > 0
  end

  def remaining_value(plan = self.subscription_plan)
    self.daily_rate(:plan => plan) * remaining_days
  end

  # if paid through today, returns zero
  def remaining_days
    (self.paid_through - Date.today)
  end

  def remaining_days_of_grace
    (self.expire_on - Date.today - 1).to_i
  end

  def in_grace?
    remaining_days < 0 and not expired?
  end


  ##
  ## Expiration
  ##

  # sets the expiration for the subscription based on today and the configured grace period.
  def expire_after_grace!(transaction = nil)
    return unless self.expire_on.nil? # You only set this once subsequent failed transactions shouldn't affect expiration
    self.expire_on = [Date.today, paid_through].max + Freemium.days_grace
    transaction.message = "now set to expire on #{self.expire_on}" if transaction
    Freemium.mailer.expiration_warning(self).deliver
    transaction.save! if transaction
    save!
  end

  # sends an expiration email, then downgrades to a free plan
  def expire!
    Freemium.mailer.expiration_notice(self).deliver
    # downgrade to a free plan
    self.expire_on = Date.today
    self.subscription_plan = Freemium.expired_plan if Freemium.expired_plan
    self.destroy_credit_card
    self.save!
  end

  def expired?
    expire_on and expire_on <= Date.today
  end

  ##
  ## Receiving More Money
  ##

  # receives payment and saves the record
  def receive_payment!(transaction)
    receive_payment(transaction)
    transaction.save!
    self.save!
  end

  # extends the paid_through period according to how much money was received.
  # when possible, avoids the days-per-month problem by checking if the money
  # received is a multiple of the plan's rate.
  #
  # really, i expect the case where the received payment does not match the
  # subscription plan's rate to be very much an edge case.
  def receive_payment(transaction)
    self.credit(transaction.amount)
    self.save!
    transaction.subscription.reload  # reloaded to that the paid_through date is correct
    transaction.message = "now paid through #{self.paid_through}"

    begin
      Freemium.mailer.invoice(transaction).deliver
    rescue => e
      transaction.message = "error sending invoice: #{e}"
    end
  end

  def credit(amount)
    self.paid_through = if amount.cents % rate.cents == 0
                          self.paid_through + (amount.cents / rate.cents).months
                        else
                          self.paid_through + (amount.cents / daily_rate.cents).days
                        end

    # if they've paid again, then reset expiration
    if subscription_plan_id_changed? and paid?
      self.expire_on = Date.today + 1.months
    else
      self.expire_on = nil
    end
    self.in_trial = false
  end

end