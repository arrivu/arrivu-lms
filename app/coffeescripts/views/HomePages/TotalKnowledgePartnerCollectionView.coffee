define [
  'jquery'
  'jst/HomePages/TotalKnowledgePartnerCollectionView'
  'compiled/views/HomePages/TotalKnowledgePartnerView'
  'compiled/views/PaginatedCollectionView'
], ($, template, TotalKnowledgePartnerView, PaginatedCollectionView) ->

  class TotalKnowledgePartnerCollectionView extends PaginatedCollectionView

    template: template
    itemView: TotalKnowledgePartnerView