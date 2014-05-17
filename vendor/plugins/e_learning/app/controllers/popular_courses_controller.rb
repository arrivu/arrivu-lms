class PopularCoursesController < ApplicationController

  def index
    #account courses list
    @show_banner = false
    @total_popular_course_count = 0
    respond_to do |format|
      @courses = []
      if  params[:topic_id].present? and params[:topic_id].to_i != 0
        @account_courses = @domain_root_account.courses.not_deleted.find_all_by_topic_id(params[:topic_id])
      else
        @account_courses = @domain_root_account.courses.not_deleted
      end
      @account_courses.each_with_index do |course, idx|
        @teachers = course.teacher_enrollments
        @teacher_desc = instructure_details(course)
        @course_image = course.course_image
        @course_topic = course_topic(course)
        @course_pricing = CoursePricing.where('course_id = ? AND DATE(?) BETWEEN start_at AND end_at', course.id, Date.today).first
        @course_modules = course.context_modules.nil? ? false :  course.context_modules.size if course.context_modules
        if @course_pricing.nil?
          @show_course_price = false

        else
          @show_course_price = true
          @course_pricing
        end
        if@course_image.nil?
          @has_course_image = false
        else
          @has_course_image = true
        end
        @course_tags_count = course.tags.count.nil? ? 'false' : course.tags.count if course.tags
        @users_count = course.student_enrollments.count.nil? ? "false" : course.student_enrollments.count
        @course_tags = tag_details(course)
        if course.popular_course
          @popular_course = true
          @total_popular_course_count += 1
          if @total_popular_course_count >= 7
            @show_only_six_courses = true
          else
            @show_only_six_courses = false
          end
          @popular_id = course.popular_course.id
        else
          @popular_course = false
        end
        if course.course_description
          @course_desc = CourseDescription.find(course.course_description.id) rescue nil
          @short_course_desc = @course_desc.short_description
        else
          @short_course_desc = ""
        end
        image_attachment = Attachment.find(@course_image.course_image_attachment_id) rescue nil
        background_image_attchment = Attachment.find(@course_image.course_back_ground_image_attachment_id) rescue nil
        @course_json =   api_json(course, @current_user, session, API_USER_JSON_OPTS).tap do |json|
          json[:id] = course.id
          json[:popular_id] = @popular_id
          json[:course_name] = course.name
          json[:course_image] = file_download_url(image_attachment, { :verifier => image_attachment.uuid, :download => '1', :download_frd => '1' }) unless image_attachment.nil?
          json[:course_background_image] = file_download_url(background_image_attchment, { :verifier => background_image_attchment.uuid, :download => '1', :download_frd => '1' }) unless background_image_attchment.nil?
          json[:users_count] = @users_count
          json[:tags_count] = @course_tags_count
          json[:course_tags] = @course_tags
          json[:course_short_decription] = @short_course_desc
          json[:popular_course] = @popular_course
          json[:each_tag_count] = @each_tag_counts
          json[:profile_data] =  @teacher_desc
          json[:has_course_image] = @has_course_image
          json[:course_topic_details] = @course_topic
          json[:show_only_six_courses] = @show_only_six_courses
          json[:show_course_price] =  @show_course_price
          json[:course_price] = @course_pricing
          json[:course_modules] = @course_modules
          json[:popular_course_count] = @popular_course_count
        end
        @courses << @course_json
      end
      format.json {render :json => @courses.to_json}
    end
  end

  def instructure_details(course)
    @instructure_details = []
    @teachers = course.teacher_enrollments
    if @teachers.empty?
      @instructue_json =   api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
        json[:teacher_desc] = "No Teachers Enrolled to this Course"
      end
      @instructure_details << @instructue_json
    else
    @teachers.each do |teacher|
      @user_id = User.find(teacher.user_id)
      if @user_id.profile.bio !=nil && @user_id.profile.title !=nil
        @profile = @user_id.profile.bio
        if @user_id.avatar_image_url.nil?
          @profile_pict = "/images/User.png"
        else
          @profile_pict = @user_id.avatar_image_url
        end
        @instructue_json =   api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
          json[:teacher_desc] = @profile
          json[:teacher_image] = @profile_pict
        end
      else
        @instructue_json =   api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
          json[:teacher_desc] = false
        end
      end
      @instructure_details << @instructue_json
    end
    end
    @instructure_details
  end

  def tag_details(course)
    @tag_json_details = []
    @tags = course.tags.limit(3)
    @tags .each do |tag|
      @each_tag_counts = ActsAsTaggableOn::Tagging.find_all_by_tag_id(tag).count
      @tag_id = tag.id
      @tag_name = tag.name
      @tag_json =  api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
        json[:tag_id] = tag.id
        json[:tag_name] = tag.name
        json[:each_tag_count] = @each_tag_counts
      end
      @tag_json_details << @tag_json
    end
    @tag_json_details
  end

  def course_topic(course)
    @course_topic = []
    @topic = course.topic
    if @topic.nil?
      @topic_json = api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
        json[:has_topic] = false
      end
      @course_topic <<@topic_json
    else
    @topic_json = api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
      json[:topic_name] = @topic.name
      json[:topic_color] = @topic.color
      json[:has_topic] = true
    end
    @course_topic <<@topic_json
    end
     @course_topic
  end


  def create
    @popular_course = PopularCourse.new(course_id: params['popular_course_data']['popular_course_id'],account_id: params['popular_course_data']['account_id'])
    respond_to do |format|
      if @popular_course.save
        format.json { render :json => @popular_course.to_json}
      end
    end
  end

  def destroy
    @delete_popular_course_item = PopularCourse.find(params['popular_course_data']['popular_course_id'])
    respond_to do |format|
      @delete_popular_course_item.delete
      if @delete_popular_course_item.delete
        format.json {render :json => @delete_popular_course_item.to_json}
      else
        format.json { render :json => @delete_popular_course_item.errors.to_json, :status => :bad_request }
      end
    end
  end
end