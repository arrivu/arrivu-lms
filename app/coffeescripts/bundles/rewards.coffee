require [
  'compiled/collections/RewardCollection',
  'compiled/views/Rewards/IndexView'
], (RewardCollection, IndexView) ->

  # Collections


  indexview = new IndexView
     el: '#rewards'

  indexview.render()

