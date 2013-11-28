class Offer < ActiveRecord::Base
  attr_accessible  :name, :description, :expiry_date, :how_many,
                   :referrer_amount, :referrer_percentage, :referrer_expiry_date,
                   :referree_amount, :referree_percentage, :referree_expiry_date,
                   :email_subject, :email_template_txt, :alpha_mask, :metadata,
                   :status

  belongs_to :course
  belongs_to :account
  belongs_to :pseudonym
  has_many :referrals

  validates_presence_of :name,  :description, :how_many, :referrer_expiry_date, :referree_expiry_date, :email_subject,
                        :email_template_txt, :alpha_mask

end


