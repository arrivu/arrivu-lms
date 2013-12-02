class UserModuleEnrollmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_enrollments_url }
  before_filter { |c| c.active_tab = "permissions" }
  def index
    js_env :COURSE_MODULES_FOR_ENROLLMENT => @context.context_modules.map(&:attributes).to_json
    js_env :ENROLLED_COURSE_USERS => @context.students.map(&:attributes).to_json
  end

  def new

  end

  def create

  end

  def destroy

  end

  def update

  end

end
