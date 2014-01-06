define [
  'jquery'
  'i18n!rewards'
  'str/htmlEscape'
  'jst/rewards/ManageReferralsIndexView'
  'compiled/models/ManageReferral',
], ($, I18n, htmlEscape, template, ManageReferral) ->

  class ManageReferralsIndexView extends Backbone.View

    @child 'manageReferralsCollectionView', '[data-view=redeemRewards]'
    template: template
    events:
      'click [data-coupon-reward]': 'couponReward'

    afterRender: ->
      @showRewardsView()

    showRewardsView: =>
      @manageReferralsCollectionView.collection.fetch()
      @manageReferralsCollectionView.show()
    couponReward: (event) ->
      view = @$(event.currentTarget).closest('.referrees_item').data('view')
      reward = view.model
      reward.on 'sync', @onRewardSync
    onRewardSync: (model) =>
      model.save {coupon_code: "code",status:"active"},
        failure: ->
          alert 'coupon code was not be saved!'




