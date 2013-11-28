# Include hook code here
require_dependency 'referral_offers'
# Should run with each request
config.to_prepare do
  Referrals::Offers::initialize
end
