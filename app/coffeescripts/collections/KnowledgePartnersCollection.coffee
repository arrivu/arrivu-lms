define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/KnowledgePartner'
], (PaginatedCollection, KnowledgePartner) ->

  class KnowledgePartnersCollection extends PaginatedCollection
    model: KnowledgePartner