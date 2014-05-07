define [
  'jquery'
  'jst/HomePages/AccountSliderCollectionView'
  'compiled/views/HomePages/AccountSliderView'
  'compiled/views/PaginatedCollectionView'
  'jqueryui/jquery.jcontent.0.8',
  'jqueryui/jquery.easing.1.3'
], ($, template, AccountSliderView, PaginatedCollectionView) ->

  class AccountSliderCollectionView extends PaginatedCollectionView

    template: template
    itemView: AccountSliderView