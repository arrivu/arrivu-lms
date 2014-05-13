class LibrariesController < ApplicationController

  def index
    js_env :context_asset_string => @domain_root_account.try(:asset_string)
  end

  def show
    if params[:id].present?
      @context = Course.find(params[:id])
      if @context.course_image and !@context.course_image.course_back_ground_image_attachment_id.nil?
        attachment = Attachment.find(@context.course_image.course_back_ground_image_attachment_id)
       unless attachment.nil?
         @context_bg_image_url = file_download_url(attachment, { :verifier => attachment.uuid, :download => '1', :download_frd => '1' })
       end
      end
      if @context.course_image and !@context.course_image.course_image_attachment_id.nil?
        attachment = Attachment.find(@context.course_image.course_image_attachment_id)
        unless attachment.nil?
          @context_image_url = file_download_url(attachment, { :verifier => attachment.uuid, :download => '1', :download_frd => '1' })
        end
      end

      @course_pricing = CoursePricing.where('course_id = ? AND DATE(?) BETWEEN start_at AND end_at', @context.id, Date.today).first

    end
  end
end
