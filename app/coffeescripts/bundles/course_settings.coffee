require [
  'jquery'
  'underscore'
  'Backbone'
  'compiled/views/course_settings/NavigationView'
  'compiled/collections/UserCollection'
  'compiled/views/feature_flags/FeatureFlagAdminView'
  'vendor/jquery.cookie'
  'course_settings'
  'grading_standards'
  'jquery.tokeninput'
], ($, _, Backbone, NavigationView, UserCollection, FeatureFlagAdminView) ->
  nav_view = new NavigationView
    el: $('#tab-navigation')

  featureFlagView = new FeatureFlagAdminView(el: '#tab-features')
  featureFlagView.collection.fetch()

  $ ->
    nav_view.render()


  $(document).ready ->
    $ ->
      $('#course_tag_tokens').tokenInput ENV.COURSE_TAGGING_PATH
      prePopulate: $('#course_tag_tokens').data('load')
