module ArrivuSecureClient
  module QuizzesApiControllerExtensions
    def self.included base
      base.class_eval do

        def update_secure_client_config
          require_quiz
          if authorized_action(@quiz, @current_user, :update)
            if params.has_key?('require_lockdown_browser')
              @quiz.require_lockdown_browser = params[:require_lockdown_browser]
            end
            if params.has_key?('require_lockdown_browser_for_results')
              @quiz.require_lockdown_browser_for_results = params[:require_lockdown_browser_for_results]
            end
            @quiz.save!
            if @quiz.valid?
              render_json
            else
              errors = @quiz.errors.as_json[:errors]
              errors['published'] = errors.delete(:workflow_state) if errors.has_key?(:workflow_state)
              render :json => {:errors => errors}, :status => 400
            end
          end
        end

      end
    end
  end
end
