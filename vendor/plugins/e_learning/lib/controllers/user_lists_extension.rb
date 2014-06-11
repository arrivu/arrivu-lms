module Elearning
  module UsersListsControllerExtensions
    def self.included base
      base.class_eval do

        base.before_filter :check_for_subscription_limit

        def check_for_subscription_limit

          if @account.nil? && @context.nil?
            get_context
          end

          if params[:membership_type] == "AccountAdmin"
            avillable_user_count = @account.account_users.includes(:user).size
            max_user_count = @account.settings[:no_admins].to_i
            enrollment_type = params[:membership_type]
          elsif params[:enrollment_type] == "StudentEnrollment"
            avillable_user_count = 0
            @context.account.courses.not_deleted.each do |course|
              avillable_user_count += course.enrollments.all_student.size
            end

            max_user_count = @context.account.settings[:no_students].to_i
            enrollment_type = params[:enrollment_type]
          elsif params[:enrollment_type] == "TeacherEnrollment"
            avillable_user_count = 0
            @context.account.courses.not_deleted.each do |course|
              avillable_user_count += course.enrollments.all_teacher.size
            end
            max_user_count = @context.account.settings[:no_teachers].to_i
            enrollment_type = params[:enrollment_type]
          end

          unless ( avillable_user_count.to_i < max_user_count.to_i) || (max_user_count.to_i == 0)
            respond_to do |format|
              format.json { render :json => {:error => "Your Arrivu LMS #{enrollment_type}  limit is exceeded.
                                               Please upgrade your subscription plan."}.to_json}
            end
          end

        end

      end
    end
  end
end
