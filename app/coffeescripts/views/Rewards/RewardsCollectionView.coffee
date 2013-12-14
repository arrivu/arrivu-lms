define [
  'Backbone'
  'underscore'
  'jquery'
  'str/htmlEscape'
  'jst/rewards/CollectionView'
  'compiled/views/Rewards/RewardListView'
  'compiled/models/Reward'
], (Backbone, _, $, htmlEscape, template, RewardListView, Reward) ->

  class RewardsCollectionView extends Backbone.View

    template: template

    initialize: ->

