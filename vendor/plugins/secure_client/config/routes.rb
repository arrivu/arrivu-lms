if CANVAS_RAILS2
  # Even on Rails 2.3, we're using Rails 3 style routes.
  #
  # You should have plenty of examples in here for anything you're trying to do,
  # but if you want a full primer this is a good one:
  # http://blog.engineyard.com/2010/the-lowdown-on-routes-in-rails-3
  #
  # Don't try anything too fancy, FakeRails3Routes doesn't support some of the
  # more advanced Rails 3 routing features, since in the background it's just
  # calling into the Rails 2 routing system.
  routes = FakeRails3Routes
else
  routes = CanvasRails::Application.routes
end

routes.draw do
  ApiRouteSet::V1.draw(self) do
    scope(:controller => 'quizzes/quizzes_api') do
      post "courses/:course_id/quizzes/:id/secure_client_config", :action => :update_secure_client_config,
           :path_name => 'course_quiz_secure_client_config'
    end
  end
end