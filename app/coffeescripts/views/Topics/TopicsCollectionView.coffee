define [
  'jquery'
  'str/htmlEscape'
  'jst/topics/TopicsCollectionView'
  'compiled/views/Topics/TopicListView'
  'compiled/views/PaginatedCollectionView'
  'i18n!topics'
], ($, htmlEscape, template, TopicListView, PaginatedCollectionView, I18n) ->

  class TopicsCollectionView extends PaginatedCollectionView

    template: template
    itemView: TopicListView
