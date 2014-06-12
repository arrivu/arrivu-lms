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
      'click .details': 'movetocourselibrary'
      'click .slides_popup': 'teacher_details'

    filterByTopics:(event) ->
      clicked_topic_id = $(event.target).data('id')
      $('.topic').removeClass('selected_topic')
      $(event.target).closest('.topic').addClass('selected_topic')
      @accountCourseCollectionView.collection.setParam('per_page', 10)
      @accountCourseCollectionView.collection.fetch({ data:{topic_id: clicked_topic_id}})

    movetocourselibrary:(event)->
      course_item = this.$(event.currentTarget).attr('id')
      location.href = "#{location.protocol}//#{location.host}/libraries/"+course_item

    teacher_details:(event)->
      event.stopPropagation()
      teacher_id = this.$(event.currentTarget).find(".pop_up_items").attr('id')
      location.href = "#{location.protocol}//#{location.host}/users/"+teacher_id+"/details"



