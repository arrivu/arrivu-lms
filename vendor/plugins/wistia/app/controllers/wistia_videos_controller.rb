
class WistiaVideoController < ApplicationController

  def load_projects
   projects = Wistia::Project.find(:all)
  end

  def load_project_medias
    project = Wistia::Project.find(params[:project_id])
  end

 private

  def set_wisitia_api
    Wistia.use_config!(:wistia => {
        :api => {
            :password => '7a193a4197de7f28f86875e166ad0ac5e550eff1',
            :format => 'json'
        }
    })
  end

end