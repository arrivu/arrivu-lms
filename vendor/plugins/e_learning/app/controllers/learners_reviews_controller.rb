class LearnersReviewsController < ApplicationController
  before_filter :require_context

  def index
    respond_to do |format|
      @total_count = 0
      @all_courses_comments = []
      @domain_root_account.courses.each do |course|
         @course_comments = course.comments
         course.comments.each do |course_comment|
           unless course_comment.is_approved
             @comments =   api_json(course_comment, @current_user, session, API_USER_JSON_OPTS).tap do |json|
               json[:comments] = ""
               json[:user] = ""
             end
             @all_courses_comments << @comments
           else
             @total_count += 1
            if @total_count < 4
             @comments =   api_json(course_comment, @current_user, session, API_USER_JSON_OPTS).tap do |json|
               json[:show_comment] = true
               json[:comments] = course_comment.comment
               json[:user] = User.find(course_comment.user_id) rescue nil
             end
            else
              @comments =   api_json(course_comment, @current_user, session, API_USER_JSON_OPTS).tap do |json|
                json[:show_comment] = false
              end
            end
            @all_courses_comments << @comments
         end

         end
         format.json {render :json => @all_courses_comments.to_json}
    end

  end
end
end
