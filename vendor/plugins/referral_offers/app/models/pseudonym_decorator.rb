Pseudonym.class_eval do
  has_many :offers
  has_many :referral

  def has_offer?
    offers.present?
  end

  def has_referral?
    referrals.present?
  end

end
