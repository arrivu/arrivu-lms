class Referral < ActiveRecord::Base

  belongs_to :reward
  belongs_to :pseudonym
  has_many :references
  #has_many :referrees

  attr_accessible :pseudonym_id, :email_subject,  :email_text,  :referral_emails

  validates_presence_of :email_subject, :email_text

  def create_referrees
    providers = ReferralProvider.find(:all)
  end
end
