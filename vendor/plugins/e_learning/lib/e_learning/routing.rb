module Arrivu #:nodoc:
  module ELearning #:nodoc:
    module Routing #:nodoc:
      module MapperExtensions

        def e_learning_urls

        end
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, Arrivu::ELearning::Routing::MapperExtensions