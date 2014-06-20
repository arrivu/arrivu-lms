class Payment < ActiveRecord::Base

  attr_accessible :subscription_plan_id,:subscription_id,:user_id,:merchant_transaction_id,
                  :buyer_email_address,:transaction_type,:transaction_amount,:payment_method,:currency,:ui_mode,
                  :hash_method,:completed, :canceled,:bank_name,:billing_type_id,:account_id

  validates_presence_of :user_id,:buyer_email_address,:transaction_type,:transaction_amount,:payment_method,:currency,
                        :ui_mode,:hash_method,:bank_name,:account_id
  validates_uniqueness_of :merchant_transaction_id, uniqueness: true

  scope :completed,     where(completed: true)

  belongs_to :account_subscription
  belongs_to :subscription_plan
  belongs_to :billing_type
  belongs_to :account
  belongs_to :subscription
  belongs_to :user



  before_create :generate_merchant_transaction_id
  after_save :broadcast_notifications

  has_a_broadcast_policy

  set_broadcast_policy do |p|
    p.dispatch :payment_invoice
    p.to {|record| record.user}
    p.whenever { @send_payment_invoice }
  end

  def broadcast_notifications
    return if @broadcasted
    @broadcasted = true
    raise ArgumentError, "Broadcast Policy block not supplied for #{self.class.to_s}" unless self.class.broadcast_policy_list
    self.class.broadcast_policy_list.broadcast(self)
  end

  def complete_payment!
    @send_payment_invoice = true
    self.completed = true
    self.save
    @send_payment_invoice = false
    true
  end


  def details
    if recurring?
      client.subscription(self.identifier)
    else
      client.details(self.token)
    end
  end

  attr_reader :redirect_uri, :popup_uri
  def setup!(return_url, cancel_url)
    response = client.setup(
        payment_request,
        return_url,
        cancel_url,
        pay_on_paypal: true,
        no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!(payer_id = nil)
    if self.recurring?
      response = client.subscribe!(self.token, recurring_request)
      self.identifier = response.recurring.identifier
    else
      response = client.checkout!(self.token, payer_id, payment_request)
      self.payer_id = payer_id
      self.identifier = response.payment_info.first.transaction_id
    end
    self.completed = true
    self.save!
    self
  end

  def unsubscribe!
    client.renew!(self.identifier, :Cancel)
    self.cancel!
  end

  protected

  def generate_merchant_transaction_id
    self.merchant_transaction_id = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Payment.exists?(merchant_transaction_id: random_token)
    end
  end

end
