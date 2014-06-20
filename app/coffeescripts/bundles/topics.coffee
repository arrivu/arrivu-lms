#require [
#  'compiled/collections/TopicCollection',
#  'compiled/views/Topics/IndexView'
#  'compiled/views/Topics/TopicsCollectionView'
#], (TopicCollection, IndexView, TopicsCollectionView) ->
#
#   # Collections
#  topicCollection = new TopicCollection
#  topicCollection.setParam('per_page', 20)
#
#   # Views
#  @app = new IndexView
#    el: '#topics'
#    collection: topicCollection
#
#  @app.render()
require [
  'compiled/collections/TopicCollection',
  'compiled/views/Topics/IndexView'
  'compiled/views/Topics/TopicsCollectionView'
], (TopicCollection, IndexView, TopicsCollectionView) ->

  # Collections

  topicCollection = new TopicCollection

  topicsCollectionView = new TopicsCollectionView
    collection: topicCollection

  @app = new IndexView
    topicsCollectionView: topicsCollectionView
    el: '#topics'

  @app.render()
  topicCollection.fetch()