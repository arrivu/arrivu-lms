//This file is copied from instructure_image plugin for tinymce

define([
  'compiled/editor/stocktiny',
  'i18n!editor',
  'jquery',
  'str/htmlEscape',
  'jqueryui/dialog'
], function(tinymce, I18n, $, htmlEscape) {

  tinymce.create('tinymce.plugins.ArrivuWistiaPlugin', {
    init : function(ed, url) {
      // Register commands
      ed.addCommand('mceArrivuWistia', function() {
        var selectedNode = ed.selection.getNode();

        // Internal wistia object like as iframe placeholder
        if (ed.dom.getAttrib(selectedNode, 'class', '').indexOf('mceItem') != -1) return;

        require(['compiled/views/tinymce/WistiaVideoView'], function(WistiaVideoView){
          new WistiaView(ed, selectedNode);
        });
      });

      // Register buttons
      ed.addButton('arrivu_wistia', {
        title : htmlEscape(I18n.t('embed_video', 'Embed Wistia Video')),
        cmd : 'mceArrivuWistia',
        image : url + '/img/button.gif'
      });

      // highlight our button when an image is selected
      ed.onNodeChange.add(function(ed, cm, e) {
        if(e.nodeName == 'IMG' && e.className != 'equation_image') {
          cm.setActive('wistia_video', true);
        } else {
          cm.setActive('wistia_video', false);
        }
      });
    },

    getInfo : function() {
      return {
        longname : 'ArrivuWistiaPlugin',
        author : 'Arrivu',
        authorurl : 'http://arrivuapps.com',
        infourl : 'http://arrivuapps.com',
        version : '1'
      };
    }
  });

  // Register plugin
  tinymce.PluginManager.add('arrivu_wistia', tinymce.plugins.ArrivuWistiaPlugin);
});