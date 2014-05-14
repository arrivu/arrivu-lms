define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/LearnerReview'
], (PaginatedCollection, LearnerReview) ->

  class KnowledgePartnersCollection extends PaginatedCollection
    model: LearnerReview