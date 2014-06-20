define [
  'jquery'
  'jst/topics/EditView'
  'compiled/views/ValidatedFormView'
  'compiled/jquery/fixDialogButtons'
  'jquery.minicolors'
], ($,template, ValidatedFormView) ->
  class EditView extends ValidatedFormView
    template: template
    tagName: 'form'
    id: 'topic_form'

    className: 'validated-form-view form-horizontal bootstrap-form'

    afterRender: ->
      super
      @$el.dialog
        title: 'Edit Topic'
        width: 450
        height: "auto"
        resizable: true
        close: => @$el.remove()
        buttons: [
          class: "btn-primary"
          text: 'Submit'
          'data-text-while-loading':  'Saving...'
          click: => @submit()
        ]
      $("#hue-demo").minicolors
          control: $(this).attr("data-control") or "hue"
          defaultValue: $(this).attr("data-defaultValue") or ""
          inline: $(this).attr("data-inline") is "true"
          letterCase: $(this).attr("data-letterCase") or "lowercase"
          opacity: $(this).attr("data-opacity")
          position: $(this).attr("data-position") or "bottom left"
      change: (hex, opacity) ->
          log = undefined
      try
          log = (if hex then hex else "transparent")
          log += ", " + opacity  if opacity
          console.log log
          return
          theme: "default"
      @$el.submit (e) =>
        @submit()
        return false
      this

    submit: ->
      this.$el.parent().find('.btn-primary').removeClass('ui-state-hover')
      super

    showErrors: (errors) ->
      @removeErrors()
      for fieldName, field of errors
        $input = @findField fieldName
        html = (@translations[message] or message for {message} in field).join('</p><p>')
        @addError($input, html)

    removeErrors: ->
      @$('.error .help-inline').remove()
      @$('.control-group').removeClass('error')
      @$('.alert.alert-error').remove()

    addError: (input, message) ->
      input = $(input)
      input.parents('.control-group').addClass('error')
      input.after("<span class='help-inline'>#{message}</span>")
      input.one 'keypress', ->
        $(this).parents('.control-group').removeClass('error')
        $(this).parents('.control-group').find('.help-inline').remove()

    onSaveFail: (xhr) =>
      super
      message = 'There was an error in processing your request'
      @$el.prepend("<div class='alert alert-error'>#{message}</span>")
