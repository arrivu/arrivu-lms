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
      @model_url = @manageReferralsCollectionView.collection.url()
      @manageReferralsCollectionView.show()

    couponReward: (event) ->
      view = @$(event.currentTarget).closest('.referrees_item').data('view')
      referree = view.model
      referree.url = @model_url
      referree.save(coupon_code: referree.attributes.coupon_code,status:"used")
