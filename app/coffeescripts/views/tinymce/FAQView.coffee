define [
  'i18n!editor'
  'jquery'
  'underscore'
  'str/htmlEscape'
  'compiled/fn/preventDefault'
  'compiled/views/DialogBaseView'
  'jst/tinymce/FAQView'

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

    update: (event) =>
       @editor.selection.moveToBookmark(@prevSelection)
       if $(tinymce.activeEditor.getBody()).find('.accordion').length == 0
         @$editor.editorBox 'insert_code', @generateAccordionHtml()
       else
         @AccordionHtmlWithoutMainDiv()
       @editor.focus()
       @close()

    generateAccordionHtml:  =>
      if $("#txtQuestion").val() is "" and $("#txtAnswer").val() is ""
        alert('textboxes are emty')
        $('.ui-dialog ui-widget ui-widget-content ui-corner-all ui-draggable ui-dialog-buttons')
        $('.ui-widget-overlay')
      else
        htmlview  = '<div class="accordion">'
        htmlview += '<h3>' + @editor.dom.createHTML("a",{href: '#'},this.$('input[name=question]').val()) + '</h3>'
        htmlview += '<div>' + '<p>' + this.$('textarea[name=answer]').val() + '</p>' + '</div>'
        htmlview += '</div>'

    AccordionHtmlWithoutMainDiv:  =>
      if $("#txtQuestion").val() is "" and $("#txtAnswer").val() is ""
        alert('textboxes are emty')
        $('.ui-dialog ui-widget ui-widget-content ui-corner-all ui-draggable ui-dialog-buttons')
        $('.ui-widget-overlay')
      else
        $(tinymce.activeEditor.getBody()).find('.accordion').append("<h3>" + @editor.dom.createHTML("a",{href: '#'},
          this.$('input[name=question]').val()) + "</h3>" + '<div>' + '<p>' + this.$('textarea[name=answer]').val()
          + '</p>' + '</div>')






