define [
  'jquery'
  'jst/CourseLibrary/TopicView'
], ($, template) ->

  class TopicsView extends Backbone.View

    template: template


    initialize: ->
      super
      @topics_collection = @collection.models
      console.log(@topics_collection)


    toJSON: ->
      json = super

      json['topics_collection'] = @topics_collection

      json


