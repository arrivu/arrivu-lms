class Reference < ActiveRecord::Base

  belongs_to :referral
  belongs_to :referral_provider

  attr_accessible  :short_url_code, :provider, :status
end
