class TopicsController < ApplicationController

  include TopicsHelper

  def create
    @topic = Topic.new(name:params['name'],color:params['color'],account_id:params['account_id'],parent_id:params['parent_id'])
    respond_to do |format|
      if @topic.save
        format.json {render :json => @topic.to_json}
      else
        format.json { render :json => @topic.errors.to_json, :status => :bad_request }
      end
    end
  end
  def index
    #respond_to do |format|
      @topics = @domain_root_account.topics
      @topics = @topics.order('created_at DESC')
      @topic_map = @topics.map(&:attributes).to_json
      respond_to do |format|
        format.json { render json: @topic_map }
      end
    end
  def destroy
    @topic = Topic.find(params[:id])
    respond_to do |format|
      if @topic.destroy
        format.json { render :json => @topic }
      else
        format.json { render :json => @topic.errors.to_json, :status => :bad_request }
      end
    end
  end
  def edit
    @topic = Topic.find(params[:id])
  end
  #
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      @topic = @topic.update_attributes(name:params['name'],color:params['color'])
      if @topic

        format.json { render :json => @topic }

      else
        format.json { render :json => @topic.errors.to_json, :status => :bad_request }
      end
    end
  end

end
