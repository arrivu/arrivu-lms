require "#{Rails.root}/vendor/plugins/wistia/lib/wistia/wistia_video_api"
class VideosController < ApplicationController

  def  list_collections
    if WistiaVideoAPI.enabled?
      WistiaVideoAPI.list_collections

    end
  end

  def get_collection
    if WistiaVideoAPI.enabled?
      WistiaVideoAPI.get_collection(params[:collection_id])
    end
  end

end
