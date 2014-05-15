class LearnersReviewsController < ApplicationController
  before_filter :require_context

  def index
    respond_to do |format|
      @domain_root_account.courses.each do |course|
       @course_comments = course.comments
       @comments =   api_json(course, @current_user, session, API_USER_JSON_OPTS).tap do |json|

        end
      end
      format.json {render :json => @learners_reviews.map(&:attributes).to_json}
    end
  end

end
