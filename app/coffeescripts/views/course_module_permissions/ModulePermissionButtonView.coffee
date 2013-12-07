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
      @key_id = @options.key_id if @options.key_id
      @value_id = @options.value_id if @options.value_id

    toJSON: ->
      json = super

      json['key_id'] = @key_id
      json['value_id'] = @value_id
      json['user_id'] = @user_id
      json['module_id'] = @model.id
      json['selected_module_users'] = @selected_module_users

      json



    updatePermission: (event) ->
#      alert $(event.currentTarget).attr("data-module_id")
      icon = $(event.currentTarget).children().first().prop("class")
#      alert icon
      if icon is "icon-x"
       $(event.currentTarget).find("i").removeClass("icon-x").addClass "icon-check"
      else
       $(event.currentTarget).find("i").removeClass("icon-check").addClass "icon-x"
