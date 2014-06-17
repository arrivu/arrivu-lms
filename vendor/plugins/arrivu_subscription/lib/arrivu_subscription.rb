# E-learning

require 'subscription/routing'
# require  File.dirname(__FILE__) + '/controllers/account_controller_extensions.rb'

Dir.glob(File.join(File.dirname(__FILE__), "db", "migrate", "*")).each do |file|
  require file
end

module Arrivu
  module Subscription
    def self.initialize
      true
    end
  end
end
