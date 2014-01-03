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

    afterRender: ->
      @showRewardsView()

    showRewardsView: =>
      @manageReferralsCollectionView.collection.fetch()
      @manageReferralsCollectionView.show()
