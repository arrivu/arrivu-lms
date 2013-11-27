require 'wistia'

class Wistiavideo
  require 'net/http'
  require 'net/https'
  require 'uri'

  def self.config_check(settings)
    # auth = Digest::MD5.hexdigest("#{settings['secret_key']}:roomlist")
    # res = Net::HTTP.get(URI.parse("http://tinychat.apigee.com/roomlist?result=json&key=#{settings['api_key']}&auth=#{auth}"))
    # json = JSON.parse(res) rescue nil
    # if json && json['error'] && json['error'] == "invalid request"
    #   "Configuration check failed, please check your settings"
    # else
    #   nil
    # end
  end

  def initialize
    self.authenticate if ScribdAPI.config
  end

  def self.config
    Canvas::Plugin.find(:wistia).try(:settings)
    Wistia.use_config!(:wistia => {
        :api => {
            :password => 'your-api-password',
            :format => 'json'
        }
    })
  end

  def api
    Scribd::API.instance
  end

  protected
  def authenticate
    self.api.key = ScribdAPI.config['api_key']
    self.api.secret = ScribdAPI.config['secret_key']
  end

end
