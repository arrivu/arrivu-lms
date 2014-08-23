class SecureClient

  @@cache = {}
  @@yaml_cache = {}

  def self.require_authorization_redirect?(context=nil)

  end

  def self.popup_window(quiz, security_level=nil)

  end

  def self.redirect_params(quiz, opts=nil)

  end

  def self.authorized?(context)
    q = context.instance_variable_get('@quiz')
    if q.require_lockdown_browser
      config = SecureClient.from_secure_client_config("secure_client")
      uri = URI(config['secure_client_api_url'])
    begin
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(account: 1,context: 57,quizz: 102,requesthash: "a7a9464b7a344a33aeb7439305cac11dae2fd6e3c05b8b639549418ecf58f60a")
      sock = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        sock.use_ssl = true
        sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      res  = sock.start {|http| http.request(req) }
      res  = JSON.parse(res.body)
        unless res.empty?
         return res['Status']
        end
    rescue => e
      logger.error("Error while connecting secure client server:#{e}")
    end
    end
  end

  def self.from_secure_client_config(config_name, with_rails_env=:current)
    with_rails_env = Rails.env if with_rails_env == :current

    if @@yaml_cache[config_name] # if the config wasn't found it'll try again
      return @@yaml_cache[config_name] if !with_rails_env
      return @@yaml_cache[config_name][with_rails_env]
    end

    config = nil
    path = File.join("#{Rails.root}/vendor/plugins/secure_client", 'config', "#{config_name}.yml")
    if File.exists?(path)
      if Rails.env.test?
        config_string = ERB.new(File.read(path))
        config = YAML.load(config_string.result)
      else
        config = YAML.load_file(path)
      end

      if config.respond_to?(:with_indifferent_access)
        config = config.with_indifferent_access
      else
        config = nil
      end
    end
    @@yaml_cache[config_name] = config
    config = config[with_rails_env] if config && with_rails_env
    config
  end

end
