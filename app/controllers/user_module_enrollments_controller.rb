class UserModuleEnrollmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_enrollments_url }
  before_filter { |c| c.active_tab = "permissions" }
  def index
    if authorized_action(@context, @current_user, :read)
      js_env :COURSE_MODULES_FOR_ENROLLMENT => @context.context_modules.active.map(&:attributes)
      js_env :ENROLLED_COURSE_USERS => @context.students.map(&:attributes)
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
