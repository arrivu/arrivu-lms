module Elearning
  module CoursesControllerExtensions
    def self.included base
      base.class_eval do

        base. before_filter :check_for_course_limit, :only => [:create,:enroll_users]

        def check_for_course_limit
          get_context

          unless @context.is_a?(Account) && @account.nil?
            load_account
            @account ||= @domain_root_account
          end
          unless (@account.courses.active.count < @account.settings[:no_courses].to_i) ||
              (@account.settings[:no_courses].to_i == 0)
              if request.referrer == root_url
                flash[:error] = " Your Arrivu LMS Course creation limit is exceeded.Please upgrade your subscription plan."
                flash.keep(:error)
                redirect_back_or_default(dashboard_path)
              else
                respond_to do |format|
                  format.json { render :json => {:course_limit => "Your Arrivu LMS Course creation limit is exceeded.
                                                       Please upgrade your subscription plan."}.to_json, :status =>:error}
                 end
              end
          end
        end
      end
    end
  end
end