define [
  'jquery'
  'jst/HomePages/PopularCourseCollectionView'
  'compiled/views/HomePages/PopularCourseView'
  'compiled/views/PaginatedCollectionView'
  'jqueryui/jquery.jcontent.0.8',
  'jqueryui/jquery.easing.1.3'
], ($, template, PopularCourseView,PaginatedCollectionView) ->

  class PopularCourseCollectionView extends PaginatedCollectionView

    template: template
    itemView: PopularCourseView