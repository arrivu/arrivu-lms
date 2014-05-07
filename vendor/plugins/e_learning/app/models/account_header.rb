class AccountHeader < ActiveRecord::Base
  belongs_to :account
  attr_accessible :account_id,:header_logo_url
end
