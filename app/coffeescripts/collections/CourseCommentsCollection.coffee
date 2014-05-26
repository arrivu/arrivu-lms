define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/CourseComment'
], (PaginatedCollection, CourseComment) ->

  class CourseCommentsCollection extends PaginatedCollection
    model: CourseComment