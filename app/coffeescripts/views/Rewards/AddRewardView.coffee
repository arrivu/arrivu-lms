define [
  'Backbone'
  'underscore'
  'jst/rewards/AddRewardView'
  'jquery.disableWhileLoading'
  'compiled/views/Rewards/RewardListView'
], (Backbone, _, template, disableWhileLoading, RewardListView) ->

  class AddRewardView extends Backbone.View
    template: template

    tagName: 'form'
    id: 'add_reward_form'
    className: 'validated-form-view form-horizontal bootstrap-form'

    initialize: ->
      console.log 'a project has be instantiated'

      @model.on 'error', @onSaveFail, this

    afterRender: ->
      @$el.dialog
        title: 'Add Reward'
        width: 520
        height: "auto"
        resizable: true
        close: =>
          @$el.remove()
        buttons: [
          class: "btn-primary"
          text: 'Submit'
          'data-text-while-loading': 'Saving...'
          click: => @submit()
        ]
      @$el.submit (e) =>
        @submit()
        return false
      this

    submit: ->
      formData = @$el.getFormData()
      @model.set 'offer_name', formData['offer_name'] if formData['offer_name']
      @model.set 'description', formData['description'] if formData['description']
      @model.set 'how_many', formData['how_many'] if formData['how_many']
      @model.set 'referrar_amount', formData['referrar_amount'] if formData['referrar_amount']
      @model.set 'referrar_percentage', formData['referrar_percentage'] if formData['referrar_percentage']
      @model.set 'referree_amount', formData['referree_amount'] if formData['referree_amount']
      @model.set 'referree_percentage', formData['referree_percentage'] if formData['referree_percentage']
      @model.set 'email_subject', formData['email_subject'] if formData['email_subject']
      @model.set 'email_text', formData['email_text'] if formData['email_text']
      disablingDfd = new $.Deferred()
      @$el.disableWhileLoading @model.save,
        wait: true
        success: (model, response) ->
          rewardListView = new RewardListView
            reward: response.attributes.reward
          $('#rewardlist').prepend rewardListView.render().el
          $.flashMessage 'Reward created'
        error: (model, errors) ->
          @addError "input[name='#{error['name']}']", 'Required' for error in errors

    removeErrors: ->
      @$('.error .help-inline').remove()
      @$('.control-group').removeClass('error')
      @$('.alert.alert-error').remove()

    addError: (input, message) ->
      input = @$(input)
      input.parents('.control-group').addClass('error')
      input.after("<span class='help-inline'>#{message}</span>")
      input.one 'keypress', ->
        $(this).parents('.control-group').removeClass('error')
        $(this).parents('.control-group').find('.help-inline').remove()

    onSaveFail: (model) =>
      message = 'There was an error in processing your request'
      @$el.prepend("<div class='alert alert-error'>#{message}</span>")
      @addError "input[name='#{error['name']}']", 'Required' for error in errors


