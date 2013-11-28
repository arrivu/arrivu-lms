class Referrance < ActiveRecord::Base

  belongs_to :referral
  belongs_to :referral_provider

  attr_accessible :visit_count, :short_url, :referree_email, :status
end
