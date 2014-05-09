define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/CourseTopic'
], (PaginatedCollection, CourseTopic) ->

  class TopicCollection extends PaginatedCollection
    model: CourseTopic
