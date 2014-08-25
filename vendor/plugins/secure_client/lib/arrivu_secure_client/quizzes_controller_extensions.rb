module ArrivuSecureClient
  module QuizzesControllerExtensions
    def self.included base
      base.class_eval do

        def lockdown_browser_required
          plugin = Canvas::LockdownBrowser.plugin
          if plugin
            @lockdown_browser_download_url = plugin.settings[:download_url]
          end
          respond_to do |format|
            format.html { render :template => 'quizzes/quizzes/secure_client_browser_required'}
          end
        end

        def check_lockdown_browser(security_level, redirect_return_url)
          return true if @quiz.grants_right?(@current_user, session, :grade)
          plugin = Canvas::LockdownBrowser.plugin.base
          if plugin.require_authorization_redirect?(self)
            redirect_to(plugin.redirect_url(self, redirect_return_url))
            return false
          elsif !plugin.authorized?(self,request)
            redirect_to(:action => 'lockdown_browser_required', :quiz_id => @quiz.id,:valid_config => @invalid_config)
            return false
          elsif !session['lockdown_browser_popup'] && @query_params = plugin.popup_window(self, security_level)
            @security_level = security_level
            session['lockdown_browser_popup'] = true
            render(:action => 'take_quiz_in_popup')
            return false
          end
          @lockdown_browser_authorized_to_view = true
          @headers = false
          @show_left_side = false
          @padless = true
          return true
        end

      end
    end
  end
end
