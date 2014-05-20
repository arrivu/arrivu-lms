class KnowledgePartnersController < ApplicationController

  before_filter :require_context

  def index
    respond_to do |format|
      @knowledge_partners = []
      @account_knowledge_partners = @domain_root_account.knowledge_partners
      @account_knowledge_partners.each_with_index do |knowledge_partner, idx|
        attachment = Attachment.find(knowledge_partner.knowledge_partners_attachment_id)
        @knowledge_partner_json =   api_json(attachment, @current_user, session, API_USER_JSON_OPTS).tap do |json|
          json[:id] = knowledge_partner.id
          json[:partners_info] = knowledge_partner.partners_info
          json[:knowledge_partner_log_url] = file_download_url(attachment, { :verifier => attachment.uuid, :download => '1', :download_frd => '1' })
        end
        @knowledge_partners << @knowledge_partner_json
      end
      format.json {render :json => @knowledge_partners.to_json}
    end
  end

  def create
    add_knowledge_partners
  end

  def add_knowledge_partners
    if (folder_id = params[:knowledge_partner].delete(:folder_id)) && folder_id.present?
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
    params[:knowledge_partner][:uploaded_data] ||= params[:knowledge_partner_uploaded_data]
    params[:knowledge_partner][:uploaded_data] ||= params[:file]
    #params[:header_logo][:user] = @current_user
    params[:knowledge_partner].delete :context_id
    params[:knowledge_partner].delete :context_type
    duplicate_handling = params.delete :duplicate_handling
    @attachment ||= @account.attachments.build
    if authorized_action(@attachment, @current_user, :create)
      respond_to do |format|
        @attachment.folder_id ||= @folder.id
        @attachment.workflow_state = nil
        @attachment.file_state = 'available'
        success = nil
        if params[:knowledge_partner][:uploaded_data]
          success = @attachment.update_attributes(params[:knowledge_partner])
          @attachment.errors.add(:base, t('errors.server_error', "Upload failed, server error, please try again.")) unless success
        else
          @attachment.errors.add(:base, t('errors.missing_field', "Upload failed, expected form field missing"))
        end
        deleted_attachments = @attachment.handle_duplicates(duplicate_handling)
        if success
          @knowledge_partners = KnowledgePartner.new(account_id: @domain_root_account.id,knowledge_partners_attachment_id: @attachment.id,partners_info: params[:knowledge_partner_info])
          @knowledge_partners.save
          format.html { return_to(params[:return_to], root_url)}
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

  def destroy
    @knowledge_partner = KnowledgePartner.find(params[:knowledge_partners_id])
    @attachment = Attachment.find(@knowledge_partner.knowledge_partners_attachment_id)
    respond_to do |format|
      @attachment.delete
      if  @knowledge_partner.delete
        format.json { render :json =>  @knowledge_partner }
      else
        format.json { render :json =>  @knowledge_partner.errors.to_json, :status => :bad_request }
      end
    end
  end

end
