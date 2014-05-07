define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/AccountSlider'
], (PaginatedCollection, AccountSlider) ->

  class AccountSlidersCollection extends PaginatedCollection
    model: AccountSlider