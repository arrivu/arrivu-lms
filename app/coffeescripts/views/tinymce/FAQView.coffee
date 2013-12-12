define [
  'i18n!editor'
  'jquery'
  'underscore'
  'str/htmlEscape'
  'compiled/fn/preventDefault'
  'compiled/views/DialogBaseView'
  'jst/tinymce/FAQView'
  'jqueryui/accordion'
  'jqueryui/tabs'
  'jqueryui/button'

], (I18n, $, _, h, preventDefault, DialogBaseView, template) ->

  class FAQView extends DialogBaseView

    template: template

    dialogOptions:
      width: 625
      title: 'Insert FAQ'

    initialize: (@editor, selectedNode) ->
      @$editor = $("##{@editor.id}")
      @prevSelection = @editor.selection.getBookmark()
      @$selectedNode = $(selectedNode)
      super
      @render()
      @show()
    $(".accordion").accordion header: "h3"

    update: (event) =>
       @editor.selection.moveToBookmark(@prevSelection)
       if $(tinymce.activeEditor.getBody()).find('.accordion').length == 0
         @$editor.editorBox 'insert_code', @generateAccordionHtml()
       else
#        @$editor.editorBox(this.$(".accordion")).append(@AccordionHtmlWithoutMainDiv())
#         @$editor.this.$(".accordion") 'insert_code', @AccordionHtmlWithoutMainDiv
         @AccordionHtmlWithoutMainDiv()
       @editor.focus()
       @close()

    generateAccordionHtml:  =>
        htmlview  = '<div class="accordion">'
        htmlview += '<h3>' + @editor.dom.createHTML("a",{href: '#'},this.$('input[name=question]').val()) + '</h3>'
        htmlview += '<div>' + '<p>' + this.$('textarea[name=answer]').val() + '</p>' + '</div>'
        htmlview += '</div>'

    AccordionHtmlWithoutMainDiv:  =>
#        htmlview  = '<h3>' + @editor.dom.createHTML("a",{href: '#'},this.$('input[name=question]').val()) + '</h3>'
#        htmlview += '<div>' + '<p>' + this.$('textarea[name=answer]').val() + '</p>' + '</div>'
         $(tinymce.activeEditor.getBody()).find('.accordion').append("<h3>" + @editor.dom.createHTML("a",{href: '#'},this.$('input[name=question]').val()) + "</h3>" + '<div>' + '<p>' + this.$('textarea[name=answer]').val() + '</p>' + '</div>')






