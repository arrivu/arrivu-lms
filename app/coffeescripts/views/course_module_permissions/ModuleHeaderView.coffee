define [
  'i18n!editor'
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_module_permissions/moduleHeader'
], (I18n, $, _, Backbone, template) -> 
  class ModuleHeaderView extends Backbone.View
    template: template
    tagName: 'th'
    className: 'roleHeader'
#    events:
#      'click #btnclass' : "selectallmodule"

#    initialize: ->
#      super
#      @model = @options.model
#
#    toJSON: ->
#      json = super
#
#      json['model'] = @model
#
#      json



    # Method Summary
    #   This is called after render to ensure column header is set for accessiblity.
    # @api custom backbone override
    afterRender: ->
      @$el.attr('module', 'columnheader')

    saveModel:(module_id,user_id,work_status) ->
      @model.save {module_id: module_id,user_id:user_id,status:work_status},
        failure: ->
          alert 'Permission was not be saved!'

    selectallmodule: (event) ->

      btnselect =$(event.currentTarget).text()
      if btnselect is "SelectAll"
       $(event.currentTarget).addClass "ui-state-active"
       $(event.currentTarget).text "UnSelectAll"
       $("a[data-module_id]").val ->
        mid= $(this).attr "data-module_id"
        uid= $(this).attr "data-user_id"
        work_status = "active"
        sid= $(event.currentTarget).attr("data-select_module_id")
        btnselectvalue = $(event.currentTarget).text()
        if mid is sid and btnselectvalue is "UnSelectAll"
         $(this).find("i").removeClass("icon-x").addClass "icon-check"
         modelId = @model.id


      else
       $(event.currentTarget).removeClass "ui-state-active"
       $(event.currentTarget).text "SelectAll"
       $("a[data-module_id]").val ->
        mid= $(this).attr "data-module_id"
        sid= $(event.currentTarget).attr("data-select_module_id")
        btnselectvalue = $(event.currentTarget).text()
        if mid is sid and btnselectvalue is "SelectAll"
          $(this).find("i").removeClass("icon-check").addClass "icon-x"

#      alert $(".dropdown-toggle").attr("data-module_id")




