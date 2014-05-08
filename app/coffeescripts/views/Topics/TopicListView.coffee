define [
  'jquery'
  'jst/topics/TopicList'
], ($, template) ->

  class TopicListView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'topic_item'

    initialize: (options) ->
      super
      @name = options.name
      @color = options.color
      @id = options.id
      @is_child = options.is_child
      @is_sub_child = options.is_sub_child

    toJSON: ->
      json = super

      json['name'] = @name
      json['color'] = @color
      json['id '] = @id
      json['is_child'] = @is_child
      json['is_sub_child'] = @is_sub_child
      json

    afterRender: ->
      @$el.attr('id', 'topic_' + @id)
      this