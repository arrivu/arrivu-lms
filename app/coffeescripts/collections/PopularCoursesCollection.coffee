define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/PopularCourse'
], (PaginatedCollection, PopularCourse) ->

  class PopularCoursesCollection extends PaginatedCollection
    model: PopularCourse