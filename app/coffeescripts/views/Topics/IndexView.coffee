define [
  'jquery'
  'underscore'
  'i18n!topics'
  'str/htmlEscape'
  'jst/topics/IndexView'
  'compiled/views/Topics/AddTopicView'
  'compiled/views/Topics/EditView'
  'compiled/views/Topics/AddSubTopicView'
  'compiled/views/Topics/TopicListView'
  'compiled/models/CourseTopic'
], ($, _, I18n, htmlEscape, template, AddTopicView, EditView, AddSubTopicView, TopicListView, CourseTopic) ->

  class IndexView extends Backbone.View

    template: template

    events:
      'click .add_tool_link': 'addTopic'
      'click [data-add-sub-topic]': 'subTopic'
      'click [data-edit-topic]': 'editTopic'
      'click [data-delete-topic]': 'deleteTopic'


    afterRender: ->
      @showTopicsView()

    showTopicsView: =>
      @collection.fetch()
      @collection.on 'sync', @renderTopicListView, @collection

    renderTopicListView: (collection) ->
      $("#topic_add").empty()
      _.each collection.models, (model) ->
        topicListView = new TopicListView
          name: model.attributes.name
          id: model.attributes.id
        $("#topic_add").append topicListView.render().el
        _.each model.attributes.children, (model) ->
          topicListView = new TopicListView
            name: model.name
            id: model.id
            is_child: true
          $("#topic_add").append topicListView.render().el
          _.each model.children, (model) ->
            topicListView = new TopicListView
              name: model.name
              id: model.id
              is_sub_child: true
            $("#topic_add").append topicListView.render().el

    addTopic: ->
      newTopic = new CourseTopic
      newTopic.on 'sync', @onTopicSync
      @addTopicView = new AddTopicView(model: newTopic).render()


    subTopic: (event)->
      parent_id = $(event.target).closest("a").attr('data-add-sub-topic')
      newsubTopic = new CourseTopic
      newsubTopic.on 'sync', @onTopicSync
      @addSubTopicView = new AddSubTopicView(model: newsubTopic,parent_id: parent_id).render()

    render_topic_view: (res) ->
      console.log(res)
      topicListView = new TopicListView
        name: model.name
        id: model.id
        is_sub_child: true
      $("#topic_add").append topicListView.render().el

    editTopic: (event) ->
      view = @$(event.currentTarget).closest('.topic_item').data('view')
      topic = view.model
      console.log(view);
      topic.on 'sync', @onTopicSync
      @editView = new EditView(model: topic).render()

    onTopicSync: (model) =>
      @addTopicView.remove() if @addTopicView
      @addSubTopicView.remove() if @addSubTopicView
      @editView.remove() if @editView
      @showTopicsView()
      $.flashMessage(htmlEscape(I18n.t('topic_saved_message', "%{topic} saved successfully!", { topic: model.get('name') })))

    deleteTopic: (event) ->
      view = @$(event.currentTarget).closest('.topic_item').data('view')
      coursetopic = view.model
      msg =  "Are you sure you want to remove this Topic?"
      dialog = $("<div>#{msg}</div>").dialog
        modal: true,
        resizable: false
        title: I18n.t('delete', 'Delete') + ' ' + coursetopic.get('name') + '?'
        buttons: [
          text: 'Cancel'
          click: => dialog.dialog 'close'
        ,
          text: 'Delete'
          click: =>
            coursetopic.on('sync', => @topicsCollectionView.collection.fetch())
            coursetopic.destroy()
            dialog.dialog 'close'
        ]
