class UserModuleEnrollmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_enrollments_url }
  def index
    if authorized_action(@context, @current_user, :read)
      @context_modules = @context.context_modules.active
      js_env :COURSE_MODULES_FOR_ENROLLMENT => @context_modules.map(&:attributes)
      js_env :ENROLLED_COURSE_USERS => @context.students.map(&:attributes)
      # { 1:  [2,3,4]}
      # module_id: user_id array
      @module_user_ids = {}
      user_ids = []
      @context_modules.each do |context_module|
        module_id = context_module.id
        @user_module_enrollments = UserModuleEnrollment.where(context_module_id: module_id )
        @user_module_enrollments.each do |user_module_enrollment|
          user_ids << user_module_enrollment.user_id
        end
        @module_user_id = {module_id.to_i => user_ids}
        user_ids = []
        @module_user_ids.merge!(@module_user_id)
      end
      js_env :MODULE_PERMISSION_USER_IDS => @module_user_ids
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
