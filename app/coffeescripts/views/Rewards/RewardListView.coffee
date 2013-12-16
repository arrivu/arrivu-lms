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
      @reward_name = @options.name
      @description = @options.description
      @expiry_date = @options.expiry_date
      @alpha_mask = @options.alpha_mask
      @referrar_amount = @options.referrer_amount
      @referrar_percentage = @options.referrer_percentage
      @referree_amount = @options.referree_amount
      @referree_percentage = @options.referree_percentage
      @referrer_expiry_date = @options.referrer_expiry_date
      @referree_expiry_date = @options.referree_expiry_date
      @how_many = @options.how_many
      @email_subject = @options.email_subject
      @email_text = @options.email_template_txt




    toJSON: ->
      json = super

      json['reward_name'] = @reward_name
      json['description'] = @description
      json['expiry_date'] = @expiry_date
      json['alpha_mask'] = @alpha_mask
      json['referrar_amount'] = @referrar_amount
      json['referrer_percentage'] = @referrar_percentage
      json['referree_amount'] = @referree_amount
      json['referree_percentage'] = @referree_percentage
      json['referree_expiry_date'] = @referrar_expiry_date
      json['how_many']  = @how_many

      json
