ActionController::Dispatcher.middleware.use OmniAuth::Builder  do

  config = Setting.from_config("omniauth")
  provider :facebook, config[:facebook_key], config[:facebook_secret]
  provider :linkedin, config[:linkedin_key], config[:linkedin_secret]
  provider :google_oauth2, config[:google_oauth2_key], config[:google_oauth2_secret]
end