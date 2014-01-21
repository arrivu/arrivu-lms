class UserModuleGroupEnrollmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_group_enrollments_url }
  def index
    if authorized_action(@context, @current_user, :read)
      @context_module_groups = @context.context_module_groups.active
      js_env :COURSE_MODULE_GROUPS_FOR_ENROLLMENT => @context_module_groups.map(&:attributes)
      js_env :ENROLLED_COURSE_USERS => @context.students.map(&:attributes)
      js_env :COURSE_ID => @context.id
      # { 1:  [2,3,4]}
      # module_group_id: user_id array of user ids
      @module_group_user_ids = {}
      user_ids = []
      @context_module_groups.each do |context_module_group|
        module_group_id = context_module_group.id
        @user_module_group_enrollments = UserModuleGroupEnrollment.where(context_module_group_id: module_group_id ,workflow_state: UserModuleGroupEnrollment::ACTIVE)
        @user_module_group_enrollments.each do |user_module_group_enrollment|
          user_ids << user_module_group_enrollment.user_id
        end
        @module_group_user_id = {module_group_id.to_i => user_ids}
        user_ids = []
        @module_group_user_ids.merge!(@module_group_user_id)
      end
      js_env :MODULE_GROUP_PERMISSION_USER_IDS => @module_group_user_ids
    end
  end


  def update
    if authorized_action(@context.context_modules.new, @current_user, :update)
      @user_module_group_enrollment = UserModuleGroupEnrollment.find_or_create_by_user_id_and_context_module_group_id(params[:user_id],params[:module_id])
      respond_to do |format|
        format.json {
          if params[:status] == UserModuleGroupEnrollment::ACTIVE
            @user_module_group_enrollment.workflow_state = UserModuleGroupEnrollment::ACTIVE
            @user_module_group_enrollment.save!
            render :json => @user_module_group_enrollment
          else
            @user_module_group_enrollment.workflow_state = UserModuleGroupEnrollment::DELETED
            @user_module_group_enrollment.save!
            render :json => @user_module_group_enrollment
          end
        }
        end
    end
  end

end