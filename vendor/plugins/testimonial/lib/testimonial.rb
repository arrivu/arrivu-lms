

Dir.glob(File.join(File.dirname(__FILE__), "db", "migrate", "*")).each do |file|
  require file
end

module Arrivu
  module Testimonial
    def self.initialize
      true
    end
  end
end
