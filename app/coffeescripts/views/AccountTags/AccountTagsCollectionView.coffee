define [
  'jquery'
  'str/htmlEscape'
  'jst/AccountTags/AccountTagsCollectionView'
  'compiled/views/AccountTags/AccountTaglistView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, template, AccountTagListView, PaginatedCollectionView) ->

  class AccountTagsCollectionView extends PaginatedCollectionView

    template: template
    itemView: AccountTagListView
