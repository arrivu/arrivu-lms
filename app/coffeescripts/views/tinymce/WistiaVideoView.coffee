define [
  'i18n!editor'
  'jquery'
  'underscore'
  'str/htmlEscape'
  'compiled/fn/preventDefault'
  'compiled/views/DialogBaseView'
  'jst/tinymce/WistiaVideoView'
  'compiled/views/tinymce/WistiaVideoComboView'
  'jst/FindWistiaVideoResult'

], (I18n, $, _, h, preventDefault, DialogBaseView, template,WistiaVideoComboView,resultTemplate) ->

  class WistiaVideoView extends DialogBaseView

    template: template

    events:
      'change #combo_field': 'onComboSelect'
      'dblclick .findWistiaMediaView' : 'onThumbLinkDblclick'
      'click .ui-icon-closethick' : 'closeDialog'
      'click .thumbnail, .treeFile' : 'onFileLinkClick'
    closeDialog: (event) ->
      event.preventDefault()
      $('#combo_field').remove()
      @dialog.dialog('close')


    dialogOptions:
      width: 625
      title: I18n.t 'titles.insert_edit_image', 'Insert Video '
      id: "wistia-dialog"

    initialize: (@editor, selectedNode) ->
      @$editor = $("##{@editor.id}")
      @prevSelection = @editor.selection.getBookmark()
      @$selectedNode = $(selectedNode)
      super
      @render()
      wistiaVideoURL = "#{location.origin}/list_collections"
      @show().disableWhileLoading @request = $.getJSON wistiaVideoURL, (data) =>
        @projects = data.collections
        _.map @projects, (project) ->
          wistiaVideoComboView = new WistiaVideoComboView
            option_name: project.name
            option_value: project.id
          @$('#combo_field')
            .append wistiaVideoComboView.render().$el


    onComboSelect: (event, ui) ->
      wistiaMediaURL = "#{location.origin}/get_collection/#{event.target.value}"
      @$('.findWistiaMediaView').show().disableWhileLoading @request = $.getJSON wistiaMediaURL, (data) =>
        @renderResults(data.collections.medias)

    renderResults: (medias) ->
      html = _.map medias, (media) ->
        resultTemplate
          thumb:    "#{media.thumbnail.url}"
          title:    media.name
          hashed_id:    media.hashed_id

      @$('.findWistiaMediaView').showIf(!!medias.length).html html.join('')


    onThumbLinkDblclick: (event) =>
      # click event is handled on the first click
      @update(event)
      @flag = true

    update: (event) =>
      if @hashed_id
        @editor.selection.moveToBookmark(@prevSelection)
        @$editor.editorBox 'insert_code', @generateImageHtml(event)
      else
        if @flag is true
          @editor.selection.moveToBookmark(@prevSelection)
          @$editor.editorBox 'insert_code', @generateImageHtml(event)
        else
          alert('video not selected')
      @editor.focus()
      @close()

    generateImageHtml: (event) =>
      if @hashed_id
        video_id = @hashed_id
        img_tag = @editor.dom.createHTML("iframe",{src: "https://fast.wistia.net/embed/medias/#{video_id}?playerColor=ff0000&amp;fullscreenButton=true"},{width: 600} ,{height: 450})
      else
        hashed_id = event.target.id
        img_tag = @editor.dom.createHTML("iframe",{src: "https://fast.wistia.net/embed/medias/#{hashed_id}?playerColor=ff0000&amp;fullscreenButton=true"},{width: 600} ,{height: 450})

    cancel: (e) =>
      e.preventDefault()
      @close()

    onFileLinkClick: (event) ->
      event.preventDefault()
      @$('.active').removeClass('active').parent().removeAttr('aria-selected')
      $a = $(event.currentTarget).addClass('active')
      $a.parent().attr('aria-selected', true)
      @hashed_id = $a.attr('video_id')

