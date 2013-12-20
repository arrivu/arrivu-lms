define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_referrals/InviteFriendsView'
], ($, _, Backbone, template) ->
  class MyRewardsView extends Backbone.View
    template: template
    className: 'my-rewards'


#    initialize: ->
#