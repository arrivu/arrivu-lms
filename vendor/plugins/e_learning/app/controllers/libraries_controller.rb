class LibrariesController < ApplicationController
  def index
    js_env :context_asset_string => @domain_root_account.try(:asset_string)
  end
end
