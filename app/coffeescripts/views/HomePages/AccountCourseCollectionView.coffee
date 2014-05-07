define [
  'jquery'
  'jst/HomePages/AccountCourseCollectionView'
  'compiled/views/HomePages/AccountCourseView'
  'compiled/views/PaginatedCollectionView'
], ($, template,AccountCourseView, PaginatedCollectionView) ->

  class AccountCourseCollectionView extends PaginatedCollectionView

    template: template
    itemView: AccountCourseView

