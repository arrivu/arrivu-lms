class LibrariesController < ApplicationController

  before_filter :require_user, :only => [:enrollment]

  def index
    js_env :context_asset_string => @domain_root_account.try(:asset_string)
  end

  def show
    if params[:id].present?
      get_course_and_price(params[:id])
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
      @comments = @context.comments.approved.recent.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def enrollment
    get_course_and_price(params[:library_id])
    if @context and (@course_pricing.to_i == 0)
      @enrollment = @context.enroll_student(@current_user, :enrollment_state => 'active')
      if @enrollment
        redirect_to course_url(@context)
      end
    else
      payment_confirm
    end
  end

  def payment_confirm
    get_course_and_price(params[:id])
    @grouped_payments = [[Payment.digital.build]]
  end


  def get_course_and_price(course_id)
    @context = Course.find(course_id)
    @course_pricing = CoursePricing.where('course_id = ? AND DATE(?) BETWEEN start_at AND end_at', @context.id, Date.today).first
  end
end
