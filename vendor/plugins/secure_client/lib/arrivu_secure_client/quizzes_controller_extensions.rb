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

      end
    end
  end
end
