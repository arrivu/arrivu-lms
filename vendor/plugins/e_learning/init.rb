# Include hook code here

require  File.dirname(__FILE__) + '/lib/e_learning.rb'
require 'dispatcher'
Dispatcher.to_prepare do
  AccountsController.send :include, Elearning::AccountControllerExtensions
  Account.send :include, Elearning::AccountExtensions
  CoursesController.send :include,Elearning::CoursesControllerExtensions
  UsersController.send :include,Elearning::UsersControllerExtensions
  UserListsController.send :include,Elearning::UsersListsControllerExtensions
  Enrollment.send :include,Elearning::EnrollmentExtensions
  ProfileController.send :include,Elearning::ProfileControllerExtensions
end


require_dependency 'e_learning'
# Should run with each request
config.to_prepare do
  Arrivu::ELearning::initialize
end
