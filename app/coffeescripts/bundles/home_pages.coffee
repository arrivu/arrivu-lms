require [
  'compiled/views/HomePages/IndexView'
  'compiled/collections/AccountSlidersCollection'
  'compiled/collections/PopularCoursesCollection'
  'compiled/views/HomePages/AccountSliderCollectionView'
  'compiled/views/HomePages/AccountStatisticsView'
  'compiled/views/HomePages/PopularCourseCollectionView'
  'compiled/collections/KnowledgePartnersCollection'
  'compiled/views/HomePages/KnowledgePartnerCollectionView'
  'compiled/views/HomePages/LearnersReviewsCollectionView'
  'compiled/collections/LearnerReviewCollection'
  'jquery.disableWhileLoading'
  'slider'
], (IndexView,AccountSliderCollection,PopularCoursesCollection,AccountSliderCollectionView,AccountStatisticsView,
    PopularCourseCollectionView,KnowledgePartnersCollection,KnowledgePartnerCollectionView,LearnerReviewCollectionView
    LearnerReviewCollection) ->

  # Collections

  accountSliderCollection = new AccountSliderCollection
  popularCourseCollection = new PopularCoursesCollection
  knowledgePartnerCollection = new KnowledgePartnersCollection
  learnerReviewCollection = new LearnerReviewCollection

  # Views
  accountSliderCollectionView = new AccountSliderCollectionView
    collection: accountSliderCollection
  accountStatisticsView = new AccountStatisticsView
  popularCourseCollectionView = new PopularCourseCollectionView
    collection: popularCourseCollection
  knowledgePartnerCollectionView = new KnowledgePartnerCollectionView
    collection: knowledgePartnerCollection
  learnerReviewCollectionView = new  LearnerReviewCollectionView
    collection:learnerReviewCollection

  @app = new IndexView
    accountSliderCollectionView: accountSliderCollectionView
    accountStatisticsView: accountStatisticsView
    popularCourseCollectionView: popularCourseCollectionView
    knowledgePartnerCollectionView: knowledgePartnerCollectionView
    learnerReviewCollectionView: learnerReviewCollectionView
    el: '#content'

  @app.render()
  accountSliderCollection.fetch(
    success:->
      $("div#account_sliders").jContent
        orientation: "horizontal"
        easing: "easeOutCirc"
        duration: 5000
        auto: true
        direction: "next" #or 'prev'
        pause: 3500
        pause_on_hover: true
  )
  popularCourseCollection.setParam('per_page', 10)
  popularCourseCollection.setParam('source', "popular")
  popularCourseCollection.fetch()
  knowledgePartnerCollection.fetch()
  learnerReviewCollection.fetch()
