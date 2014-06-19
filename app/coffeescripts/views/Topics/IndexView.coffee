define [
  'jquery'
  'i18n!topics'
  'str/htmlEscape'
  'jst/topics/IndexView'
  'compiled/views/Topics/AddTopicView'
  'compiled/views/Topics/AddSubTopicView'
  'compiled/models/CourseTopic',
], ($, I18n, htmlEscape, template, AddTopicView, AddSubTopicView, CourseTopic) ->

  class IndexView extends Backbone.View

    @child 'topicsCollectionView', '[data-view=topics]'

    template: template

    events:
      'click .add_tool_link': 'addTopic'
      'click [data-add-sub-topic]': 'subTopic'
      'click [data-edit-topic]': 'editTopic'
      'click [data-delete-topic]': 'deleteTopic'


    afterRender: ->
      @showTopicsView()

    showTopicsView: =>
      @topicsCollectionView.collection.fetch()
      @topicsCollectionView.show()

    addTopic: ->
      newTopic = new CourseTopic
      newTopic.on 'sync', @onTopicSync
      @addTopicView = new AddTopicView(model: newTopic).render()

    subTopic: ->
      newsubTopic = new CourseTopic
      newsubTopic.on 'sync', @onTopicSync
      @addSubTopicView = new AddSubTopicView(model: newsubTopic).render()


    editTopic: (event) ->
      view = @$(event.currentTarget).closest('.topic_item').data('view')
      topic = view.model
      topic.on 'sync', @onTopicSync
      @addTopicView = new AddTopicView(model: topic).render()

    onTopicSync: (model) =>
      @addTopicView.remove() if @addTopicView
      @addSubTopicView.remove() if @addSubTopicView
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
