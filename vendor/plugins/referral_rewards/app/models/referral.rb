class Referral < ActiveRecord::Base

  belongs_to :reward
  belongs_to :pseudonym

  attr_accessible :email_subject,  :email_text, :short_url_code, :referral_emails

  validates_presence_of :email_subject, :email_text, :referral_emails

  def create_referrees
    providers = ReferralProvider.find(:all)
  end
end
