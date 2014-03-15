class LeaderboardsController < ApplicationController
  before_filter :require_user
  before_filter :require_context


  def index
    if authorized_action(@context, @current_user, :read)
      add_crumb("Leader Board")
      @students = @context.students.active.order_by_sortable_name
      if params[:search_term]
        if params[:course_section_id].empty? or (params[:course_section_id].to_i == 0)
          @students = @context.students.active.order_by_sortable_name
        else
          @students = @context.course_sections.active.find(params[:course_section_id]).students.active
        end
      end
      js_env(
          course_sections: @context.course_sections.active.map(&:attributes),
          course: @context.attributes
      )
      respond_to do |format|
        @students = Api.paginate(@students, self, course_leaderboards_url)
        format.html
        format.json {
          render :json => users_json(@students, @current_user, session, %w{avatar_url},
                                    @current_user.pseudonym.account) }
      end
    end
  end


end
