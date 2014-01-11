class ContextModuleGroupsController < ApplicationController
  before_filter :require_context

  def new

  end

  def create
    if authorized_action(@context.context_modules.new, @current_user, :create)
     @context_module_group = ContextModuleGroup.create!(:context_id=> @context.id, :context_type => @context.class.name,
                                                        :position => 1,:name => params[:context_module_group][:name],:workflow_state=> 'active')
      redirect_to course_context_modules_path(@context)
   end
  end

  def edit
    @context_module_group = ContextModuleGroup.find(params[:context_module_group][:id])
    respond_to do |format|
      if  @context_module_group.update_attributes(params[:context_module_group])
        format.json { render :json => @context_module_group.to_json(:include => :context_module_group_associations, :permissions => {:user => @current_user, :session => session}) }
      else
        format.json { render :json => @context_module_group.errors.to_json, :status => :bad_request }
      end
    end
  end

  def update
    @context_module_group = ContextModuleGroup.find(params[:id].to_i)
      if  @context_module_group.update_attributes(params[:context_module_group])
        redirect_to course_context_modules_path(@context)
      end
  end

  def destroy
    @context_module_group = ContextModuleGroup.find(params[:id].to_i)
    respond_to do |format|
      if  @context_module_group.destroy
        format.json { render :json => @context_module_group}
      else
        format.json { render :json => @context_module_group.errors.to_json, :status => :bad_request }
      end
    end
  end

end
