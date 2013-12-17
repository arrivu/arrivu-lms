define [
  'jquery'
  'Backbone'
  'underscore'
  'jst/rewards/RewardList'
], ($,Backbone, _, template) ->

  class RewardListView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'reward_item'


    initialize: ->
      @reward_name = @options.reward.name
      @description = @options.reward.description
      @expiry_date = @options.reward.expiry_date
      @alpha_mask = @options.reward.alpha_mask
      @referrar_amount = @options.reward.referrer_amount
      @referrar_percentage = @options.reward.referrer_percentage
      @referree_amount = @options.reward.referree_amount
      @referree_percentage = @options.reward.referree_percentage
      @referrer_expiry_date = @options.reward.referrer_expiry_date
      @referree_expiry_date = @options.reward.referree_expiry_date
      @how_many = @options.reward.how_many
      @email_subject = @options.reward.email_subject
      @email_text = @options.reward.email_template_txt




    toJSON: ->
      json = super

      json['reward_name'] = @reward_name
      json['description'] = @description
      json['expiry_date'] = @expiry_date
      json['alpha_mask'] = @alpha_mask
      json['referrar_amount'] = @referrar_amount
      json['referrar_percentage'] = @referrar_percentage
      json['referree_amount'] = @referree_amount
      json['referree_percentage'] = @referree_percentage
      json['referree_expiry_date'] = @referree_expiry_date
      json['referrer_expiry_date'] = @referrer_expiry_date
      json['how_many']  = @how_many

      json
