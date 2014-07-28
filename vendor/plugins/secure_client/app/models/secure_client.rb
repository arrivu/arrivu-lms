class SecureClient < ActiveRecord::Base

  def self.require_authorization_redirect?(context=nil)

  end

  def self.authorized?(context)
    q = context.instance_variable_get('@quiz')
    if q.require_lockdown_browser
      uri = URI("http://192.168.1.87:1495/api/Validate")
    begin
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(account: 1,context: 1,quizz: 6,requesthash: "d2da1b2a094a09ee9a4f67f605e9bd80f6cfc5c76df0d861c3351bb40df97b71")
      sock = Net::HTTP.new(uri.host, uri.port)
      res  = sock.start {|http| http.request(req) }
      res  = JSON.parse(res.body)
        unless res.empty?
          !res['Status']
        end
    rescue => e
      logger.error("Error while connecting secure client server:#{e}")
    end
    end
  else
    return true
  end

end
