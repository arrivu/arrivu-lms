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

    toJSON: ->
      json = super

      json['user_id'] = @user_id
      json['module_id'] = @model.id


      json



    updatePermission: (event) ->
#      alert $(event.currentTarget).attr("data-module_id")
      icon = $(event.currentTarget).children().first().prop("class")
#      alert icon
      if icon is "icon-x"
       $(event.currentTarget).find("i").removeClass("icon-x").addClass "icon-check"
      else
       $(event.currentTarget).find("i").removeClass("icon-check").addClass "icon-x"
