define [
  'Backbone'
  'underscore'
  'jquery'
  'str/htmlEscape'
  'jst/rewards/IndexView'
  'compiled/views/Rewards/AddRewardView'
  'compiled/views/Rewards/EditView'
  'compiled/models/Reward'
  'compiled/views/Rewards/RewardListView'
  'compiled/collections/RewardCollection'
], (Backbone, _, $, htmlEscape, template, AddRewardView, EditView, Reward, RewardListView, RewardCollection) ->

  class IndexView extends Backbone.View

    template: template

    events:
      'click .add_tool_link': 'addReward'


    initialize: ->
      @rewards = new RewardCollection
      @rewards.fetch()
      @rewards.on('sync',@renderListView,this)

    renderListView: ->
      @rewards.each (reward) =>
        rewardListView = new RewardListView
          reward: reward.attributes.reward
        $('#rewardlist').append rewardListView.render().el


    addReward: ->
      newReward = new Reward
      newReward.on 'sync', @onRewardSync
      @addRewardView = new AddRewardView(model: newReward).render()



    onRewardSync: (model) =>
      $('.ui-dialog').hide()
      $('.ui-widget-overlay').hide()
      $.flashMessage("Reward saved successfully")
      rewardListView = new RewardListView
        reward: model.attributes
      $('#rewardlist').prepend rewardListView.render().el



