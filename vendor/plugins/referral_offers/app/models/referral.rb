class Referral < ActiveRecord::Base

  belongs_to :offer
  belongs_to :pseudonym

  attr_accessible :email_subject,  :email_text, :short_url_code

  validates_presence_of :email_subject, :email_text

  def create_referrees
    providers = ReferralProvider.find(:all)
  end

end
