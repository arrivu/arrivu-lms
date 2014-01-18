class StatsController < ApplicationController
  include Common
  before_filter :require_user
  def index
    @current_term = current_term
    @terms = Account.default.enrollment_terms.find(:all, :conditions => "workflow_state = 'active'", :order => 'sis_source_id DESC')
    @enrollments = enrollments_for_term(current_term)
    if @current_term.nil?
      @current_term = @terms.first
    end
  end

  def courses

    respond_to do |format|

      format.html do
        @courses_for_term = courses_for_term(params[:term_id])
        render :partial => 'courses_table', :content_type => 'text/html'
      end

      format.json do
        aaData = courses_for_term(params[:term_id], "id, sis_source_id, name, course_code, workflow_state, account_id")
        aaData.map! do |course|
          [
            course.id,
            course.sis_source_id,
            course.name,
            course.course_code,
            course.workflow_state,
            course.account_id
          ]
        end
        render :json => { :aaData => aaData }
      end

    end
  end

  def enrollments
    respond_to do |format|
      format.json do
        render :json => enrollments_for_term(params[:term_id])
      end
    end
  end

  def show
    if authorized_action(@context, @current_user, [:manage_grades, :view_all_grades])
      @gradebook_is_editable = @context.grants_right?(@current_user, session, :manage_grades)
      per_page = Setting.get_cached('api_max_per_page', '50').to_i
      js_env  :GRADEBOOK_OPTIONS => {
          :chunk_size => Setting.get_cached('gradebook2.submissions_chunk_size', '35').to_i,
          :assignment_groups_url => api_v1_course_assignment_groups_url(@context, :include => [:assignments], :override_assignment_dates => "false"),
          :sections_url => api_v1_course_sections_url(@context),
          :students_url => api_v1_course_enrollments_url(@context, :include => [:avatar_url], :type => ['StudentEnrollment', 'StudentViewEnrollment'], :per_page => per_page),
          :students_url_with_concluded_enrollments => api_v1_course_enrollments_url(@context, :include => [:avatar_url], :type => ['StudentEnrollment', 'StudentViewEnrollment'], :state => ['active', 'invited', 'completed'], :per_page => per_page),
          :submissions_url => api_v1_course_student_submissions_url(@context, :grouped => '1'),
          :change_grade_url => api_v1_course_assignment_submission_url(@context, ":assignment", ":submission"),
          :context_url => named_context_url(@context, :context_url),
          :download_assignment_submissions_url => named_context_url(@context, :context_assignment_submissions_url, "{{ assignment_id }}", :zip => 1),
          :re_upload_submissions_url => named_context_url(@context, :submissions_upload_context_gradebook_url, "{{ assignment_id }}"),
          :context_id => @context.id,
          :context_code => @context.asset_string,
          :group_weighting_scheme => @context.group_weighting_scheme,
          :grading_standard =>  @context.grading_standard_enabled? && (@context.grading_standard.try(:data) || GradingStandard.default_grading_standard),
          :course_is_concluded => @context.completed?,
          :gradebook_is_editable => @gradebook_is_editable,
          :speed_grader_enabled => @context.allows_speed_grader?,
          :draft_state_enabled => @context.draft_state_enabled?,
      }


    end
  end

  private
  def current_term
    #EnrollmentTerm.find(:all, :conditions => ["workflow_state = 'active' AND (:date BETWEEN start_at AND end_at)", {:date => DateTime.now}]).first
    EnrollmentTerm.find(:all, :conditions => ["workflow_state = 'active'" ],:order => 'id ASC' ).first
  end

  def courses_for_term(term_id, fields='*')
    if term_id == 'current'
      term_id = current_term
    end
    workflow_state_translation = {
      "available" => "published",
      "claimed" => "unpublished",
      "completed" => "concluded"
    }
    courses = EnrollmentTerm.find(term_id).courses.find(:all, :select => fields, :conditions => ["workflow_state != 'deleted'"])
    courses.each { |course| course[:workflow_state] = workflow_state_translation[course[:workflow_state]] }
  end

  def enrollments_for_term(term_id, type=%w(total unique))
    if term_id == 'current'
      term_id = current_term
    end

    type = [type] if type.is_a? String

    enrollments = {}
    type.each do |t|
      enrollments[t] = send("#{t}_enrollments", term_id)
    end
    return enrollments
  end

  def prep_enrollment_hash
    {"StudentEnrollment"=>0, "TeacherEnrollment"=>0, "TaEnrollment"=>0, "DesignerEnrollment"=>0, "ObserverEnrollment"=>0, "StudentViewEnrollment"=>0}
  end

  def unique_enrollments(term_id)
    prep_enrollment_hash.merge Enrollment.count(:select => "enrollments.user_id", :joins => :course, :distinct => true, :conditions => ["courses.workflow_state != 'deleted' AND enrollments.root_account_id = "+Account.default.id.to_s+" AND enrollments.course_id = courses.id AND courses.enrollment_term_id = ? AND courses.sis_source_id IS NOT NULL AND enrollments.workflow_state = 'active'", term_id], :group => 'enrollments.type')
  end

  def total_enrollments(term_id)
    # this is probably not very efficient but I can't seem to come up with a better way,
    # and plus it's pretty explicit in what it's doing
    courses = Course.all(:conditions => ["root_account_id ="+Account.default.id.to_s+" AND enrollment_term_id = ? AND workflow_state != 'deleted'", term_id])
    types = ['StudentEnrollment', 'TeacherEnrollment', 'TaEnrollment', 'DesignerEnrollment', 'ObserverEnrollment', 'StudentViewEnrollment']
    total_enrollments = prep_enrollment_hash
    courses.each do |c|
      enrollments = c.enrollments.count(:distinct => true, :group => 'enrollments.type', :select => 'users.id', :conditions => 'enrollments.role_name IS NULL')
      enrollments.each do |type, num|
        total_enrollments[type] = (total_enrollments[type] + num)
      end
    end
    total_enrollments
  end
end
