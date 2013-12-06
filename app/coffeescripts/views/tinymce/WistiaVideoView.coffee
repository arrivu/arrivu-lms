define [
  'i18n!editor'
  'jquery'
  'underscore'
  'str/htmlEscape'
  'compiled/fn/preventDefault'
  'compiled/views/DialogBaseView'
  'jst/tinymce/WistiaVideoView'
  'compiled/views/tinymce/WistiaVideoComboView'

], (I18n, $, _, h, preventDefault, DialogBaseView, template,WistiaVideoComboView) ->

  class WistiaVideoView extends DialogBaseView

    template: template

    events:
      'change #combo_field': 'onComboSelect'
      'dblclick .flickrImageResult, .treeFile' : 'onFileLinkDblclick'

    dialogOptions:
      width: 625
      title: I18n.t 'titles.insert_edit_image', 'Insert Video '

    initialize: (@editor, selectedNode) ->
      @$editor = $("##{@editor.id}")
      @prevSelection = @editor.selection.getBookmark()
      @$selectedNode = $(selectedNode)
      super
      @render()
      wistiaVideoURL = "http://localhost:3000/list_collections"
      @show().disableWhileLoading @request = $.getJSON wistiaVideoURL, (data) =>
        @projects = data.collections
        _.map @projects, (project) ->
          wistiaVideoComboView = new WistiaVideoComboView
            option_name: project.name
            option_value: project.id
          @$('#combo_field')
            .append wistiaVideoComboView.render().el


    onComboSelect: (event, ui) ->
      alert(event.target.value)
#      require ['compiled/views/FindFlickrImageView'], (FindFlickrImageView) =>
#        new FindFlickrImageView().render().$el.appendTo(ui.panel)
#        done()

    onFileLinkDblclick: (event) =>
      # click event is handled on the first click
      @update()


    update: =>
      @editor.selection.moveToBookmark(@prevSelection)
      @$editor.editorBox 'insert_code', @generateImageHtml()
      @editor.focus()
      @close()
