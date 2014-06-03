# E-learning

require 'e_learning/routing'
require  File.dirname(__FILE__) + '/controllers/account_controller_extensions.rb'
require  File.dirname(__FILE__) + '/models/account_extensions.rb'
require  File.dirname(__FILE__) + '/controllers/courses_controller_extensions.rb'
require  File.dirname(__FILE__) + '/controllers/user_controllers_extension.rb'
require  File.dirname(__FILE__) + '/controllers/user_lists_extension.rb'

Dir.glob(File.join(File.dirname(__FILE__), "db", "migrate", "*")).each do |file|
  require file
end

module Arrivu
  module ELearning
    def self.initialize
      true
    end
  end
end
