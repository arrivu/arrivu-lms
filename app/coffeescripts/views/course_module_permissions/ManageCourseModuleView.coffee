define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_module_permissions/manageModules'
  'compiled/views/course_module_permissions/ModulePermissionButtonView'
  'compiled/views/course_module_permissions/ModuleHeaderView'
], ($, _, Backbone, template, ModulePermissionButtonView, ModuleHeaderView) ->
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

      btnselect =$(event.currentTarget).text()
      if btnselect is "SelectAll"
        $(event.currentTarget).addClass "ui-state-active"
        $(event.currentTarget).text "UnSelectAll"
        $("a[data-user_id]").val ->
         mid= $(this).attr "data-user_id"
         sid= $(event.currentTarget).attr("data-select_user_id")
         btnselectvalue = $(event.currentTarget).text()
         if mid is sid and btnselectvalue is "UnSelectAll"
          $(this).find("i").removeClass("icon-x").addClass "icon-check"
      else
        $(event.currentTarget).removeClass "ui-state-active"
        $(event.currentTarget).text "SelectAll"
        $("a[data-user_id]").val ->
         mid= $(this).attr "data-user_id"
         sid= $(event.currentTarget).attr("data-select_user_id")
         btnselectvalue = $(event.currentTarget).text()
         if mid is sid and btnselectvalue is "SelectAll"
          $(this).find("i").removeClass("icon-check").addClass "icon-x"

    # Method Summary
    #   The table has two parts. A header and the tbody part. The header 
    #   has some functionality to do with deleting a role so contains its
    #   own logic. renderHeader gets called when renderTable gets 
    #   called, which should get called when role is added or removed.
    # @api private
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
        module_id == parseInt(module_id, 10)
        if key == module_id
          find_in_array(user_id, value)


    find_in_array = (my_item, my_array) ->
      for item in my_array
        return true if item == my_item
      false
