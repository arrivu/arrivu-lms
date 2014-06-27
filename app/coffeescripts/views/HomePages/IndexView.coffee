define [
  'jquery'
  'i18n!home_pages'
  'jst/HomePages/IndexView'
  'compiled/views/HomePages/AddAccountSlider'
  'compiled/views/HomePages/AddKnowledgePartner'
  'compiled/models/AccountSlider'
  'compiled/models/PopularCourse'
  'compiled/models/KnowledgePartner'
  'compiled/models/LearnerReview'
  'compiled/collections/AccountSlidersCollection'
  'compiled/views/HomePages/AccountSliderCollectionView'
  'compiled/views/HomePages/AddPopularCourse'
  'compiled/views/HomePages/LearnersReviewsCollectionView'
], ($, I18n, template, AddAccontSliders,AddknowledgePartner, AccountSlider, PopularCourse,KnowledgePartner
    LearnerReview,AccountSliderCollection,AccountSliderCollectionView,AddPopularCourse,LearnersReviewsCollectionView,
    AddLearnersReview) ->

  class IndexView extends Backbone.View

    @child 'accountSliderCollectionView',  '[data-view=sliders]'
    @child 'accountStatisticsView', '[data-view=accountStatistics]'
    @child 'popularCourseCollectionView', '[data-view=popularCourses]'
    @child 'knowledgePartnerCollectionView', '[data-view=knowledgePartners]'
    @child 'learnerReviewCollectionView','[data-view=learnersReviews]'

    template: template

    events:
      'click #add_account_sliders' : 'addAccountSlider'
      'click #add_popular_courses' : 'addPopularCourse'
      'click #add_knowledge_partners': 'addKnowledgePartner'
      'click .details':'movetocourselibrary'
      'click .index_view_slides' : 'teacher_details'
      'click .tagging' : 'filter_course_by_tags'

    addAccountSlider: ->
      newAccountSliderView = new AccountSlider
      @addAccountSliderView = new AddAccontSliders
        model: newAccountSliderView
      @addAccountSliderView.render()

    addPopularCourse: ->
      newpopularCourse = new PopularCourse
      @addPopularCourseView = new AddPopularCourse
        model: newpopularCourse
      @addPopularCourseView.render()
      $(".spinner").css("top", "250px");

    addKnowledgePartner: ->
      newaddKnowledgePartner = new KnowledgePartner
      @addknowledgePartnerView = new AddknowledgePartner
        model: newaddKnowledgePartner
      @addknowledgePartnerView.render()

    movetocourselibrary:(event)->
      popular_item = this.$(event.currentTarget).attr('id')
      location.href = "#{location.protocol}//#{location.host}/libraries/"+popular_item

#    teacher_details:(event) ->
#      teacher_id = this.$(event.currentTarget).find(".teacher_name").attr('id')
#      location.href = "#{location.protocol}//#{location.host}/users/profiles/"+teacher_id

    filter_course_by_tags:(event)->
      event.stopPropagation()
      tag_id = this.$(event.currentTarget).attr('id')
      location.href = "#{location.protocol}//#{location.host}/accounts/"+ENV.account_id+"/tagged_courses/"+tag_id