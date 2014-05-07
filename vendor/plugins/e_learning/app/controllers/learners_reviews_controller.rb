class LearnersReviewsController < ApplicationController
  before_filter :require_context

  def create
    @learner_reviews = LearnerReview.new(account_id:params['account_id'],user_id:params['user_id'])
    respond_to do |format|
      if @learners_reviews.save
        format.json {render :json => @learner_reviews.to_json}
      end
    end
  end

  def destroy
    @learners_review = LearnerReview.find(params[:id])
    respond_to do |format|
      if  @learners_review.destroy
        format.json { render :json =>  @learners_review }
      else
        format.json { render :json =>  @learners_review.errors.to_json, :status => :bad_request }
      end
    end
  end

  def index
    respond_to do |format|
      @learners_reviews = @domain_root_account.learners_review
      format.json {render :json => @learners_reviews.map(&:attributes).to_json}
    end
  end

end
