class TagsController < ApplicationController
  include TagsHelper



  def context_tags
    respond_to do |format|
      format.html
      format.json { render json: tag_tokens(params[:q]) }
    end
  end
end
