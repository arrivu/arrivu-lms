define [
  'Backbone'
  'jquery'
  'i18n!home_pages'
  'str/htmlEscape'
  'jst/HomePages/AddknowledgePartner'
  'compiled/models/KnowledgePartner'
  'compiled/collections/KnowledgePartnersCollection'
  'compiled/views/HomePages/TotalKnowledgePartnerCollectionView'
  'compiled/jquery/fixDialogButtons'
], ({View},$,I18n,htmlEscape, template,KnowledgePartner,KnowledgePartnerCollection,TotalKnowledgePartnerCollectionView) ->

  class AddKnowledgePartner extends View
    template: template

    className: 'validated-form-view form-horizontal bootstrap-form'

    events:
      'click #add_knowledge_partner': 'add_knowledge_partner'
      'click #delete_knowledge_partners': 'delete_knowledge_partners'

    afterRender: ->
      super
      @$el.dialog
        title: 'Add knowledge Partner'
        width:  800
        height: 600
        close: => @$el.remove()
      @show_all_knowledge_partners()

    show_all_knowledge_partners: =>
      console.log('show all inside knowledge partner')
      knowledgePartnerCollection = new KnowledgePartnerCollection
      totalKnowledgePartnerCollectionView = new TotalKnowledgePartnerCollectionView
        collection: knowledgePartnerCollection
        el: "#all_knowledge_partners"
      totalKnowledgePartnerCollectionView.collection.fetch()
      totalKnowledgePartnerCollectionView.render()

    add_knowledge_partner: ->
      fileUploadOptions:
        fileUpload: true
        preparedFileUpload: true
        upload_only: true
        singleFile: true
        context_code: ENV.context_asset_string
        folder_id: ENV.folder_id
        formDataTarget: 'uploadDataUrl'
        object_name: 'knowledgepartner'
        required: ['knowledgepartner[uploaded_data]']

    delete_knowledge_partners:(event) ->
      deleteview = @$(event.currentTarget).closest('.knowledge_partners_item').data('view')
      delete_knowledge_partner_item = deleteview.model
      deletemsg = "Are you sure want to remove this Knowledge Partner from this account?"
      dialog = $("<div>#{deletemsg}</div>").dialog
        modal: true,
        resizable: false
        buttons: [
          text: 'Cancel'
          click: => dialog.dialog 'close'
        ,
          text: 'Delete'
          click: =>
            url = "api/v1/accounts/"+ENV.account_id+"/knowledge_partners/"+delete_knowledge_partner_item.id
            $.ajaxJSON url, 'DELETE',{}, ondeleteSuccess,onError
            dialog.dialog 'close'
            @show_all_knowledge_partners()
        ]

    ondeleteSuccess = (event) ->
      $.flashMessage(htmlEscape(I18n.t('knowledge_partner_deleteed_message', " Knowledge Partner Details Removed Suceessfully!")))

    onSuccess = (event) ->
      $.flashMessage(htmlEscape(I18n.t('knowledge_partner_created_message', " Knowledge Partner Details Added Suceessfully!")))

    onError = => @onSaveFail()

    onSaveFail: (xhr) =>
      super
      message = xhr.responseText
      @$el.prepend("<div class='alert alert-error'>#{message}</span>")