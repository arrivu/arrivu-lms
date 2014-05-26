define [
  'jquery'
  'jst/CourseComments/CourseCommentView'
  'compiled/collections/CourseCommentsCollection'
  'compiled/views/CourseComments/CourseCommentsCollectionView'
], ($,template,CourseCommentsCollection,CourseCommentsCollectionView) ->

  class CourseCommentView extends Backbone.View

    template: template
    tagName: 'li'
    className: 'course_comment_item'

    afterRender: ->
      @$el.attr('id', 'course_comment_' + @model.get('id'))
      @$el.css('margin-bottom', '37px')
      this