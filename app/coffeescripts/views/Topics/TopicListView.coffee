define [
  'jquery'
  'jst/topics/TopicList'
], ($, template) ->

  class TopicListView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'topic_item'

    afterRender: ->
      @$el.attr('id', 'topic_' + @model.get('id'))
      this
