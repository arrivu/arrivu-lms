define [
  'Backbone'
  'underscore'
  'compiled/models/Reward'
], (Backbone, _, Reward) ->

  class RewardCollection extends Backbone.Collection
    model: Reward

