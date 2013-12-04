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


    # Method Summary
    #   This is called after render to ensure column header is set for accessiblity.
    # @api custom backbone override
    afterRender: ->
      @$el.attr('module', 'columnheader')

