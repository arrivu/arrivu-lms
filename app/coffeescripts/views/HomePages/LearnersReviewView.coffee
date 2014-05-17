define [
  'jquery'
  'jst/HomePages/LearnersReview'
  'i18n!home_pages'
], ($, template, I18n) ->

  class LearnersReviewView extends Backbone.View

    template: template
    tagName: 'li'
    className: 'learner_review_item'

    afterRender: ->
      @$el.attr('id', 'learners_review_' + @model.get('id'))
      @$el.css('display','inline-block')
      this