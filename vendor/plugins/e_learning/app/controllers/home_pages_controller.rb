class HomePagesController < ApplicationController
  include ELearningHelper
  before_filter :require_context, :only => [:add_logo]
  before_filter :set_e_learning
  before_filter :check_private_e_learning, :only => [:index]
  before_filter :check_e_learning, :only => [:index]

  def index
    js_env :add_image_url => account_sliders_path(@domain_root_account.id)
    js_env :context_asset_string => @domain_root_account.try(:asset_string)
    js_env :account_id => @domain_root_account.id
    js_env :PERMISSIONS => { enable_links:  can_do((@account ||= @domain_root_account), @current_user, :manage_account_settings)}
    js_env :Account_Statistics => {
          users_count: @domain_root_account.users.count,
          courses_count: @domain_root_account.courses.count,
          modules_count:total_account_modules_count,
          topics_count:@domain_root_account.topics.count
    }
    js_env :account_has_sliders => @domain_root_account.account_sliders.count > 0
    js_env :add_knowledge_partners_url => account_knowledge_partners_path(@domain_root_account)
    js_env :popular_courses_count => true if PopularCourse.find(:all).count > 6 rescue nil
    js_env :show_knowledge_banner => true if @domain_root_account.knowledge_partners.count >= 1 rescue nil
    js_env :enable_account_statistics => true if @domain_root_account.settings[:account_statistics]
  end


  def add_logo
    add_header_logo_image
  end

  def add_header_logo_image
      if (folder_id = params[:header_logo].delete(:folder_id)) && folder_id.present?
        if @account
         @folder = @account.folders.active.find_by_id(folder_id)
        elsif @account
         @folder = @account.folders.active.find_by_id(folder_id)
        else
          @folder = @account.folders.active.find_by_id(folder_id)
        end
      end
      @folder ||= Folder.unfiled_folder(@account)
      params[:header_logo][:uploaded_data] ||= params[:header_logo_uploaded_data]
      params[:header_logo][:uploaded_data] ||= params[:file]
      #params[:header_logo][:user] = @current_user
      params[:header_logo].delete :context_id
      params[:header_logo].delete :context_type
      duplicate_handling = params.delete :duplicate_handling
      @attachment ||= @account.attachments.build
      if authorized_action(@context, @current_user, :manage_account_settings)
        respond_to do |format|
          @attachment.folder_id ||= @folder.id
          @attachment.workflow_state = nil
          @attachment.file_state = 'available'
          success = nil
          if params[:header_logo][:uploaded_data]
            success = @attachment.update_attributes(params[:header_logo])
            @attachment.errors.add(:base, t('errors.server_error', "Upload failed, server error, please try again.")) unless success
          else
            @attachment.errors.add(:base, t('errors.missing_field', "Upload failed, expected form field missing"))
          end
            deleted_attachments = @attachment.handle_duplicates(duplicate_handling)
          if success
            if @account.account_header.nil?
              @account.build_account_header(account_id: @domain_root_account.id,header_logo_url: @attachment.id )
            else
              @prev_attachment = Attachment.find(@account.account_header.header_logo_url)
              @prev_attachment.destroy
              @account.account_header.update_attributes(account_id: @domain_root_account.id,header_logo_url: @attachment.id)
            end
            @account.save
            format.html { return_to(params[:return_to], named_context_url(@account, :context_files_url))  }
            format.json do
              render_attachment_json(@attachment, deleted_attachments, @folder)
            end
            format.text do
              render_attachment_json(@attachment, deleted_attachments, @folder)
            end
          else
            format.html { render :action => "new" }
            format.json { render :json => @attachment.errors }
            format.text { render :json => @attachment.errors }
          end
        end
      end
  end


  def render_attachment_json(attachment, deleted_attachments, folder = attachment.folder)
    json = {
        :attachment => attachment.as_json(
            allow: :uuid,
            methods: [:uuid,:readable_size,:mime_class,:currently_locked,:scribdable?,:thumbnail_url],
            permissions: {user: @current_user, session: session},
            include_root: false
        ),
        :deleted_attachment_ids => deleted_attachments.map(&:id)
    }
    if folder.name == 'profile pictures'
      json[:avatar] = avatar_json(@current_user, attachment, { :type => 'attachment' })
    end

    render :json => json, :as_text => true
  end

  def total_account_modules_count
    @account_modules = 0
    @account_courses = @domain_root_account.courses
      @account_courses.each do  |course|
        @modules_count = course.context_modules.active.size if course.context_modules
        @account_modules += @modules_count
      end
    @account_modules
    end

end
