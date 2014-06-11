define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/AccountTag'
], (PaginatedCollection, AccountTag) ->

  class AccountTagsCollection extends PaginatedCollection
    model: AccountTag