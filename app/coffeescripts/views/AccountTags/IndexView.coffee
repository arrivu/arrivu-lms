define [
  'jquery'
  'i18n!account_tags'
  'str/htmlEscape'
  'jst/AccountTags/IndexView'
  'compiled/views/AccountTags/EditView'
  'compiled/models/AccountTag'
], ($,I18n, htmlEscape, template,EditView, AccountTag) ->

  class IndexView extends Backbone.View

    @child 'accountTagsCollectionView', '[data-view=account_tags]'

    template: template

    events:
      'click [data-edit-tags]': 'editAccountTags'
      'click [data-delete-tags]': 'deleteAccountTags'
      'click #select_tag_type': 'select_tag_type'

    afterRender: ->
      @showAccountTagView()

    showAccountTagView: =>
      @accountTagsCollectionView.collection.setParam('per_page', 50)
      @accountTagsCollectionView.collection.fetch()
      @accountTagsCollectionView.show()

    editAccountTags:(event) ->
      view = @$(event.currentTarget).closest('.account_tags_item').data('view')
      account_tags = view.model
      account_tags.on 'sync', @onAccountTagsSync
      @editAccountTagsView = new EditView(model: account_tags).render()

    deleteAccountTags:(event) ->
      deleteview = @$(event.currentTarget).closest('.account_tags_item').data('view')
      delete_course_price_item = deleteview.model
      deletemsg = "Are you sure want to remove this Tag?"
      dialog = $("<div>#{deletemsg}</div>").dialog
        modal: true,
        resizable: false
        title: I18n.t('delete', 'Delete Account Tag')
        buttons: [
          text: 'Cancel'
          click: => dialog.dialog 'close'
        ,
          text: 'Delete'
          click: =>
            delete_course_price_item.destroy()
            dialog.dialog 'close'
            $.flashMessage(htmlEscape(I18n.t('account_tag_deleted_message', " Tag deleted successfully!")))
        ]


    onAccountTagsSync: =>
      @editAccountTagsView.remove() if @editAccountTagsView
      @showAccountTagView()
      $.flashMessage(htmlEscape(I18n.t('account_tag_saved_message', " Tags Updated successfully!")))

    select_tag_type:(event) ->
      clicked_tag_type = $("#select_tag_type").val()
      @accountTagsCollectionView.collection.setParam('per_page', 50)
      @accountTagsCollectionView.collection.fetch({ data:{source: clicked_tag_type}})