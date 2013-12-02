require 'wistia'

class WistiaVideoAPI
  require 'net/http'
  require 'net/https'
  require 'uri'

  def self.config_check(settings)
    username = settings['username']
    secret_password = settings['secret_password']
    public_token = settings['public_token']
    cache_timeout = settings['cache_timeout']
    self.authenticate(secret_password)
  end

  def self.config
    #Canvas::Plugin.find(:wistia).try(:settings)
    config_check( Canvas::Plugin.find(:wistia).try(:settings))
  end

  def self.enabled?
    !!config
  end

  def self.list_collections
   begin
      projects = Wistia::Project.find(:all)
      collections = []
      projects.each do  |project|
       collections << collection_from_project(project)
      end

      rescue => e
      return "Error while connecting Wistia"
   end
  end

  def self.get_collection(id)
    project = Wistia::Project.get(id)
    collections = []
    projects.each do  |project|
      collections << collection_from_project(project)
    end
  end

  #def self.load_colection_medias(id)
  #  project_details = Wistia::Media.find(:all, :params => { :project_id => id })
  #end

  #protected
  def self.authenticate(secret_password)
    begin
      Wistia.use_config!(:wistia => {
          :api => {
              :password => secret_password,
              :format => 'json'
          }
      })
      #test to list all the projects
      #load_collections
    rescue => e
      return "Wistia Video API Configuration check failed, please check your settings"
    end
    #self.authenticate=true
  end

  def self.collection_from_project(project)
    id = project.id , hash_id = project.hashedId
        name = project.name, description = project.description, mediaCount = project.mediaCount
    medias = nil
    if(project.medias)
      projects.medias.each do  |media|
        medias << media_from_wistia_media(media)
      end
    end
    collection = VideoCollection::Collection.new(id, hash_id, name, description, mediaCount, medias)
  end

  def self.media_from_wistia_media(media)
    id = media.id, hash_id = media.hash_id, name = media.name, description = media.description,
        embed_code = media.embed_code,thumbnail_url = media.thumbnail_url, thumbnail_height = media.thumbnail_height,
        thumbnail_width = media.thumbnail_width
    media = VideoCollection::Media(id, hash_id, name, description, embed_code,
                                   thumbnail_url, thumbnail_height, thumbnail_width)
  end
end
