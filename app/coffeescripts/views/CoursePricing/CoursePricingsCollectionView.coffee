define [
  'jquery'
  'str/htmlEscape'
  'jst/CoursePricing/CoursePricingCollectionView'
  'compiled/views/CoursePricing/CoursePricingListView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, template, CoursePriceListView, PaginatedCollectionView) ->

  class CoursePricingsCollectionView extends PaginatedCollectionView

    template: template
    itemView: CoursePriceListView
