class SlidersController < ApplicationController
  include Api::V1::Json
  include ELearningHelper
  before_filter :check_private_e_learning
  before_filter :check_e_learning
  before_filter :clear_slider_cache ,:except => [:index,:render_attachment_json]
  def index
    respond_to do |format|
      @sliders = Rails.cache.fetch(['sliders', @domain_root_account.try(:id)].cache_key) do
        @sliders = []
        @account_sliders = @domain_root_account.account_sliders
        @account_sliders.each_with_index do |slider, idx|
          attachment = Attachment.find(slider.account_slider_attachment_id)
          @slider_json =   api_json(attachment, @current_user, session, API_USER_JSON_OPTS).tap do |json|
            json[:id] = slider.id
            json[:slider_url] = file_download_url(attachment, { :verifier => attachment.uuid, :download => '1', :download_frd => '1' })
          end
          @sliders << @slider_json
        end
        @sliders
        end
      format.json {render :json => @sliders.to_json}
    end
  end

  def create
    add_account_sliders
  end

  def destroy
    @delete_slider = AccountSlider.find(params[:sliders_id])
    @attachment = Attachment.find(@delete_slider.account_slider_attachment_id)
    respond_to do |format|
      @attachment.delete
      if @delete_slider.delete
        format.json {render :json => @delete_slider.to_json}
      else
        format.json { render :json => @delete_slider.errors.to_json, :status => :bad_request }
      end
    end

  end

  def add_account_sliders
        if (folder_id = params[:accountslider].delete(:folder_id)) && folder_id.present?
          if @account
            @folder = @account.folders.active.find_by_id(folder_id)
          elsif @account
            @folder = @account.folders.active.find_by_id(folder_id)
          else
            @folder = @domain_root_account.folders.active.find_by_id(folder_id)
          end
        end
        @account ||= @domain_root_account
        @folder ||= Folder.unfiled_folder(@account)
        params[:accountslider][:uploaded_data] ||= params[:header_logo_uploaded_data]
        params[:accountslider][:uploaded_data] ||= params[:file]
        #params[:header_logo][:user] = @current_user
        params[:accountslider].delete :context_id
        params[:accountslider].delete :context_type
        duplicate_handling = params.delete :duplicate_handling
        @attachment ||= @account.attachments.build
        if authorized_action(@attachment, @current_user, :create)
          respond_to do |format|
            @attachment.folder_id ||= @folder.id
            @attachment.workflow_state = nil
            @attachment.file_state = 'available'
            success = nil
            if params[:accountslider][:uploaded_data]
              success = @attachment.update_attributes(params[:accountslider])
              @attachment.errors.add(:base, t('errors.server_error', "Upload failed, server error, please try again.")) unless success
            else
              @attachment.errors.add(:base, t('errors.missing_field', "Upload failed, expected form field missing"))
            end
            deleted_attachments = @attachment.handle_duplicates(duplicate_handling)
            if success
                @account_slider= AccountSlider.new(account_id: @domain_root_account.id,account_slider_attachment_id: @attachment.id )
              #if (params[:course_image_upload] == "back_ground_image")
              #  @context.back_ground_image_url=account_file_preview_path(@context,@attachment)
              #elsif(params[:course_image_upload] == "image")
              #  @context.image_url=account_file_preview_path(@context,@attachment)
              #end
              @account_slider.save
              format.json { return_to(params[:return_to], root_url)  }
              format.json do
                render_attachment_json(@attachment, deleted_attachments, @folder)
              end
              format.text do
                render_attachment_json(@attachment, deleted_attachments, @folder)
              end
            else
              #format.html { render :action => "new" }
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

  def clear_slider_cache
    Rails.cache.delete(['sliders', @domain_root_account.try(:id)].cache_key)
  end

end
