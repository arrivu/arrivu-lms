class UserModuleEnrollmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_enrollments_url }
  def index
    if authorized_action(@context, @current_user, :read)
     @context_modules = @context.context_modules.active
      js_env :COURSE_MODULES_FOR_ENROLLMENT => @context_modules.map(&:attributes)
      js_env :ENROLLED_COURSE_USERS => @context.students.map(&:attributes)
      #js_env :ENROLLED_COURSE_USERS => @context.context_modules.user_module_enrollments.map(&:attributes)
     @user_module_enrollments = {}
     @context_modules.each do |context_module|
       user_ids = []
       context_module.user_module_enrollments.each do |user_module_enrollment|
         user_ids << user_module_enrollment.user_id
       end
       @user_module_enrollment = {module_id: context_module.id, user_ids: user_ids}

       @user_module_enrollments.merge!(@user_module_enrollment)
     end


    end
  end

  def new

  end

  def create

  end

  def destroy

  end

  def update
    if authorized_action(@context.context_modules.new, @current_user, :update)

    end
  end

end
