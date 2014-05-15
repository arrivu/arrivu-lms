require [
  'compiled/views/HomePages/IndexView'
  'compiled/collections/AccountSlidersCollection'
  'compiled/collections/PopularCoursesCollection'
  'compiled/views/HomePages/AccountSliderCollectionView'
  'compiled/views/HomePages/AccountStatisticsView'
  'compiled/views/HomePages/PopularCourseCollectionView'
  'compiled/collections/KnowledgePartnersCollection'
  'compiled/views/HomePages/KnowledgePartnerCollectionView'
  'jquery.disableWhileLoading'
  'slider'
], (IndexView,AccountSliderCollection,PopularCoursesCollection,AccountSliderCollectionView,AccountStatisticsView,
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

      if $("#popular_course_div").find("#popular_course_on_index_page").length == 0
        $("#popular_course_div").css('background-image','url()')
        $("#popular_course_banner").hide()
        $("#more_courses").hide()
        $("#popular_course_paginating").hide()
      if $("#popular_course_div").find("#popular_course_on_index_page").length > 0
        $("#popular_course_div").css('background-image','url("/images/pattern-bg.png")')
        $("#popular_course_banner").show()
        $("#more_courses").show()
        $("#popular_course_paginating").show()
  )
  knowledgePartnerCollection.fetch(
    success: ->
      if $("#knowledge_partners_div").find("#knowledge_partner_on_index_page").length == 0
        $("#knowledge_partner_banner").hide();
        $("#more_partners").hide();
  )


