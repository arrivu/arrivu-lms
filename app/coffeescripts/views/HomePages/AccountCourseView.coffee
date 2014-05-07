define [
  'jquery'
  'jst/HomePages/AccountCourseView'
  'i18n!home_pages'
], ($, template, I18n) ->

  class AccountCourseView extends Backbone.View

    template: template
    tagName: 'li'
    className: 'popular_course_item'

    afterRender: ->
      @$el.attr('id', 'popular_course_' + @model.get('id'))
      this