class CourseDescriptionsController < ApplicationController
  before_filter :require_context

  def create
    if @context.course_description.nil?
      @course_desc = @context.build_course_description(course_id:params['course_id'],short_description:params['short_description'],long_description:params['long_description'])
      @course_desc.account_id=Course.find_by_account_id(@context.account_id).id
      @course_desc.save
    else
      @course_desc = @context.course_description.update_attributes(course_id:params['course_id'],short_description:params['short_description'],long_description:params['long_description'],account_id:Course.find_by_account_id(@context.account_id).id)
    end
    respond_to do |format|
      if params['short_description'].empty? && params['long_description'].empty?
        format.json { render :json => "Enter Both Descriptions",:status => :error }
      elsif params['long_description'].empty?
        format.json { render :json => "Enter Brief Description", :status => :error }
      elsif params['short_description'].empty?
        format.json { render :json => "Enter Short Description", :status => :error }
      elsif @course_desc
        format.json { render :json =>  @course_desc}
      end
    end
  end
end

