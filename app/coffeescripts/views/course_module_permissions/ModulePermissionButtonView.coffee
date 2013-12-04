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
      'click .dropdown-toggle' : "updatePermission"


    initialize: -> 
      super
      @user_id = @options.user_id if @options.user_id


    afterRender: ->
      @setDataAttributes()

    setDataAttributes: -> 
      @$el.attr 'data-role_name', @model.id
      @$el.attr 'data-user_id', @user_id

    updatePermission: (event) ->
      alert "#{event}"

