class Payment < ActiveRecord::Base

  attr_accessible :subscription_plan_id,:subscription_id,:user_id,:merchant_transaction_id,
                  :buyer_email_address,:transaction_type,:transaction_amount,:payment_method,:currency,:ui_mode,
                  :hash_method,:completed, :canceled,:bank_name,:billing_type_id,:account_id

  validates_presence_of :subscription_plan_id,:subscription_id,:user_id,
                        :buyer_email_address,:transaction_type,:transaction_amount,:payment_method,:currency,:ui_mode,
                        :hash_method,:bank_name,:account_id
  validates_uniqueness_of :merchant_transaction_id, uniqueness: true

  scope :completed,     where(completed: true)

  belongs_to :account_subscription
  belongs_to :subscription_plan
  belongs_to :billing_type
  belongs_to :account
  belongs_to :subscription


  before_create :generate_merchant_transaction_id



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
