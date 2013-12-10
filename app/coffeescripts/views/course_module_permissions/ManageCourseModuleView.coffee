define [
  'jquery'
  'underscore'
  'Backbone'
  'compiled/models/ModulePermission'
  'jst/course_module_permissions/manageModules'
  'compiled/views/course_module_permissions/ModulePermissionButtonView'
  'compiled/views/course_module_permissions/ModuleHeaderView'
], ($, _, Backbone, ModulePermission, template, ModulePermissionButtonView, ModuleHeaderView) ->
  class ManageCourseModuleView extends Backbone.View
    template: template
    className: 'manage-roles-table'
    events:
      'click #btnclassid' : "selectalluser"
    # Method Summary
    #   When a new Role is added/removed from the collection, re-draw the table.
    initialize: -> 
      super

      @enrolled_users = @options.enrolled_users if @options.enrolled_users
    toJSON: ->
      json = super

      json['selected_module_users'] = @selected_module_users


      json
    # Method Summary
    #   Gets called after this backbone view has
    #   been rendered. For each permission in the 
    #   permission list, it will add a new 
    #   permission select box for each role in the roles
    #   collection. In this way, we are drawing the
    #   whole table row by row since html doesn't
    #   support drawing column by column. 
    # @api custom backbone
    afterRender: ->
      @renderTable()

    selectalluser: (event) ->
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
        @collection.each (module) ->
          module.save {module_id: module.id,user_id:selected_user_id,status:work_status},
            failure: ->
          alert 'module was not be saved!'
      else
        $(event.currentTarget).removeClass "ui-state-active"
        $(event.currentTarget).text "SelectAll"
        work_status = "inactive"
        $("a[data-user_id]").val ->
         uid= $(this).attr "data-user_id"
         mid= $(this).attr "data-module_id"
         selected_user_id= $(event.currentTarget).attr("data-select_user_id")
         btnselectvalue = $(event.currentTarget).text()
         if uid is sid and btnselectvalue is "SelectAll"
          $(this).find("i").removeClass("icon-check").addClass "icon-x"
        @collection.each (module) ->
          module.save {module_id: module.id,user_id:selected_user_id,status:work_status},
            failure: ->
          alert 'module was not be saved!'

    # Method Summary



    #   The table has two parts. A header and the tbody part. The header 
    #   has some functionality to do with deleting a role so contains its
    #   own logic. renderHeader gets called when renderTable gets 
    #   called, which should get called when role is added or removed.
    # @api private
    saveModel:(model,module_id,user_id,work_status) ->
      model.save {module_id: module_id,user_id:user_id,status:work_status},
        failure: ->
          alert 'module was not be saved!'

    renderHeader: -> 
      @$el.find('thead tr').html "<th>Modules</th><th class='permissionButtonView'></th>"

      @collection.each (module) =>
        moduleHeaderView = new ModuleHeaderView
          model: module
        @$el.find('thead tr').append moduleHeaderView.render().el


    renderTable: => 
      @renderHeader()
      @$el.find('tbody').html '' # Clear tbody in case it gets re-drawing.

      _.each @permission_groups, (permission_group) =>
        # Add the headers to the group
        permission_group_header = """
                                    <tr class="toolbar">
                                      <th colspan="#{@collection.length + 1}">#{permission_group.group_name.toUpperCase()}</th>
                                    </tr>
                                  """

        @$el.find('tbody').append permission_group_header
      # Add each permission item.
      _.each @enrolled_users , (enrolled_user) =>

        user_row_html = """
                          <tr>
                            <th role="rowheader">#{enrolled_user.name}</th><th class="permissionButtonView"><button id="btnclassid" class="ui-button ui-widget ui-state-default ui-button-text-only ui-corner-right" data-select_user_id="#{enrolled_user.id}">SelectAll</button></th>
                          </tr>
                         """

        @$el.find('tbody').append user_row_html

        @collection.each (module) =>
          modulePermissionButtonView = new ModulePermissionButtonView
                                   model: module
                                   user_id: enrolled_user.id
                                   user_enrolled: @check_permission(module.id,enrolled_user.id)

          @$el.find("tr")
              .last()
              .append modulePermissionButtonView.render().el


    check_permission:(module_id,user_id) ->
      for key, value of ENV.MODULE_PERMISSION_USER_IDS
        module_id = parseInt(module_id, 10)
        key_module_id = parseInt(key, 10)
        if key_module_id == module_id
          for item in value
            user_id_in_array = parseInt(item, 10)
            user_id = parseInt(user_id, 10)
            return true if user_id_in_array == user_id
          false
#          @find_in_array(user_id, value)


    find_in_array:(my_item, my_array) ->
      for item in my_array
        user_id_in_array = parseInt(item, 10)
        user_id = parseInt(my_item, 10)
        return true if user_id_in_array == user_id
      false

