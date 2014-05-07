define [
  'jquery'
  'jst/HomePages/LearnersReview'
  'i18n!home_pages'
], ($, template, I18n) ->

  class LearnersReviewView extends Backbone.View

    template: template
    tagName: 'li'
    className: 'learners_review_item'

    afterRender: ->
      @$el.attr('id', 'learners_review_' + @model.get('id'))
      this