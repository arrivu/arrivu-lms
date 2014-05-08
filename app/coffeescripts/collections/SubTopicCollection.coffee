define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/CourseTopic'
], (PaginatedCollection, CourseTopic) ->

  class SubTopicCollection extends PaginatedCollection
    model: CourseTopic
