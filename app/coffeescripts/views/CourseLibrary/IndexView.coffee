define [
  'jquery'
  'i18n!home_pages'
  'jst/CourseLibrary/IndexView'
], ($, I18n, template) ->

  class IndexView extends Backbone.View

    @child 'accountCourseCollectionView',  '[data-view=courses]'
    @child 'topicsView',  '[data-view=topics]'
    template: template

    events:
      'click .topic' : 'filterByTopics'

    filterByTopics:(event) ->
      clicked_topic_id = $(event.target).data('id')
      $('.topic').removeClass('selected_topic')
      $(event.target).closest('.topic').addClass('selected_topic')
      @accountCourseCollectionView.collection.fetch({ data:{topic_id: clicked_topic_id}})




