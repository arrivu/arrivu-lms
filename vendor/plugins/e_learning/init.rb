# Include hook code here
require_dependency 'e_learning'
# Should run with each request
config.to_prepare do
  Arrivu::ELearning::initialize
end
