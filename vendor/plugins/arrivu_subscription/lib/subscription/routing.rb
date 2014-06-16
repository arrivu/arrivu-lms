module Arrivu #:nodoc:
  module Subscription #:nodoc:
    module Routing #:nodoc:
      module MapperExtensions

        def subscription_urls

        end
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, Arrivu::Subscription::Routing::MapperExtensions