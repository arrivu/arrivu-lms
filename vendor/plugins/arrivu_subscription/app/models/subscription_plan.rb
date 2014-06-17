class SubscriptionPlan < ActiveRecord::Base
  # yes, subscriptions.subscription_plan_id may not be null, but
  # this at least makes the delete not happen if there are any active.
  has_many :subscriptions, :dependent => :nullify, :class_name => "Subscription", :foreign_key => :subscription_plan_id
  has_and_belongs_to_many :coupons, :class_name => "SubscriptionPlan",
                          :join_table => :coupons_subscription_plans, :foreign_key => :subscription_plan_id, :association_foreign_key => :coupon_id

  composed_of :rate, :class_name => 'Money', :mapping => [ %w(rate_cents cents) ], :allow_nil => true

  validates_uniqueness_of :redemption_key, :allow_nil => true, :allow_blank => true
  validates_presence_of :name
  validates_presence_of :rate_cents
  attr_accessible :feature_set_id, :name, :rate_cents,:account_id
  belongs_to :feature_set
  belongs_to :account

  scope :free, where("rate_cents = 0")

  def paid?
    return false unless rate
    rate.cents > 0
  end
end
