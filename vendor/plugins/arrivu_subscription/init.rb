# Include hook code here

require File.dirname(__FILE__) + '/lib/arrivu_subscription.rb'
require 'dispatcher'
Dispatcher.to_prepare do
  # AccountsController.send :include, Elearning::AccountControllerExtensions

end


require_dependency 'subscription'
# Should run with each request
config.to_prepare do
  Arrivu::Subscription::initialize
end
