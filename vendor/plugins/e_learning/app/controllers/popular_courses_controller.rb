class PopularCoursesController < ApplicationController

  def index
    #account courses list
    respond_to do |format|
      @courses = []
      @account_courses = @domain_root_account.courses.active
      @account_courses.each_with_index do |course, idx|
        @teachers = course.teacher_enrollments
        @teacher_desc = instructure_details(course)
        @course_image = course.course_image
        if course.tags.nil?
          @course_tags_count = 0
        else
          @course_tags_count = course.tags.count
        end

        @users_count = course.users.count
        @course_tags = tag_details(course)
        if course.popular_course
          @popular_course = true
          @popular_id = course.popular_course.id
        else
          @popular_course = false
        end
        if course.course_description
          @course_desc = CourseDescription.find(course.id) rescue nil
          @short_course_desc = truncate_text(@course_desc.long_description, :length =>40)
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
        end
        @courses << @course_json
      end
      format.json {render :json => @courses.to_json}

      end
  end

  def instructure_details(course)
    @instructure_details = []
    @teachers = course.teacher_enrollments
    @teachers.each do |teacher|
      @user_id = User.find(teacher.user_id)
      if @user_id.profile.bio !=nil && @user_id.profile.title !=nil
        @profile = truncate_text(@user_id.profile.bio,:length => 30)

        if @user_id.avatar_image_url.nil?
          @profile_pict = "/images/User.png"
        else
          @profile_pict = @user_id.avatar_image_url
        end
      end
        @instructue_json =   api_json(course,@current_user, session, API_USER_JSON_OPTS).tap do |json|
          json[:teacher_desc] = @profile
          json[:teacher_image] = @profile_pict
        end
      @instructure_details << @instructue_json
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
