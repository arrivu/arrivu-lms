define [
  'jquery'
  'jst/CourseComments/CourseCommentsCollectionView'
  'compiled/views/CourseComments/CourseCommentView'
  'compiled/views/PaginatedCollectionView'
], ($, template,CourseCommentView, PaginatedCollectionView) ->

  class CourseCommentsCollectionView extends PaginatedCollectionView

    template: template
    itemView: CourseCommentView

    afterRender: ->
      @$el.dialog
        modal: true,
        resizable: false
        width:  800
        height: 600
      $(".ui-widget-header").removeClass "ui-widget-header"