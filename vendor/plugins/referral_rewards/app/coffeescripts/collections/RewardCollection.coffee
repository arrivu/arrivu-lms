define [
  'compiled/collections/PaginatedCollection'
  'compiled/plugins/models/Reward'
], (PaginatedCollection, Reward) ->

  class RewardCollection extends PaginatedCollection
    model: Reward
