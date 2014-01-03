define [
  'jquery'
  'jst/rewards/ManageReferralsList'
], ($, template) ->

  class ManageReferralListView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'referrees_item'

    afterRender: ->
      @$el.attr('id', 'referrees_' + @model.get('id'))
      this

