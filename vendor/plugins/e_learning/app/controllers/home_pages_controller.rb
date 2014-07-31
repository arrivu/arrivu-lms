class HomePagesController < ApplicationController
  include ELearningHelper
  before_filter :require_context, :only => [:add_logo]
  before_filter :set_e_learning
  before_filter :check_private_e_learning, :only => [:index]
  before_filter :check_e_learning, :only => [:index]

  def index
      hash = {}
      cached_hash = get_cached_values
      hash[:add_image_url] = cached_hash[:account_sliders_path]
      hash[:context_asset_string] = cached_hash[:account_asset_string]
      hash[:Account_Statistics] = cached_hash[:statistics]
      hash[:account_has_sliders] = cached_hash[:account_sliders]
      hash[:add_knowledge_partners_url] = cached_hash[:account_knowledge_partners_path]
      hash[:popular_courses_count] = true if cached_hash[:popular_courses_count]
      hash[:show_knowledge_banner] = true if cached_hash[:show_knowledge_banner]
      hash[:enable_account_statistics] = true if cached_hash[:enable_account_statistics]
      hash[:show_popular] = true if cached_hash[:show_popular]
      hash[:PERMISSIONS] = get_user_permission
      js_env hash
  end

  def get_cached_values
    cached_hash = Rails.cache.fetch(['account_statistics', @domain_root_account.try(:id)].cache_key, :expires_in => 1.day) do
      cached_hash = {}
      cached_hash[:account_sliders_path] = account_sliders_path(@domain_root_account.id)
      cached_hash[:account_asset_string] = @domain_root_account.try(:asset_string)
      cached_hash[:account_sliders] = @domain_root_account.account_sliders.size > 0
      cached_hash[:account_knowledge_partners_path] = account_knowledge_partners_path(@domain_root_account)
      cached_hash[:popular_courses_count] = PopularCourse.find(:all).size > 6 rescue nil
      cached_hash[:show_knowledge_banner] = @domain_root_account.knowledge_partners.size >= 1 rescue nil
      cached_hash[:enable_account_statistics] = @domain_root_account.settings[:account_statistics]
      cached_hash[:show_popular] = @domain_root_account.popular_courses.size > 0
      cached_hash[:statistics]  = {users_count: @domain_root_account.fast_all_users.count,courses_count: public_courses_count,
         modules_count:total_account_modules_count,topics_count:@domain_root_account.topics.count}
      cached_hash
    end
  end


  def get_user_permission
    user_permission = Rails.cache.fetch([@current_user.try(:id),'account_permission', @domain_root_account.try(:id)].cache_key, :expires_in => 1.day) do
      user_permission = { enable_links:  can_do((@account ||= @domain_root_account), @current_user, :manage_account_settings)}

    end
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
      if authorized_action((@account ||= @domain_root_account), @current_user, :manage_account_settings)
        respond_to do |format|
          @attachment.folder_id ||= @folder.id
          @attachment.workflow_state = nil
          @attachment.file_state = 'available'
          success = nil
          if params[:header_logo][:uploaded_data]
            unless params[:header_logo][:uploaded_data].content_type =~ /\Aimage\/.*\Z/
              success = nil
              @attachment.errors.add(:base, t('errors.validatee', "Upload failed, Select a valid file to upload."))
            else
              success = @attachment.update_attributes(params[:header_logo])
            end
          end
            deleted_attachments = @attachment.handle_duplicates(duplicate_handling)
          if success
            Rails.cache.delete(['logo_url', @account.try(:id)].cache_key)
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
    @account_courses =  @domain_root_account.associated_courses.active.available
      @account_courses.each do  |course|
        @modules_count = course.context_modules.active.size if course.context_modules
        @account_modules += @modules_count
      end
    @account_modules
  end

 def  public_courses_count
   @account_courses = []
   @published_courses = @domain_root_account.associated_courses.active.available
   if @published_courses.empty?
     @courses_count = 0
   else
   @published_courses.each do|publish_course|
     if publish_course.settings[:make_this_course_visible_on_course_catalogue]
       @account_courses << publish_course
       @courses_count = @account_courses.count
     end
   end
   end
   @courses_count
 end
end
