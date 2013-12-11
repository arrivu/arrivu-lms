require [
  'compiled/collections/RewardCollection',
  'compiled/views/Rewards/IndexView'
], (RewardsCollection, IndexView) ->

  # Collections
  rewards = new RewardsCollection
  rewards.fetch()
  indexview = new IndexView
#    rewardsView: rewardsCollectionView
    el: '#rewards'

  indexview.render()