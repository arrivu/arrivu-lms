require 'arrivu_secure_client/quizzes_controller_extensions'

Dir.glob(File.join(File.dirname(__FILE__), "db", "migrate", "*")).each do |file|
  require file
end

module ArrivuSecureClient
  def self.initialize
    true
  end
end