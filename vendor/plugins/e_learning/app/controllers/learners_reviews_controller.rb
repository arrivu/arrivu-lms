class LearnersReviewsController < ApplicationController
  include ELearningHelper
  before_filter :require_context
  before_filter :check_private_e_learning
  before_filter :check_e_learning

  def index
    respond_to do |format|
      @all_courses_comments = []
      @domain_root_account.associated_courses.active.sample(8).each do |course|
            comment = course.comments.approved.first
            unless comment.nil?
             @comments =   api_json(comment, @current_user, session, API_USER_JSON_OPTS).tap do |json|
               json[:id] = course.id
               json[:comment] = comment.comment
               json[:user_name] = comment.user.name
               json[:user_avatar] = comment.user.avatar_image_url
             end
            @all_courses_comments << @comments
            end
         end
         format.json {render :json => @all_courses_comments.to_json}
    end
    end

  end

