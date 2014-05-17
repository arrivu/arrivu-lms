define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/LearnerReview'
], (PaginatedCollection, LearnerReview) ->

  class LearnerReviewCollection extends PaginatedCollection
    model: LearnerReview