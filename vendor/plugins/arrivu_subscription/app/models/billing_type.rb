class BillingType < ActiveRecord::Base
   attr_accessible :account_id, :billing_type,:discount_percentage,:months
   belongs_to :account
   has_many :payments
end
