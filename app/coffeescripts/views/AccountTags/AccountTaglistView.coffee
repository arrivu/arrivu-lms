define [
  'jquery'
  'jst/AccountTags/AccountTagList'
], ($, template) ->

  class AccountTaglistView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'account_tags_item'

    afterRender: ->
      @$el.attr('id', 'account_tags_' + @model.get('id'))
      this

