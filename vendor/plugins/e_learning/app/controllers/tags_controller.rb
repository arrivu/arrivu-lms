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
    respond_to do |format|
      @account_tags = ActsAsTaggableOn::Tag.find_all_by_account_id(@domain_root_account)
        @account_tags = Api.paginate(@account_tags, self, api_v1_account_tags_url)
        format.json {render :json => @account_tags.map(&:attributes).to_json}
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

