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

    # Method Summary
    #   When a new Role is added/removed from the collection, re-draw the table.
    initialize: -> 
      super
      @enrolled_users = @options.enrolled_users if @options.enrolled_users

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

    # Method Summary
    #   The table has two parts. A header and the tbody part. The header 
    #   has some functionality to do with deleting a role so contains its
    #   own logic. renderHeader gets called when renderTable gets 
    #   called, which should get called when role is added or removed.
    # @api private
    renderHeader: -> 
      @$el.find('thead tr').html "<th>Modules</th>"

      @collection.each (module) =>
        moduleHeaderView = new ModuleHeaderView
          model: module
        @$el.find('thead tr').append moduleHeaderView.render().el


    renderTable: => 
      @renderHeader()
      @$el.find('tbody').html '' # Clear tbody in case it gets re-drawing.

      # Add each permission item.
      _.each @enrolled_users , (enrolled_user) =>

        user_row_html = """
                          <tr>
                            <th role="rowheader">#{enrolled_user.name}</th>
                          </tr>
                         """

        @$el.find('tbody').append user_row_html

        @collection.each (module) =>
          modulePermissionButtonView = new ModulePermissionButtonView
                                   model: module
                                   user_id: enrolled_user.id

          @$el.find("tr")
              .last()
              .append modulePermissionButtonView.render().el
