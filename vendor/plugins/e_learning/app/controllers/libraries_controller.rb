class LibrariesController < ApplicationController
  before_filter :require_user, :only => [:enrollment,:payment_complete,:payment_confirm,:enrollment,:enroll_and_redirect]

  def index
    js_env :context_asset_string => @domain_root_account.try(:asset_string)
  end

  def show
    if params[:id].present?
      get_course_and_price(params[:id])
      get_course_images
      @comments = @context.comments.approved.recent.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def enrollment
    get_course_and_price(params[:library_id])
    if @context and (@course_pricing.nil? || @course_pricing.price.to_i == 0)
      enroll_and_redirect
    else
      redirect_to payment_confirm_path(@context)
    end
  end

  def enroll_and_redirect
    @enrollment = @context.enroll_student(@current_user, :enrollment_state => 'active')
      if @enrollment
        redirect_to course_url(@context)
      else
        redirect_to root_url
      end
  end

  def payment_confirm
    get_course_and_price(params[:course_id])
    @grouped_payments = [[Payment.new]]
    get_course_images
  end

  def payment_complete
    @payment = Payment.find(params[:payment_id])
    @context = @payment.course
    if (@payment.user_id == @current_user.id) && @payment.completed
      enroll_and_redirect
    end
  end

  def  get_course_images
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
  end

  def create_user
    @course = Course.find(params[:library_id])
    @context = @domain_root_account
    # Look for an incomplete registration with this pseudonym
    @pseudonym = @context.pseudonyms.active.custom_find_by_unique_id(params[:pseudonym][:unique_id])
    # Setting it to nil will cause us to try and create a new one, and give user the login already exists error
    @pseudonym = nil if @pseudonym && !['creation_pending', 'pending_approval'].include?(@pseudonym.user.workflow_state)

    manage_user_logins = @context.grants_right?(@current_user, session, :manage_user_logins)
    self_enrollment = params[:self_enrollment].present?
    allow_non_email_pseudonyms = manage_user_logins || self_enrollment && params[:pseudonym_type] == 'username'
    require_password = self_enrollment && allow_non_email_pseudonyms
    allow_password = require_password || manage_user_logins

    notify = value_to_boolean(params[:pseudonym].delete(:send_confirmation))
    notify = :self_registration unless manage_user_logins

    if params[:communication_channel]
      cc_type = params[:communication_channel][:type] || CommunicationChannel::TYPE_EMAIL
      cc_addr = params[:communication_channel][:address]
      skip_confirmation = value_to_boolean(params[:communication_channel][:skip_confirmation]) &&
          (Account.site_admin.grants_right?(@current_user, :manage_students) || Account.default.grants_right?(@current_user, :manage_students))
    else
      cc_type = CommunicationChannel::TYPE_EMAIL
      cc_addr = params[:pseudonym].delete(:path) || params[:pseudonym][:unique_id]
    end

    sis_user_id = params[:pseudonym].delete(:sis_user_id)
    sis_user_id = nil unless @context.grants_right?(@current_user, session, :manage_sis)

    @user = @pseudonym && @pseudonym.user
    @user ||= User.new
    if params[:user]
      params[:user].delete(:self_enrollment_code) unless self_enrollment
      @user.attributes = params[:user]
    end
    @user.name ||= params[:pseudonym][:unique_id]
    unless @user.registered?
      @user.workflow_state = if require_password
                               # no email confirmation required (self_enrollment_code and password
                               # validations will ensure everything is legit)
                               'registered'
                             elsif notify == :self_registration && @user.registration_approval_required?
                               'pending_approval'
                             else
                               'pre_registered'
                             end
    end
    @pseudonym ||= @user.pseudonyms.build(:account => @context)
    @pseudonym.account.email_pseudonyms = !allow_non_email_pseudonyms
    @pseudonym.require_password = require_password
    # pre-populate the reverse association
    @pseudonym.user = @user
    # don't require password_confirmation on api calls
    params[:pseudonym][:password_confirmation] = params[:pseudonym][:password] if api_request?
    # don't allow password setting for new users that are not self-enrolling
    # in a course (they need to go the email route)
    unless allow_password
      params[:pseudonym].delete(:password)
      params[:pseudonym].delete(:password_confirmation)
    end
    @pseudonym.attributes = params[:pseudonym]
    @pseudonym.sis_user_id = sis_user_id

    @pseudonym.account = @context
    @pseudonym.workflow_state = 'active'
    @cc =
        @user.communication_channels.where(:path_type => cc_type).by_path(cc_addr).first ||
            @user.communication_channels.build(:path_type => cc_type, :path => cc_addr)
    @cc.user = @user
    @cc.workflow_state = skip_confirmation ? 'active' : 'unconfirmed' unless @cc.workflow_state == 'confirmed'

    if @user.valid? && @pseudonym.valid?
      respond_to do |format|
      # saving the user takes care of the @pseudonym and @cc, so we can't call
      # save_without_session_maintenance directly. we don't want to auto-log-in
      # unless the user is registered/pre_registered (if the latter, he still
      # needs to confirm his email and set a password, otherwise he can't get
      # back in once his session expires)
       # automagically logged in
        PseudonymSession.new(@pseudonym).save unless @pseudonym.new_record?
      @user.save!
      message_sent = false
        unless @user.pending_approval? || @user.registered?
          message_sent = true
        end
        @user.new_registration((params[:user] || {}).merge({:remote_ip  => request.remote_ip, :cookies => cookies}))
        @pseudonym.send_registration_notification!
        format.html {redirect_to library_enrollments_path(@course)}
    end
    else
      errors = {
          :errors => {
              :user => @user.errors.as_json[:errors],
              :pseudonym => @pseudonym ? @pseudonym.errors.as_json[:errors] : {}
          }
      }
      render :json => errors, :status => :bad_request
    end
  end

  def get_course_and_price(course_id)
    @context = Course.find(course_id)
    @course_pricing = CoursePricing.where('course_id = ? AND DATE(?) BETWEEN start_at AND end_at', @context.id, Date.today).first
  end
end
