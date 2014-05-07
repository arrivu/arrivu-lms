define [
  'jquery'
  'jst/CoursePricing/CoursePricingList'
], ($, template) ->

  class CoursePricingListView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'course_pricings_item'

    afterRender: ->
      @$el.attr('id', 'course_pricings_' + @model.get('id'))
      this

