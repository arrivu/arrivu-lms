#
# Copyright (C) 2011 - 2013 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

# @API Conferences
#
# API for accessing information on conferences.
#
# @model ConferenceRecording
#     {
#       "id": "ConferenceRecording",
#       "description": "",
#       "properties": {
#         "duration_minutes": {
#           "example": 0,
#           "type": "integer"
#         },
#         "title": {
#           "example": "course2: Test conference 3 [170]_0",
#           "type": "string"
#         },
#         "updated_at": {
#           "example": "2013-12-12T16:09:33.903-07:00",
#           "type": "datetime"
#         },
#         "created_at": {
#           "example": "2013-12-12T16:09:09.960-07:00",
#           "type": "datetime"
#         },
#         "playback_url": {
#           "example": "http://example.com/recording_url",
#           "type": "string"
#         }
#       }
#     }
#
# @model Conference
#     {
#       "id": "Conference",
#       "description": "",
#       "properties": {
#         "id": {
#           "description": "The id of the conference",
#           "example": 170,
#           "type": "integer"
#         },
#         "conference_type": {
#           "description": "The type of conference",
#           "example": "AdobeConnect",
#           "type": "string"
#         },
#         "description": {
#           "description": "The description for the conference",
#           "example": "Conference Description",
#           "type": "string"
#         },
#         "duration": {
#           "description": "The expected duration the conference is supposed to last",
#           "example": 60,
#           "type": "integer"
#         },
#         "ended_at": {
#           "description": "The date that the conference ended at, null if it hasn't ended",
#           "example": "2013-12-13T17:23:26Z",
#           "type": "datetime"
#         },
#         "started_at": {
#           "description": "The date the conference started at, null if it hasn't started",
#           "example": "2013-12-12T23:02:17Z",
#           "type": "datetime"
#         },
#         "title": {
#           "description": "The title of the conference",
#           "example": "Test conference",
#           "type": "string"
#         },
#         "users": {
#           "description": "Array of user ids that are participants in the conference",
#           "example": "[1, 7, 8, 9, 10]",
#           "type": "array",
#           "items": { "type": "integer"}
#         },
#         "has_advanced_settings": {
#           "description": "True if the conference type has advanced settings.",
#           "example": false,
#           "type": "boolean"
#         },
#         "long_running": {
#           "description": "If true the conference is long running and has no expected end time",
#           "example": false,
#           "type": "boolean"
#         },
#         "user_settings": {
#           "description": "A collection of settings specific to the conference type",
#           "example": "{}",
#           "type": "map",
#           "key": { "type": "string" },
#           "value": { "type": "string" }
#         },
#         "recordings": {
#           "description": "A List of recordings for the conference",
#           "type": "array",
#           "items": { "$ref": "ConferenceRecording" }
#         },
#         "url": {
#           "description": "URL for the conference, may be null if the conference type doesn't set it",
#           "type": "string"
#         },
#         "join_url": {
#           "description": "URL to join the conference, may be null if the conference type doesn't set it",
#           "type": "string"
#         }
#       }
#     }
#
class ConferencesController < ApplicationController
  include Api::V1::Conferences

  before_filter :require_context, :except => [:get_conferences_for_user]
  add_crumb(proc{ t '#crumbs.conferences', "Conferences"}) { |c| c.send(:named_context_url, c.instance_variable_get("@context"), :context_conferences_url) }
  before_filter { |c| c.active_tab = "conferences" }
  before_filter :require_config
  before_filter :reject_student_view_student
  before_filter :get_conference, :except => [:get_conferences_for_user, :index, :create,:get_users_from_section,:api_create, :api_destroy]

  # @API List conferences
  # Retrieve the list of conferences for this context
  #
  # This API returns a JSON object containing the list of conferences,
  # the key for the list of conferences is "conferences"
  #
  #  Examples:
  #     curl 'https://<canvas>/api/v1/courses/<course_id>/conferences' \
  #         -H "Authorization: Bearer <token>"
  #
  #     curl 'https://<canvas>/api/v1/groups/<group_id>/conferences' \
  #         -H "Authorization: Bearer <token>"
  #
  # @returns [Conference]
  def index
    return unless authorized_action(@context, @current_user, :read)
    return unless tab_enabled?(@context.class::TAB_CONFERENCES)
    return unless @current_user
    conferences = (@domain_root_account ||= @account).grants_right?(@current_user, :manage_content) ?
        @context.web_conferences :
        @current_user.web_conferences.where(context_type: @context.class.to_s, context_id: @context.id)
    conferences = conferences.with_config.order("created_at DESC, id DESC")
    api_request? ? api_index(conferences) : web_index(conferences)
  end

  def api_index(conferences)
    route = polymorphic_url([:api_v1, @context, :conferences])
    web_conferences = Api.paginate(conferences, self, route)
    render json: api_conferences_json(web_conferences, @current_user, session)
  end
  protected :api_index

  def web_index(conferences)
    @new_conferences, @concluded_conferences = conferences.partition { |conference|
      conference.ended_at.nil?
    }

    @new_conferences = @new_conferences.sort_by(&:start_date)
    #@concluded_conferences = @concluded_conferences.sort_by(&:start_date)
    log_asset_access("conferences:#{@context.asset_string}", "conferences", "other")
    scope = @context.users
    if @context.respond_to?(:participating_typical_users)
      scope = @context.participating_typical_users
    end
    @users = scope.where("users.id<>?", @current_user).order(User.sortable_name_order_by_clause).all.uniq
    # exposing the initial data as json embedded on page.
    @course_sections = @context.is_a?(Course) ? @context.course_sections.active : []
    js_env(
        current_conferences: ui_conferences_json(@new_conferences, @context, @current_user, session),
        concluded_conferences: ui_conferences_json(@concluded_conferences, @context, @current_user, session),
        default_conference: default_conference_json(@context, @current_user, session),
        conference_type_details: conference_types_json(WebConference.conference_types),
        users: @users.map { |u| {:id => u.id, :name => u.last_name_first} },
        course_sections: @course_sections,
        current_date_time: Time.now
    )
  end
  protected :web_index

  def show
    if authorized_action(@conference, @current_user, :read)
      if params[:external_url]
        urls = @conference.external_url_for(params[:external_url], @current_user, params[:url_id])
        if request.xhr?
          return render :json => urls
        elsif urls.size == 1
          return redirect_to(urls.first[:url])
        end
      end
      log_asset_access(@conference, "conferences", "conferences")
    end
  end

  def create
    if authorized_action(@context.web_conferences.new, @current_user, :create)
      params[:web_conference].try(:delete, :long_running)
      @conference = @context.web_conferences.build(params[:web_conference])
      @conference.settings[:default_return_url] = named_context_url(@context, :context_url, :include_host => true)
      @conference.user = @current_user
      members = get_new_members
      respond_to do |format|
        if @conference.save
          @conference.add_initiator(@current_user)
          members.uniq.each do |u|
            if u.id != @current_user.id
              @conference.add_invitee(u)
            end
          end
          @conference.save

          members.uniq.each do |u|
            @event = CalendarEvent.new(:title => params[:title], :description => params[:description],
                                       :start_at => params[:start_date], :end_at => params[:start_date])
            @event.context_id = u.id
            @event.context_type = @current_user.class.name
            @event.updating_user = @current_user
            @event.save
            conference_calendar_event_association = @event.conference_calendar_event_associations.build(:web_conference_id => @conference.id)
            conference_calendar_event_association.save!
          end
          format.html { redirect_to named_context_url(@context, :context_conference_url, @conference.id) }
          format.json { render :json => WebConference.find(@conference).as_json(:permissions => {:user => @current_user, :session => session},
                                                                                :url => named_context_url(@context, :context_conference_url, @conference)) }
        else
          format.html { render :action => 'index' }
          format.json { render :json => @conference.errors, :status => :bad_request }
        end
      end
    end
  end

  def api_create
    if authorized_action(@context.web_conferences.new, @current_user, :create)
      respond_to do |format|
        @conference = WebConference.find_by_title_and_start_date(params[:title],params[:start_date].to_time)
        #new_logger = Logger.new('log/exceptions.log')
        #new_logger.info(params[:title]+"-"+params[:start_date]+"\n")
        if @conference
          #new_logger.info("existing conference\n")
          @conference.add_invitee(User.find(params[:student_id]))
          create_calendar_events(params[:student_id])
        else
          #new_logger.info("new conference\n")
          params[:web_conference].try(:delete, :long_running)
          @conference = @context.web_conferences.build(conference_type: params[:type],title: params[:title],
                                                       description: params[:description],start_date: params[:start_date],
                                                       duration: params[:duration])
          @conference.settings[:default_return_url] = named_context_url(@context, :context_url, :include_host => true)
          @conference.settings[:record ]= true
          @conference.user = User.find(params[:teacher_id])
          members = get_new_members_for_api

          @conference.add_initiator(User.find(params[:teacher_id]))
          @conference.add_invitee(User.find(params[:student_id]))
          if @conference.save
            create_calendar_events(params[:teacher_id])
            create_calendar_events(params[:student_id])
            format.json { render :json => WebConference.find(@conference).as_json(:permissions => {:user => @current_user, :session => session},
                                                                                  :url => named_context_url(@context, :context_conference_url, @conference)) }
          else
            format.json { render :json => @conference.errors, :status => :bad_request }
          end

        end
      end
    end
  end

  def create_calendar_events(user_id)
    @event = CalendarEvent.new(:title=>params[:title], :description=>params[:description], :start_at=> params[:start_date], :end_at=> params[:start_date])
    @event.context_id = user_id
    @event.context_type = "User"
    @event.updating_user = @current_user
    @event.save
    conference_calendar_event_association = @event.conference_calendar_event_associations.build(:web_conference_id => @conference.id,:calendar_event_id => @event.id)
    conference_calendar_event_association.save!
  end

  def update
    if authorized_action(@conference, @current_user, :update)
      @conference.user ||= @current_user
      members = get_new_members
      respond_to do |format|
        params[:web_conference].try(:delete, :long_running)
        params[:web_conference].try(:delete, :conference_type)
        if @conference.update_attributes(params[:web_conference])
          # TODO: ability to dis-invite people
          participant=WebConferenceParticipant.find_all_by_web_conference_id(@conference.id)
          participant.each do |p|
            p.destroy
          end
          @conference.add_initiator(@current_user)
          @conference_users.uniq.each do |u|
            if u.id != @current_user.id
              @conference.add_invitee(u)
            end
          end
          @conference.save

          @conference.conference_calendar_event_associations.each do |con|
            CalendarEvent.destroy(con.calendar_event_id)
            ConferenceCalendarEventAssociation.destroy(con.id)
          end

          @conference_users.uniq.each do |u|
            @event = CalendarEvent.new(:title => params[:title], :description => params[:description],
                                       :start_at => params[:start_date], :end_at => params[:start_date])
            @event.context_id = u.id
            @event.context_type = @current_user.class.name
            @event.updating_user = @current_user
            @event.save
            conference_calendar_event_association = @event.conference_calendar_event_associations.build(:web_conference_id => @conference.id,:calendar_event_id => @event.id)
            conference_calendar_event_association.save!
          end

          format.html { redirect_to named_context_url(@context, :context_conference_url, @conference.id) }
          format.json { render :json => @conference.as_json(:permissions => {:user => @current_user, :session => session},
                                                            :url => named_context_url(@context, :context_conference_url, @conference)) }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @conference.errors, :status => :bad_request }
        end
      end
    end
  end

  def join
    if authorized_action(@conference, @current_user, :join)
      unless @conference.valid_config?
        flash[:error] = t(:type_disabled_error, "This type of conference is no longer enabled for this Arrivu LMS site")
        redirect_to named_context_url(@context, :context_conferences_url)
        return
      end
      if @conference.grants_right?(@current_user, session, :initiate) || @conference.grants_right?(@current_user, session, :resume) || @conference.active?(true)
        @conference.add_attendee(@current_user)
        @conference.restart if @conference.ended_at && @conference.grants_right?(@current_user, session, :initiate)
        log_asset_access(@conference, "conferences", "conferences", 'participate')
        generate_new_page_view
        if url = @conference.craft_url(@current_user, session, named_context_url(@context, :context_url, :include_host => true))
          redirect_to url
        else
          flash[:error] = t(:general_error, "There was an error joining the conference")
          redirect_to named_context_url(@context, :context_url)
        end
      else
        flash[:notice] = t(:inactive_error, "That conference is not currently active")
        redirect_to named_context_url(@context, :context_url)
      end
    end
  rescue StandardError => e
    flash[:error] = t(:general_error_with_message, "There was an error joining the conference. Message: '%{message}'", :message => e.message)
    redirect_to named_context_url(@context, :context_conferences_url)
  end

  def close
    if authorized_action(@conference, @current_user, :close)
      if @conference.close
        render :json => @conference.as_json(:permissions => {:user => @current_user, :session => session},
                                            :url => named_context_url(@context, :context_conference_url, @conference))
      else
        render :json => @conference.errors
      end
    end
  end

  def settings
    if authorized_action(@conference, @current_user, :update)
      if @conference.has_advanced_settings?
        redirect_to @conference.admin_settings_url(@current_user)
      else
        flash[:error] = t(:no_settings_error, "The conference does not have an advanced settings page")
        redirect_to named_context_url(@context, :context_conference_url, @conference.id)
      end
    end
  end

  def destroy
    if authorized_action(@conference, @current_user, :delete)
      @conference.transaction do
      @conference.web_conference_participants.scoped.delete_all
      @events = @conference.conference_calendar_event_associations
      @events.each do |e|
        x=CalendarEvent.find(e.calendar_event_id)
        x.destroy
      end
      @conference.destroy

    end
      respond_to do |format|
        format.html { redirect_to named_context_url(@context, :context_conferences_url) }
        format.json { render :json => @conference }
      end
    end
 end

  def api_destroy
    @conference = WebConference.find(params[:id])
    if authorized_action(@conference, @current_user, :delete)
      @events = @conference.conference_calendar_event_associations
      @events.each do |e|
        x=CalendarEvent.find(e.calendar_event_id)
        x.destroy
      end
      @conference.destroy
      respond_to do |format|
        format.json { render :json => @conference }
      end
    end
  end

  def get_users_from_section
    if params[:course_section_id] != "0"
      @students = CourseSection.find(params[:course_section_id]).students.active
    else
      @students = @context.students.active
    end
    respond_to do |format|
      format.json { render :json => @students.map{|s| {:id => s.id, :name => s.last_name_first}} }
    end
  end

  def get_new_members_for_api
    members = [@current_user]
    if params[:user] && params[:user] != "all"
      ids = []
      params[:user].each do |id|
        ids << id.to_i
      end
      if params[:section_id].present?
        section = @context.course_sections.find_by_sis_source_id(params[:section_id])
        if !section.nil? and !section.empty?
          members += section.users.find_all_by_find_all_by_sis_sourse_id(ids).to_a
        end
      else
        members += @context.course_sections.default.first.users.find_all_by_sis_sourse_id(ids).to_a
      end
    else
      if params[:section_id].present?
        section = @context.course_sections.find_by_sis_source_id(params[:section_id])
        if !section.nil? and !section.empty?
          members += section.users.to_a
        end
      else
        members += @context.course_sections.default.first.users.to_a
      end
    end
    members - @conference.invitees
  end

  def get_conferences_for_user
    conferences = []
    @current_conferences_json = []
    @concluded_conferences_json = []
    scope = []

    @web_conference_participants = @current_user.web_conference_participants.uniq
    @web_conference_participants.each do |web_conference_participant|
      web_conference = web_conference_participant.web_conference
      if web_conference
        conferences <<  web_conference
      end
    end
    @current_user.web_conferences.uniq.each do |web|
      conferences << web
    end

    @new_conferences, @concluded_conferences = conferences.partition { |conference|
      conference.ended_at.nil?
    }
    @new_conferences = @new_conferences.sort_by(&:start_date)

    @new_conferences.uniq.each do |new_conference|
      @current_conferences_json <<  single_conferences_json(new_conference, new_conference.context, @current_user, session)
    end

    @concluded_conferences.uniq.each do |concluded_conference|
      @concluded_conferences_json << single_conferences_json(concluded_conference, concluded_conference.context,
                                                             @current_user, session)
    end


    conferences.each do |conference|
      conference.context.participating_typical_users.each do |user|
        scope << user
      end
    end

    #@users = scope.uniq
    #@users.delete_if{|u| u == @current_user}

    js_env(
        current_conferences: @current_conferences_json ,
        concluded_conferences: @concluded_conferences_json ,
        #default_conference: default_conference_json(@context, @current_user, session),
        conference_type_details: conference_types_json(WebConference.conference_types),
        is_for_user: true,
        current_date_time: Time.now
    #users: @users.map { |u| {:id => u.id, :name => u.last_name_first} }
    #course_sections: @context.course_sections.active
    )
  end
  protected

  def require_config
    unless WebConference.config
      flash[:error] = t('#conferences.disabled_error', "Web conferencing has not been enabled for this Arrivu LMS site")
      redirect_to named_context_url(@context, :context_url)
    end
  end

  def get_new_members
    members = [@current_user]
    if params[:user] && params[:user][:all] != '1'
      ids = []
      params[:user].each do |id, val|
        ids << id.to_i if val == '1'
      end
      @conference_users = @context.users.find_all_by_id(ids).to_a
    else
      members += @context.users.to_a
    end
    members - @conference.invitees
  end

  def get_conference
    @conference = @context.web_conferences.find(params[:conference_id] || params[:id])
  end
  private :get_conference
end

