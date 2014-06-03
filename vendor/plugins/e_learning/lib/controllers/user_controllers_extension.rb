module Elearning
  module UsersControllerExtensions
    def self.included base
      base.class_eval do

        base.before_filter :check_for_user_limit, :only => [:create]

        def check_for_user_limit
          get_context
          unless @context.is_a?(Account) && @account.nil?
            load_account
            @account ||= @domain_root_account
          end
          unless (@account.all_users.count < @account.settings[:no_students].to_i) ||
              (@account.settings[:no_students].to_i == 0)
            respond_to do |format|
              format.json { render :json => {:course_limit => "Your Arrivu Student creation limit is exceeded.
                                                         Please contact your account admin "}.to_json, :status =>:error}
            end
          end
         end
      end
    end
  end
end
