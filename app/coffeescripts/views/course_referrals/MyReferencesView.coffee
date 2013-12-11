define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_referrals/InviteFriendsView'
], ($, _, Backbone, template) ->
  class MyReferencesView extends Backbone.View
    template: template
    className: 'my-references'


#    initialize: ->
#