require [
  'jquery'
  'compiled/views/HomePages/IndexView'
  'compiled/collections/AccountSlidersCollection'
  'compiled/collections/PopularCoursesCollection'
  'compiled/views/HomePages/AccountSliderCollectionView'
  'compiled/views/HomePages/AccountStatisticsView'
  'compiled/views/HomePages/PopularCourseCollectionView'
  'compiled/collections/KnowledgePartnersCollection'
  'compiled/views/HomePages/KnowledgePartnerCollectionView'
  'jqueryui/jquery.jcontent.0.8'
  'jqueryui/jquery.easing.1.3'
  'jquery.disableWhileLoading'
], ($,IndexView,AccountSliderCollection,PopularCoursesCollection,AccountSliderCollectionView,AccountStatisticsView,
    PopularCourseCollectionView,KnowledgePartnersCollection,KnowledgePartnerCollectionView) ->

  # Collections

  accountSliderCollection = new AccountSliderCollection
  popularCourseCollection = new PopularCoursesCollection
  knowledgePartnerCollection = new KnowledgePartnersCollection

  # Views
  accountSliderCollectionView = new AccountSliderCollectionView
    collection: accountSliderCollection
  accountStatisticsView = new AccountStatisticsView
  popularCourseCollectionView = new PopularCourseCollectionView
    collection: popularCourseCollection
  knowledgePartnerCollectionView = new KnowledgePartnerCollectionView
    collection: knowledgePartnerCollection

  @app = new IndexView
    accountSliderCollectionView: accountSliderCollectionView
    accountStatisticsView: accountStatisticsView
    popularCourseCollectionView: popularCourseCollectionView
    knowledgePartnerCollectionView: knowledgePartnerCollectionView
    el: '#content'

  @app.render()
  accountSliderCollection.fetch(
    success:->
      $("div#demo1").jContent
        orientation: "horizontal"
        easing: "easeOutCirc"
        duration: 500
        auto: true
        direction: "next" #or 'prev'
        pause: 1500
        pause_on_hover: true
  )
  popularCourseCollection.fetch(
    success: ->
      $("div.author_slider_index_view").jContent
        orientation: "horizontal"
        easing: "easeOutCirc"
        duration: 500
        width:229
        height:46
  )
  popularCourseCollection.fetch()
  knowledgePartnerCollection.fetch()


