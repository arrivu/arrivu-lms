require [
  'compiled/views/CourseLibrary/IndexView'
  'compiled/collections/PopularCoursesCollection'
  'compiled/views/HomePages/AccountCourseCollectionView'
  'compiled/collections/TopicCollection'
  'compiled/views/CourseLibrary/TopicsView'
  'slider'
], (IndexView,PopularCoursesCollection,AccountCourseCollectionView,TopicCollection,TopicsView) ->

  # Collections
  popularCourseCollection = new PopularCoursesCollection

  topicCollection = new TopicCollection

  # Views
  accountCourseCollectionView = new AccountCourseCollectionView
    collection: popularCourseCollection

  topicsView = new TopicsView
    collection: topicCollection

  @app = new IndexView
    topicsView: topicsView
    accountCourseCollectionView: accountCourseCollectionView
    el: '#course_library'
  @app.render()

  topicCollection.fetch(
    success:->
      @topicsView = new TopicsView
        collection: topicCollection
        el: '#course_topics'
      @topicsView.render()
  )

  popularCourseCollection.fetch(
    success:->
      $(".popular_course_item").find("div.author_slider_index_pop_up_view").jContent
        orientation: "horizontal"
        easing: "easeOutCirc"
        duration: 500
        width:229
        height:46
  )



