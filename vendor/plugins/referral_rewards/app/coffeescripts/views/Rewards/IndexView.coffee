define [
  'jquery'
  'i18n!rewards'
  'str/htmlEscape'
  'plugins/jst/rewards/IndexView'
  'compiled/plugins/views/Rewards/AddRewardView'
  'compiled/plugins/views/Rewards/EditView'
  'compiled/plugins/models/Reward'
], ($, I18n, htmlEscape, template, AddRewardView, EditView, Reward) ->

  class IndexView extends Backbone.View

    @child 'externalToolsView', '[data-view=rewards]'

    template: template

#    defaults:
#      name: "Sample task"
#      description: "Sample task"
#      expiry_date: new Date()
#      how_many: "2"
#      referrer_amount: "10"
#      referrer_percentage: "1"
#      referree_amount: "10"
#      referree_percentage: "1"
#      email_subject: "Sample task"
#      email_template_txt: "Sample task"
#      alpha_mask: "AA"
#      metadata: "Sample task"
#      referrar_expiry_date: new Date()
#      referree_expiry_date: new Date()
#      account_id: "1"
#      user_id: "1"
#      pseudonym_id: "1"

#    els:
#      '.view_tools_link': '$viewToolsLink'
#      '.view_app_center_link': '$viewAppCenterLink'
#      '.add_tool_link': '$addToolLink'
#      '#app_center_filter': '$appCenterFilter'
#      '[data-view=appFull]': '$appFull'

    events:
#      'click .view_tools_link': 'showExternalToolsView'
#      'click .view_app_center_link': 'showAppCenterView'
#      'click .app': 'showAppFullView'
      'click .add_tool_link': 'addTool'
#      'click [data-edit-external-tool]': 'editTool'
#      'click [data-delete-external-tool]': 'deleteTool'
#      'change #app_center_filter': 'filterApps'
#      'keyup #app_center_filter': 'filterApps'

#    currentAppCenterPosition: 0

    afterRender: ->
#      if @options.appCenterEnabled
#        @appCenterView.collection.fetch()
#        @showAppCenterView()
#      else
#        @showExternalToolsView()

#    hideExternalToolsView: =>
#      @externalToolsView.hide()
#      @$viewToolsLink.show()
#      @$addToolLink.hide()

#    hideAppCenterView: =>
#      @currentAppCenterPosition = $(document).scrollTop()
##      @appCenterView.hide()
##      @$appCenterFilter.hide()
#      @$viewAppCenterLink.show() if @options.appCenterEnabled

#    removeAppFullView: ->
#      @appFullView.remove() if @appFullView

#    showExternalToolsView: =>
#      @removeAppFullView()
##      @hideAppCenterView()
#      @$viewAppCenterLink.hide() unless @options.appCenterEnabled
#      @$viewToolsLink.hide()
#      @$addToolLink.show()
#      @externalToolsView.collection.fetch()
#      @externalToolsView.show()

#    showAppCenterView: =>
#      @removeAppFullView()
#      @hideExternalToolsView()
#      @$viewAppCenterLink.hide()
##      @appCenterView.show()
#      @$appCenterFilter.show()
#      $(document).scrollTop(@currentAppCenterPosition)

#    showAppFullView: (event) ->
#      @hideExternalToolsView()
#      @hideAppCenterView()
#      view = @$(event.currentTarget).data('view')
#      @appFullView = new AppFullView
#        model: view.model
#      @appFullView.on 'cancel', @showAppCenterView, this
#      @appFullView.on 'addApp', @addApp, this
#      @appFullView.render()
#      @$appFull.append @appFullView.$el

    addApp: ->
      newTool = new Reward
      newTool.on 'sync', @onToolSync
      @addAppView = new AddRewardView(app: @appFullView.model, model: newTool).render()

    addTool: ->
      newTool = new Reward
      newTool.on 'sync', @onToolSync
      @editView = new EditView(model: newTool).render()

    editTool: (event) ->
      view = @$(event.currentTarget).closest('.external_tool_item').data('view')
      tool = view.model
      tool.on 'sync', @onToolSync
      @editView = new EditView(model: tool).render()

    onToolSync: (model) =>
      @addAppView.remove() if @addAppView
      @editView.remove() if @editView
#      @showExternalToolsView()
      $.flashMessage(htmlEscape(I18n.t('app_saved_message', "%{app} saved successfully!", { app: model.get('name') })))

#    filterApps: (event) =>
#      @appCenterView.filterText = @$appCenterFilter.val()
#      @appCenterView.render()

#    deleteTool: (event) ->
#      view = @$(event.currentTarget).closest('.external_tool_item').data('view')
#      tool = view.model
#      msg = I18n.t 'remove_tool', "Are you sure you want to remove this tool?"
#      dialog = $("<div>#{msg}</div>").dialog
#        modal: true,
#        resizable: false
#        title: I18n.t('delete', 'Delete') + ' ' + tool.get('name') + '?'
#        buttons: [
#          text: I18n.t 'buttons.cancel', 'Cancel'
#          click: => dialog.dialog 'close'
#        ,
#          text: I18n.t 'buttons.delete', 'Delete'
#          click: =>
#            tool.on('sync', => @externalToolsView.collection.fetch())
#            tool.destroy()
#            dialog.dialog 'close'
#        ]