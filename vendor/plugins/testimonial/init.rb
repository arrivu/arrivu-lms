# Include hook code here
require_dependency 'testimonial'
# Should run with each request
config.to_prepare do
  Arrivu::Testimonial::initialize
end
