(function() {
  require(['compiled/collections/RewardCollection', 'plugins/referral_rewards/javascripts/compiled/bundles/rewards', 'compiled/views/Rewards/IndexView'], function(RewardsCollection, reward, IndexView) {
    var indexview, rewards;

    rewards = new RewardsCollection;
    rewards.fetch();
    indexview = new IndexView({
      el: '#rewards'
    });
    return indexview.render();
  });

}).call(this);
