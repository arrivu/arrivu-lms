define [
  'i18n!editor'
  'jquery'
  'underscore'
  'str/htmlEscape'
  'compiled/fn/preventDefault'
  'compiled/views/DialogBaseView'
  'jst/tinymce/FAQView'

], (I18n, $, _, h, preventDefault, DialogBaseView, template) ->

  class WistiaVideoView extends DialogBaseView

    template: template

    events:
      'change #combo_field': 'onComboSelect'
      'dblclick .findWistiaMediaView' : 'onThumbLinkDblclick'

    dialogOptions:
      width: 625
      title: I18n.t 'titles.insert_edit_image', 'Insert FAQ '

    initialize: (@editor, selectedNode) ->
      @$editor = $("##{@editor.id}")
      @prevSelection = @editor.selection.getBookmark()
      @$selectedNode = $(selectedNode)
      super
      @render()
      @show()
    onThumbLinkDblclick: (event) =>
      # click event is handled on the first click
      @update(event)



    update: (event) =>
      @editor.selection.moveToBookmark(@prevSelection)
      @$editor.editorBox 'insert_code', @generateImageHtml(event)
      @editor.focus()
      @close()


    generateImageHtml: (event) =>
      hashed_id = event.target.id
      img_tag = @editor.dom.createHTML("iframe",{src: "https://fast.wistia.net/embed/medias/#{hashed_id}?playerColor=ff0000&amp;fullscreenButton=true"},{width: 600} ,{height: 450})

