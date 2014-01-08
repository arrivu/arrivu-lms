ActionController::Dispatcher.middleware.use OmniAuth::Builder  do

  provider :facebook, "542771412468139", "c890fc3fedd58085b067171d5652c1df"
  provider :linkedin, "31azcdigi8tt", "OKd1hmuJoNOg9J2g"
  provider :google_oauth2, "1043706304418.apps.googleusercontent.com", "9hf4pcRW5uvHP3DSz-nsQ0DL"

end