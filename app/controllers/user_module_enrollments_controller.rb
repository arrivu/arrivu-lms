class UserModuleEnrollmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_enrollments_url }
  def index
    if authorized_action(@context, @current_user, :read)
      @context_module_groups = @context.context_module_groups.active
      js_env :COURSE_MODULES_FOR_ENROLLMENT => @context_module_groups.map(&:attributes)
      js_env :ENROLLED_COURSE_USERS => @context.students.map(&:attributes)
      js_env :COURSE_ID => @context.id
      # { 1:  [2,3,4]}
      # module_group_id: user_id array of user ids
      @module_group_user_ids = {}
      user_ids = []
      @context_module_groups.each do |context_module_group|
        module_group_id = context_module_group.id
        @user_module_group_enrollments = UserModuleEnrollment.where(context_module_id: module_group_id ,workflow_state: UserModuleEnrollment::ACTIVE)
        @user_module_group_enrollments.each do |user_module_group_enrollment|
          user_ids << user_module_group_enrollment.user_id
        end
        @module_group_user_id = {module_group_id.to_i => user_ids}
        user_ids = []
        @module_group_user_ids.merge!(@module_group_user_id)
      end
      js_env :MODULE_PERMISSION_USER_IDS => @module_group_user_ids
    end
  end


  def update
    if authorized_action(@context.context_modules.new, @current_user, :update)
      @user_module_enrollment = UserModuleEnrollment.find_or_create_by_user_id_and_context_module_id(params[:user_id],params[:module_id])
      respond_to do |format|
        format.json {
          if params[:status] == UserModuleEnrollment::ACTIVE
            @user_module_enrollment.workflow_state = UserModuleEnrollment::ACTIVE
            @user_module_enrollment.save!
            render :json => @user_module_enrollment
          else
            @user_module_enrollment.workflow_state = UserModuleEnrollment::DELETED
            @user_module_enrollment.save!
            render :json => @user_module_enrollment
          end
        }
        end
    end
  end

end
