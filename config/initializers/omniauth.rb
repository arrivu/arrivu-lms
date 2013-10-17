ActionController::Dispatcher.middleware.use OmniAuth::Builder  do

  provider :facebook, "542771412468139", "c890fc3fedd58085b067171d5652c1df"
  provider :linkedin, "31azcdigi8tt", "OKd1hmuJoNOg9J2g"
  provider :google_oauth2, "347634236839.apps.googleusercontent.com", "5UnDJ5JcZqn5LWD00-Bi_Sk1"

end