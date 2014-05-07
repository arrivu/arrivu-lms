define [
  'jquery'
  'jst/HomePages/AccountSliderView'
  'i18n!home_pages'
], ($, template, I18n) ->

  class AccountSliderView extends Backbone.View

    template: template
    className: 'account_slider_item'

    afterRender: ->
      @$el.attr('id', 'account_slider_' + @model.get('id'))
      this