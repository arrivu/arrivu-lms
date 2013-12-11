class TagsController < ApplicationController
  include Api
  include LocaleSelection
  include Api::V1::User
  around_filter :set_locale

  helper :all

  include AuthenticationMethods
  protect_from_forgery
  # load_user checks masquerading permissions, so this needs to be cleared first
  before_filter :clear_cached_contexts
  before_filter :load_account, :load_user
  before_filter :check_pending_otp
  before_filter :set_user_id_header
  before_filter :set_time_zone
  before_filter :set_page_view
  before_filter :refresh_cas_ticket
  before_filter :require_reacceptance_of_terms
  after_filter :log_page_view
  after_filter :discard_flash_if_xhr
  after_filter :cache_buster
  # Yes, we're calling this before and after so that we get the user id logged
  # on events that log someone in and log someone out.
  after_filter :set_user_id_header
  before_filter :fix_xhr_requests
  before_filter :init_body_classes
  after_filter :set_response_headers
  after_filter :update_enrollment_last_activity_at
  before_filter :get_wiki_type
  include Tour
  include TagsHelper



  def discussion_topic_tags
    respond_to do |format|
      format.html
      format.json { render json: tag_tokens(params[:q]) }
    end
  end
end
