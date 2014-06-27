class TaggedCoursesController < ApplicationController
  include ELearningHelper

  before_filter :require_context
  before_filter :check_private_e_learning
  before_filter :set_e_learning
  before_filter :check_e_learning

  helper_method :course_pricing
  helper_method :getcourse_image
  helper_method :getcourse_teacher

  include TaggedCoursesHelper

  def index
    @result_courses = []
    @tag_id = params[:tag_id]
    @tagged_courses = ActsAsTaggableOn::Tagging.find_all_by_tag_id(@tag_id)
    @account_courses = @domain_root_account.associated_courses.active
    @tagged_courses.each do |tag_course|
       @course = @domain_root_account.associated_courses.active.find(tag_course.taggable_id)
       unless @course.nil?
         @course_image = @course.course_image
         @result_courses << @course
       end
    end
  end

  def getcourse_image(course,attachment)
    if attachment[:image] == "back_ground_image"
      background_image_attchment = Attachment.find(course.course_image.course_back_ground_image_attachment_id) rescue nil
      background_image =  file_download_url(background_image_attchment, { :verifier => background_image_attchment.uuid, :download => '1', :download_frd => '1' }) unless background_image_attchment.nil?
    elsif attachment[:image] == "image"
      image_attachment = Attachment.find(course.course_image.course_image_attachment_id) rescue nil
      image = file_download_url(image_attachment, { :verifier => image_attachment.uuid, :download => '1', :download_frd => '1' }) unless image_attachment.nil?
    end
  end

  def getcourse_teacher(course)
     @teacher = course.teacher_enrollments.first
     @user = User.find(@teacher.user_id) rescue nil
  end


end







