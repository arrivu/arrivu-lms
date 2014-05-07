define [
  'jquery'
  'jst/HomePages/KnowledgePartnerCollectionView'
  'compiled/views/HomePages/KnowledgePartnerView'
  'compiled/views/PaginatedCollectionView'
], ($, template, KnowledgePartnerView,PaginatedCollectionView) ->

  class KnowledgePartnerCollectionView extends PaginatedCollectionView

    template: template
    itemView: KnowledgePartnerView