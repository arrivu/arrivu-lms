define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_module_permissions/modulePermissionButton'
], ($, _, Backbone, template) ->
  class PermissionButtonView extends Backbone.View
    template: template
    tagName: 'td'
    className: 'permissionButtonView'

    events:
      'click .dropdown-toggle' : "updatePermission",
      'click #btnclassidnot' : "selectalluserid"


    initialize: ->
      super
      @user_id = @options.user_id if @options.user_id
      @user_enrolled = @options.user_enrolled

    toJSON: ->
      json = super

      json['user_id'] = @user_id
      json['module_id'] = @model.id
      json['user_enrolled'] = @user_enrolled

      json



    updatePermission: (event) ->
      switch $(event.currentTarget).children().first().prop("class")
        when "icon-x"
          work_status = "active"
          break
        when "icon-check"
          work_status = "inactive"
          break
      module_id = $(event.currentTarget).attr("data-module_id")
      user_id = $(event.currentTarget).attr("data-user_id")
      @saveModel(module_id,user_id,work_status)
      icon = $(event.currentTarget).children().first().prop("class")
      if icon is "icon-x"
       $(event.currentTarget).find("i").removeClass("icon-x").addClass "icon-check"
      else
       $(event.currentTarget).find("i").removeClass("icon-check").addClass "icon-x"

    saveModel:(module_id,user_id,work_status) ->
      @model.save {module_id: module_id,user_id:user_id,status:work_status},
        failure: ->
          alert 'Permission was not be saved!'

    selectalluserid: (event) ->
      btnselect = $(event.currentTarget).text()
      total_module_id = []
      if btnselect is "SelectAll"
        $(event.currentTarget).addClass "ui-state-active"
        $(event.currentTarget).text "UnSelectAll"
        selected_user_id= $(event.currentTarget).attr("data-select_user_id")
        work_status = "active"
        $("a[data-user_id]").val ->
          uid= $(this).attr "data-user_id"
          mid= $(this).attr "data-module_id"
          sid= $(event.currentTarget).attr("data-select_user_id")
          btnselectvalue = $(event.currentTarget).text()

          if uid is sid and btnselectvalue is "UnSelectAll"
            $(this).find("i").removeClass("icon-x").addClass "icon-check"
            @saveModel(mid,sid,work_status)


      else
        $(event.currentTarget).removeClass "ui-state-active"
        $(event.currentTarget).text "SelectAll"
        $("a[data-user_id]").val ->
          uid= $(this).attr "data-user_id"
          mid= $(this).attr "data-module_id"
          sid= $(event.currentTarget).attr("data-select_user_id")
          work_status = "inactive"
          btnselectvalue = $(event.currentTarget).text()
          if uid is sid and btnselectvalue is "SelectAll"
            $(this).find("i").removeClass("icon-check").addClass "icon-x"
            @saveModel(mid,sid,work_status)
