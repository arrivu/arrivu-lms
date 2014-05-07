define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/CoursePricing'
], (PaginatedCollection, CoursePricing) ->

  class CoursePricingCollection extends PaginatedCollection
    model: CoursePricing