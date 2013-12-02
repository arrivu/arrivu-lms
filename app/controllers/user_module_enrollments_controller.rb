class UserModuleEnrollmentsController < ApplicationController
  before_filter :require_context
  add_crumb(proc { t('#crumbs.permissions', "Permissions") }) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_user_module_enrollments_url }
  before_filter { |c| c.active_tab = "permissions" }
  def index

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
