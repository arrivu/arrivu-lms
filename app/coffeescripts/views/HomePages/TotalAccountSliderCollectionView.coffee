define [
  'jquery'
  'jst/HomePages/TotalAccountSliderCollectionView'
  'compiled/views/HomePages/TotalAccountSliderView'
  'compiled/views/PaginatedCollectionView'
  'jqueryui/jquery.jcontent.0.8',
  'jqueryui/jquery.easing.1.3'
], ($, template, TotalAccountSliderView, PaginatedCollectionView) ->

  class TotalAccountSliderCollectionView extends PaginatedCollectionView

    template: template
    itemView: TotalAccountSliderView