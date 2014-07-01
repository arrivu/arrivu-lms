class TagsController < ApplicationController
  include TagsHelper



  def context_tags
    respond_to do |format|
      format.html
      format.json { render json: tag_tokens(params[:q]) }
    end
  end

  #ActsAsTaggableOn::Tag.find_all_by_account_id(@domain_root_account)
  def index
    @total_course_tags = []
    respond_to do |format|
      if params[:source] == "course"
        @course_tags = ActsAsTaggableOn::Tagging.find_all_by_taggable_type("Course")
      else
        @course_tags = ActsAsTaggableOn::Tagging.find_all_by_taggable_type("DiscussionTopic")
      end
      @course_tags.each do |tag|
        @account_tags = ActsAsTaggableOn::Tag.find_all_by_id_and_account_id(tag.tag_id,@domain_root_account)
        @tag_name = @account_tags[0].name
        @course_json =   api_json(tag, @current_user, session, API_USER_JSON_OPTS).tap do |json|
          json[:id] = tag.tag_id
          json[:tag_name] = @tag_name
        end
        @total_course_tags << @course_json
      end
      @total_course_tags = Api.paginate(@total_course_tags, self, api_v1_account_tags_url)
      format.json {render :json => @total_course_tags}
    end
  end


  def update
    @tags = ActsAsTaggableOn::Tag.find_by_id(params[:id])
    respond_to do |format|
      @tags.update_attributes(name:params[:account_tags].strip.gsub(' ', '-'))
      format.json { render :json => @tags.to_json}
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find_by_id(params[:id])
    respond_to do |format|
      if @tag.destroy
        format.json { render :json => @tag }
      else
        format.json { render :json => @tag.errors.to_json, :status => :bad_request }
      end
    end
  end

  end

