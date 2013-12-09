//This file is copied from instructure_image plugin for tinymce

define([
    'compiled/editor/stocktiny',
    'i18n!editor',
    'jquery',
    'str/htmlEscape',
    'jqueryui/dialog'
], function(tinymce, I18n, $, htmlEscape) {

    tinymce.create('tinymce.plugins.faq', {
        init : function(ed, url) {
            // Register commands
            ed.addCommand('mcefaq', function() {
                var selectedNode = ed.selection.getNode();

                // Internal wistia object like as iframe placeholder
                if (ed.dom.getAttrib(selectedNode, 'class', '').indexOf('mceItem') != -1) return;

                require(['compiled/views/tinymce/WistiaVideoView'], function(WistiaVideo){
                    new WistiaVideo(ed, selectedNode);
                });
            });

            // Register buttons
            ed.addButton('faq', {
                title : htmlEscape(I18n.t('faq', 'Embed Accordian FAQ')),
                cmd : 'mceWistia',
                image : url + '/img/button.jpg'
            });

            // highlight our button when an image is selected
            ed.onNodeChange.add(function(ed, cm, e) {
                if(e.nodeName == 'IMG' && e.className != 'equation_image') {
                    cm.setActive('faq', true);
                } else {
                    cm.setActive('faq', false);
                }
            });
        },

        getInfo : function() {
            return {
                longname : 'faq',
                author : 'Arrivu',
                authorurl : 'http://arrivuapps.com',
                infourl : 'http://arrivuapps.com',
                version : '1'
            };
        }
    });

    // Register plugin
    tinymce.PluginManager.add('faq', tinymce.plugins.faq);
});