define [
  'Backbone'
  'compiled/backbone-ext/DefaultUrlMixin'
], ({Model}, DefaultUrlMixin) ->

  class Reward extends Model

    resourceName: 'rewards'

    urlRoot: -> 'rewards'



#    initialize: ->
#      console.log 'a project has be instantiated'
#
    defaults:
      name: "Sample task"
      description: "Sample task"
      expiry_date: new Date()
      how_many: "2"
      referrer_amount: "10"
      referrer_percentage: "1"
      referree_amount: "10"
      referree_percentage: "1"
      email_subject: "Sample task"
      email_template_txt: "Sample task"
      alpha_mask: "AA"
      metadata: "Sample task"
      referrar_expiry_date: new Date()
      referree_expiry_date: new Date()
      account_id: "1"
      user_id: "1"
      pseudonym_id: "1"
#
    toJSON: ->
      @options


