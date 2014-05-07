define [
  'jquery'
  'jst/HomePages/TotalKnowledgePartnerView'
  'i18n!home_pages'
], ($, template, I18n) ->

  class TotalKnowledgePartnerView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'knowledge_partners_item'

    afterRender: ->
      @$el.attr('id', 'knowledge_partners_' + @model.get('id'))
      this