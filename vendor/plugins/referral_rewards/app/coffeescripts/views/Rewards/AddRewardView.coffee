define [
  'Backbone'
  'i18n!rewards'
  'underscore'
  'plugins/jst/rewards/AddRewardView'
  'jquery.disableWhileLoading'
], (Backbone, I18n, _, template, disableWhileLoading) ->

  class AddRewardView extends Backbone.View
    template: template

    tagName: 'form'
    id: 'add_app_form'
    className: 'validated-form-view form-horizontal bootstrap-form'
    console.log 'a project has be instantiated'
    initialize: ->
      console.log 'a project has be instantiated'
      super
      @app = @options.app
      @model.set 'course_name', @app.get('course_name')
      @model.set 'offer_name', @app.get('offer_name')
      @model.set 'reward_description', @app.get('reward_description')
      @model.set 'how_many', @app.get('how_many')
      @model.set 'referrar_amount', @app.get('referrar_amount')
      @model.set 'referrar_percentage', @app.get('referrar_percentage')
      @model.set 'referree_amount', @app.get('referree_amount')
      @model.set 'referree_percentage', @app.get('referree_percentage')
      @model.set 'email_subject', @app.get('email_subject')
      @model.set 'email_text', @app.get('email_text')
      @model.on 'error', @onSaveFail, this
      console.log 'a project has be instantiated'
#      @configOptions = @app.get('config_options') || []
#
#      if @app.get('any_key')
#        @model.set 'consumer_key', 'N/A'
#        @model.set 'shared_secret', 'N/A'
#      else
#        @configOptions = @keySecretConfigOptions().concat @configOptions

    afterRender: ->
      @$el.dialog
        title: I18n.t 'dialog_title_add_reward', 'Add Reward'
        width: 520
        height: "auto"
        resizable: true
        close: =>
          @$el.remove()
        buttons: [
          class: "btn-primary"
          text: I18n.t 'submit', 'Submit'
          'data-text-while-loading': I18n.t 'saving', 'Saving...'
          click: => @submit()
        ]
      @$el.submit (e) =>
        @submit()
        return false
      this

    toJSON: =>
      json = super
#      json.anyKey = @app.get('any_key')
#      json.configOptions = []
#      _.each @configOptions, (option) ->
#        option.isCheckbox = true if option.type is 'checkbox'
#        option.isText = true if option.type is 'text'
#        json.configOptions.push option
#      json

    submit: ->
      console.log 'a project has be instantiated'
      formData = @$el.getFormData()
      @model.set 'metadata', formData['course_name'] if formData['course_name']
      @model.set 'name', formData['offer_name'] if formData['offer_name']
      @model.set 'description', formData['reward_description'] if formData['reward_description']
      @model.set 'how_many', formData['how_many'] if formData['how_many']
      @model.set 'referrer_amount', formData['referrar_amount'] if formData['referrar_amount']
      @model.set 'referrer_percentage', formData['referrar_percentage'] if formData['referrar_percentage']
      @model.set 'referree_amount', formData['referree_amount'] if formData['referree_amount']
      @model.set 'referree_percentage', formData['referree_percentage'] if formData['referree_percentage']
      @model.set 'email_subject', formData['email_subject'] if formData['email_subject']
      @model.set 'email_template_txt', formData['email_text'] if formData['email_text']
      @model.save
        error: ->
        disablingDfd.reject()
          success: ->
          disablingDfd.resolve()
      @$el.disableWhileLoading disablingDfd

#    updateConfigUrl: (formData) ->
#      configUrl = @model.get('config_url')
#      queryParams = {}
#      queryParams[option['name']] = formData[option['name']] for option in @configOptions when formData[option['name']]
#      delete queryParams['consumer_key']
#      delete queryParams['shared_secret']
#      newConfigUrl = @model.get('config_url') + (if configUrl.indexOf('?') != -1 then '&' else '?') + $.param(queryParams)
#      @model.set('config_url', newConfigUrl)

#    validate: (formData) ->
#      @removeErrors()
#      errors = (option for option in @configOptions when !formData[option['name']] && option['required'])
#      @addError "input[name='#{error['name']}']", 'Required' for error in errors
#      errors.length == 0

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


