define [
  'jquery'
  'jst/AccountTags/EditAccountTagView'
  'compiled/views/ValidatedFormView'
  'compiled/jquery/fixDialogButtons'
  'jquery.instructure_date_and_time'
  'compiled/tinymce'
  'tinymce.editor_box'
], ($,template,ValidatedFormView) ->

  class EditView extends ValidatedFormView
    template:template
    tagname: 'form'
    id: 'account_tags_form'

    className: 'validated-form-view form-horizontal bootstrap-form'

    afterRender: ->
      super
      @$el.dialog
        title: 'Edit Account Tags'
        width:  600
        height: "auto"
        resizable: true
        close: => @$el.remove()
        buttons: [
          class: "btn-primary"
          text:  'Submit'
          'data-text-while-loading': 'Saving...'
          click: => @submit()
        ]
      timeField = @$el.find(".date_field")
      timeField.date_field()
      editor = @$el.find(".rich_editor")
      editor.editorBox()
      setTimeout (->
        tinymce.execCommand "mceAddControl", true, "email_text"
        editor.editorBox()
      ), 0

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
      message = xhr.responseText
      @$el.prepend("<div class='alert alert-error'>#{message}</span>")