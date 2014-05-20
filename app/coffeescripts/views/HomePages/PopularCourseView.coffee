define [
  'jquery'
  'jst/HomePages/PopularCourseView'
  'i18n!home_pages'
  'jqueryui/jquery.jcontent.0.8',
  'jqueryui/jquery.easing.1.3'
], ($, template, I18n) ->

  class PopularCourseView extends Backbone.View

    template: template
    tagName: 'li'
    className: 'popular_course_item'

    afterRender: ->
      @$el.attr('id', 'popular_course_' + @model.get('id'))
      @$el.css('display', 'inline-block')
      @$el.css('vertical-align', 'top')
      this
