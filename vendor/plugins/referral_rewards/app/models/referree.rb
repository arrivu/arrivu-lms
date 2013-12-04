class Referree < ActiveRecord::Base

  #belongs_to :referral
  belongs_to :reference
  has_one :coupon


  attr_accessible :email, :name, :phone, :referral_email, :status, :coupon_code, :expiry_date

  STATUS_CREATE   = 'create'
  STATUS_REGISTER = 'register'
  STATUS_ENROLL = 'enroll'
  STATUS_COMPLETE = 'complete'

end


