class SecureClient

  @@cache = {}
  @@yaml_cache = {}

  def self.require_authorization_redirect?(context=nil)

  end

  def self.popup_window(quiz, security_level=nil)

  end

  def self.redirect_params(quiz, opts=nil)

  end

  def self.authorized?(context,request=nil)
    q = context.instance_variable_get('@quiz')
    begin
      if q and q.require_lockdown_browser
        config = SecureClient.from_secure_client_config("secure_client")
        uri = URI(config['secure_client_api_url'])
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(account: q.context.account.root_account.id,
                          context: q.context.id,
                          quizz: q.id,
                          requesthash: request.headers['HTTP_X_SAFEEXAMBROWSER_REQUESTHASH'],
                          access_token: config['access_token'])
        sock = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          sock.use_ssl = true
          sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        res  = sock.start {|http| http.request(req) }
        res  = JSON.parse(res.body)
          unless res.empty?
           if res['Status'] == "true"
            return true
           elsif request.headers['HTTP_X_SAFEEXAMBROWSER_REQUESTHASH']
             context.instance_variable_set '@invalid_config', true
             return false
           else
             return false
           end
          end
      end
    rescue => e
      Rails.logger.error("Error while connecting secure client server:#{e}")
      return false
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
