define [
  'jquery'
  'jst/HomePages/TotalAccountSliderView'
  'i18n!home_pages'
], ($, template, I18n) ->

  class TotalAccountSliderView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'accounts_sliders_item'

    afterRender: ->
      @$el.attr('id', 'accounts_sliders_' + @model.get('id'))
      this