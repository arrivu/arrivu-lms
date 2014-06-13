class CoursePageCustomDesignsController < ApplicationController
  before_filter :require_context

 def create
   account =  @domain_root_account
   return unless authorized_action(@context, @current_user, :manage)
   respond_to do |format|
      if @context.static_content
         @static_content = @context.static_content.update_attributes(:content_type => params[:context_type],
                           :course_id => params[:course_id],:account_id=> @domain_root_account.id,
                           :workflow_state => 'active',
                          :page_desc => params[:course_details_page_design])
      else
        @static_content = @context.build_static_content(:content_type => params[:context_type],
                          :course_id => params[:course_id],:account_id=> account.id,
                          :workflow_state => 'active',
                          :page_desc => params[:course_details_page_design])
        @static_content.save!
      end
     if @static_content
       format.json {render :json => @static_content}
     else
       format.json { render :json => @static_content.errors, :status => :bad_request }
     end
   end
 end

  #course index custom design method
  def course_index_custom_design
    account =  @domain_root_account
    return unless authorized_action(account, @current_user, [:manage_account_settings])
    respond_to do |format|
      if  @context.static_content.find_by_content_type("Course_index")
        @course_index_content =  @context.static_content.find_by_content_type("Course_index")
        @static_content = @course_index_content.update_attributes(:content_type => params[:content_type],
                                                                    :course_id => params[:course_id],:account_id=> @domain_root_account.id,
                                                                    :workflow_state => 'active',
                                                                    :page_desc => params[:course_details_page_design])
      else
        @static_content = @context.static_content.build(:content_type => params[:content_type],
                                                        :course_id => params[:course_id],:account_id=> account.id,
                                                        :workflow_state => 'active',
                                                        :page_desc => params[:course_details_page_design])
        @static_content.save!
      end
      if @static_content
        format.json {render :json => @static_content}
      else
        format.json { render :json => @static_content.errors, :status => :bad_request }
      end
    end
  end

#  account_index_page_custom design method
  def account_index_custom_design
    account =  @domain_root_account
    return unless authorized_action(account, @current_user, [:manage_account_settings])
    respond_to do |format|
      if @context.static_content.find_by_content_type("Account_index")
        @account_index =@context.static_content.find_by_content_type("Account_index")
        @static_content = @account_index.update_attributes(:content_type => params[:content_type],
                                                                    :course_id => params[:course_id],:account_id=> @domain_root_account.id,
                                                                    :workflow_state => 'active',
                                                                    :page_desc => params[:account_index_page_content])
      else
        @static_content = @context.static_content.build(:content_type => params[:content_type],
                                                        :course_id => params[:course_id],:account_id=> account.id,
                                                        :workflow_state => 'active',
                                                        :page_desc => params[:account_index_page_content])
        @static_content.save!
      end
      if @static_content
        format.json {render :json => @static_content}
      else
        format.json { render :json => @static_content.errors, :status => :bad_request }
      end
    end
  end

end
