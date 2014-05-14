define [
  'jquery'
  'i18n!home_pages'
  'jst/HomePages/IndexView'
  'compiled/views/HomePages/AddAccountSlider'
  'compiled/views/HomePages/AddKnowledgePartner'
  'compiled/models/AccountSlider'
  'compiled/models/PopularCourse'
  'compiled/models/KnowledgePartner'
  'compiled/collections/AccountSlidersCollection'
  'compiled/views/HomePages/AccountSliderCollectionView'
  'compiled/views/HomePages/AddPopularCourse'
  'jqueryui/jquery.jcontent.0.8'
  'jqueryui/jquery.easing.1.3'
], ($, I18n, template, AddAccontSliders,AddknowledgePartner, AccountSlider, PopularCourse,KnowledgePartner
    AccountSliderCollection,AccountSliderCollectionView,AddPopularCourse) ->

  class IndexView extends Backbone.View

    @child 'accountSliderCollectionView',  '[data-view=sliders]'
    @child 'accountStatisticsView', '[data-view=accountStatistics]'
    @child 'popularCourseCollectionView', '[data-view=popularCourses]'
    @child 'knowledgePartnerCollectionView', '[data-view=knowledgePartners]'

    template: template

    events:
      'click #add_account_sliders' : 'addAccountSlider'
      'click #add_popular_courses' : 'addPopularCourse'
      'click #add_knowledge_partners': 'addKnowledgePartner'
      'click .details':'movetocourselibrary'

    afterRender:->
      $("div.author_slider_index_view").jContent
        orientation: "horizontal"
        easing: "easeOutCirc"
        duration: 500
        width:229
        height:46

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

    addKnowledgePartner: ->
      newaddKnowledgePartner = new KnowledgePartner
      @addknowledgePartnerView = new AddknowledgePartner
        model: newaddKnowledgePartner
      @addknowledgePartnerView.render()

    movetocourselibrary:(event)->
      popular_item = this.$(event.currentTarget).attr('id')
      location.href = "#{location.protocol}//#{location.host}/libraries/"+popular_item
