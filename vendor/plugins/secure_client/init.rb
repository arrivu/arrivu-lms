Rails.configuration.to_prepare do
  plugin = Canvas::Plugin.register :lockdown_browser, :lockdown_browser, {
      :name => lambda{ t :name, 'Secure Client' },
      :author => 'Arrivu Info Tech PVT.',
      :author_website => 'http://www.arrivusystems.com',
      :description => lambda{ t :description, 'Secure Client for quiz' },
      :version => '1.0.0',
      :settings_partial => 'plugins/secure_client_settings',
      :settings => {
          :enabled => true,
          :use_lti_tool => true
      },
      :base => SecureClient
  }

end

require File.dirname(__FILE__) + '/lib/arrivu_secure_client.rb'
require 'dispatcher'

Dispatcher.to_prepare do
  Quizzes::QuizzesController.send :include, ArrivuSecureClient::QuizzesControllerExtensions
  Quizzes::QuizzesApiController.send :include, ArrivuSecureClient::QuizzesApiControllerExtensions
end

require_dependency 'arrivu_secure_client'
# Should run with each request
config.to_prepare do
  ArrivuSecureClient::initialize
end


