define [
  'Backbone'
  'underscore'
  'compiled/models/Role'
], (Backbone, _, Role) ->
  class CourseModuleCollection extends Backbone.Collection
    model: Role
