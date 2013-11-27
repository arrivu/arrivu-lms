class AlertsController < ApplicationController

  def load_projects
   projects = Wistia::Project.find(:all)
  end

  def load_project_medias
    project = Wistia::Project.find(param[:project_id])
  end


  private

  def set_wisitia_api
    Wistia.use_config!(:wistia => {
        :api => {
            :password => 'your-api-password',
            :format => 'xml-or-json'
        }
    })
  end

end