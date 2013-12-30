class Referree < ActiveRecord::Base

  STATUS_CREATE   = 'create'
  STATUS_REGISTER = 'register'
  STATUS_ENROLL = 'enroll'
  STATUS_COMPLETE = 'complete'
  STATUS_ACTIVE = 'active'
  belongs_to :reference
  has_one :coupon
  #validates :phone,:presence => true,
  #          :numericality => true,
  #          :length => { :minimum => 10}

  validates_presence_of :email, :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessible :email, :name, :phone, :referral_email, :status, :coupon_code, :expiry_date,:reference_id,:coupon_id

  scope :active, where(status: STATUS_ACTIVE)


end


