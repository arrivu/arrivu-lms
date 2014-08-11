module Elearning
  module ProfileControllerExtensions
    def self.included base
      base.class_eval do

        base.before_filter :set_badge_url, :only => [:show]

        def set_badge_url
          context_external_tool = @domain_root_account.context_external_tools.find_by_tool_id_and_workflow_state('canvabadges',['anonymous','name_only','email_only','public']).try(:id)
          unless context_external_tool.nil?
            @badge_ex_tool = ContextExternalTool.find_for(context_external_tool, @domain_root_account, :user_navigation)
            base_url = URI(@badge_ex_tool.url)
            host_with_port = "#{base_url.scheme}://#{base_url.host}:#{base_url.port}"
            js_env  :BADGEHOSTWITHPORT => host_with_port
          end
         end
      end
    end
  end
end
