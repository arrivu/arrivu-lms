define [
  'Backbone'
  'jquery'
  'i18n!home_pages'
  'str/htmlEscape'
  'jst/HomePages/AddAccountSlider'
  'compiled/models/AccountSlider'
  'compiled/collections/AccountSlidersCollection'
  'compiled/views/HomePages/TotalAccountSliderCollectionView'
  'compiled/jquery/fixDialogButtons'
  'compiled/views/ValidatedFormView'
], ({View},$,I18n,htmlEscape, template,AccountSlider,AccountSliderCollection,TotalAccountSliderCollectionView) ->

  class AddAccountSlider extends View
    template: template

    className: 'validated-form-view form-horizontal bootstrap-form'

    els:
      '#upload_account_sliders': '$form'

    events:
      'click #add_account_slider': 'addsliders'
      'click #delete_sliders': 'deletesliders'

    messages:
      addingFile:     I18n.t('buttons.adding_file', 'Adding File...')
      addFile:        I18n.t('buttons.add_file', 'Add File')
      addFailed:      I18n.t('errors.adding_file_failed', 'Adding File Failed')

    addFileButton: ->
      @$addFileButton or= @$form.find('button')

    afterRender: ->
      super
      @$el.dialog
        title: 'Add Account Slider'
        width:  800
        height: 600
        position: 'center'
        close: => @$el.remove()
      @showallSlides()

    showallSlides: =>
      accountSliderCollection = new AccountSliderCollection
      totalaccountSliderCollectionView = new TotalAccountSliderCollectionView
        collection: accountSliderCollection
        el: '#all_sliders'
      totalaccountSliderCollectionView.collection.fetch()
      totalaccountSliderCollectionView.render()

    addsliders: ->
      if $("#accountslider_uploaded_data").val() != ""
        slider =   $("#accountslider_uploaded_data").val()
        extension = slider.split('.').pop().toUpperCase()
      if $("#accountslider_uploaded_data").val() == ""
        @$('#upload_account_sliders').append("<div class='alert alert-error'
        style='text-align: center;margin-top: -108px;;position:absolute;margin-left:157px'>
        Plz Choose a File to Upload</div>")
        event.preventDefault()
      else if extension!="PNG" && extension!="JPG" && extension!="GIF" && extension!="JPEG"
        @$('#upload_account_sliders').append("<div class='alert alert-error'
        style='text-align: center;margin-top: -108px;;position:absolute;margin-left:157px'>
        Plz Choose a Valid File to Upload</div>")
        event.preventDefault()
      else
        fileUploadOptions:
          fileUpload: true
          preparedFileUpload: true
          upload_only: true
          singleFile: true
          context_code: ENV.context_asset_string
          folder_id: ENV.folder_id
          formDataTarget: 'uploadDataUrl'
          object_name: 'accountslider'
          required: ['accountslider[uploaded_data]']

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

    onSuccess = (event) ->
      $.flashMessage(htmlEscape(I18n.t('account_slider_deleted_message', " Account Sliders deleted successfully!")))

    onError = => @onSaveFail()

    deletesliders:(event) ->
      deleteview = @$(event.currentTarget).closest('.accounts_sliders_item').data('view')
      delete_account_slider_item = deleteview.model
      deletemsg = "Are you sure want to remove this slider?"
      dialog = $("<div>#{deletemsg}</div>").dialog
        modal: true,
        resizable: false
        title: I18n.t('delete', 'Delete Sliders')
        buttons: [
          text: 'Cancel'
          click: => dialog.dialog 'close'
        ,
          text: 'Delete'
          click: =>
            url = "api/v1/accounts/"+ENV.account_id+"/sliders/"+delete_account_slider_item.id
            $.ajaxJSON url, 'DELETE',{}, onSuccess,onError
            dialog.dialog 'close'
            @showallSlides()
        ]


