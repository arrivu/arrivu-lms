(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['i18n!editor', 'jquery', 'underscore', 'str/htmlEscape', 'compiled/fn/preventDefault', 'compiled/views/DialogBaseView', 'jst/tinymce/WistiaVideoView'], function(I18n, $, _, h, preventDefault, DialogBaseView, template) {
    var WistiaVideoView, _ref;

    return WistiaVideoView = (function(_super) {
      __extends(WistiaVideoView, _super);

      function WistiaVideoView() {
        this.update = __bind(this.update, this);
        this.onFileLinkDblclick = __bind(this.onFileLinkDblclick, this);
        this.constrainProportions = __bind(this.constrainProportions, this);        _ref = WistiaVideoView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      WistiaVideoView.prototype.template = template;

      WistiaVideoView.prototype.events = {
        'change [name="image[width]"]': 'constrainProportions',
        'change [name="image[height]"]': 'constrainProportions',
        'click .flickrImageResult, .treeFile': 'onFileLinkClick',
        'change [name="image[src]"]': 'onImageUrlChange',
        'tabsshow .imageSourceTabs': 'onTabsshow',
        'dblclick .flickrImageResult, .treeFile': 'onFileLinkDblclick'
      };

      WistiaVideoView.prototype.dialogOptions = {
        width: 625,
        title: I18n.t('titles.insert_edit_image', 'Insert / Edit Image')
      };

      WistiaVideoView.prototype.initialize = function(editor, selectedNode) {
        this.editor = editor;
        this.$editor = $("#" + this.editor.id);
        this.prevSelection = this.editor.selection.getBookmark();
        this.$selectedNode = $(selectedNode);
        WistiaVideoView.__super__.initialize.apply(this, arguments);
        this.render();
        this.show();
        if (this.$selectedNode.prop('nodeName') === 'IMG') {
          return this.setSelectedImage({
            src: this.$selectedNode.attr('src'),
            alt: this.$selectedNode.attr('alt'),
            width: this.$selectedNode.width(),
            height: this.$selectedNode.height()
          });
        }
      };

      WistiaVideoView.prototype.afterRender = function() {
        return this.$('.imageSourceTabs').tabs();
      };

      WistiaVideoView.prototype.onTabsshow = function(event, ui) {
        var loadTab,
          _this = this;

        loadTab = function(fn) {
          var loadingDfd;

          if (_this["" + ui.panel.id + "IsLoaded"]) {
            return;
          }
          _this["" + ui.panel.id + "IsLoaded"] = true;
          loadingDfd = $.Deferred();
          $(ui.panel).disableWhileLoading(loadingDfd);
          return fn(loadingDfd.resolve);
        };
        switch (ui.panel.id) {
          case 'tabUploaded':
            return loadTab(function(done) {
              return require(['compiled/views/FileBrowserView'], function(FileBrowserView) {
                new FileBrowserView({
                  contentTypes: 'image'
                }).render().$el.appendTo(ui.panel);
                return done();
              });
            });
          case 'tabFlickr':
            return loadTab(function(done) {
              return require(['compiled/views/FindFlickrImageView'], function(FindFlickrImageView) {
                new FindFlickrImageView().render().$el.appendTo(ui.panel);
                return done();
              });
            });
        }
      };

      WistiaVideoView.prototype.setAspectRatio = function() {
        var height, width;

        width = Number(this.$("[name='image[width]']").val());
        height = Number(this.$("[name='image[height]']").val());
        if (width && height) {
          return this.aspectRatio = width / height;
        } else {
          return delete this.aspectRatio;
        }
      };

      WistiaVideoView.prototype.constrainProportions = function(event) {
        var val;

        val = Number($(event.target).val());
        if (this.aspectRatio && (val || (val === 0))) {
          if ($(event.target).is('[name="image[height]"]')) {
            return this.$('[name="image[width]"]').val(Math.round(val * this.aspectRatio));
          } else {
            return this.$('[name="image[height]"]').val(Math.round(val / this.aspectRatio));
          }
        }
      };

      WistiaVideoView.prototype.setSelectedImage = function(attributes) {
        var dfd, key, onError, onLoad, value,
          _this = this;

        if (attributes == null) {
          attributes = {};
        }
        for (key in attributes) {
          value = attributes[key];
          this.$("[name='image[" + key + "]']").val(value);
        }
        dfd = $.Deferred();
        onLoad = function(_arg) {
          var img, isValidImage, newAttributes;

          img = _arg.target;
          newAttributes = _.defaults(attributes, {
            width: img.width,
            height: img.height
          });
          for (key in newAttributes) {
            value = newAttributes[key];
            _this.$("[name='image[" + key + "]']").val(value);
          }
          isValidImage = newAttributes.width && newAttributes.height;
          _this.setAspectRatio();
          return dfd.resolve(newAttributes);
        };
        onError = function(_arg) {
          var img, newAttributes, _results;

          img = _arg.target;
          newAttributes = {
            width: '',
            height: ''
          };
          _results = [];
          for (key in newAttributes) {
            value = newAttributes[key];
            _results.push(_this.$("[name='image[" + key + "]']").val(value));
          }
          return _results;
        };
        this.$img = $('<img>', attributes).load(onLoad).error(onError);
        return dfd;
      };

      WistiaVideoView.prototype.getAttributes = function() {
        var key, res, val, _i, _j, _len, _len1, _ref1, _ref2;

        res = {};
        _ref1 = ['width', 'height'];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          key = _ref1[_i];
          val = Number(this.$("[name='image[" + key + "]']").val());
          if (val && val > 0) {
            res[key] = val;
          }
        }
        _ref2 = ['src', 'alt'];
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          key = _ref2[_j];
          val = this.$("[name='image[" + key + "]']").val();
          if (val) {
            res[key] = val;
          }
        }
        return res;
      };

      WistiaVideoView.prototype.onFileLinkClick = function(event) {
        var $a;

        event.preventDefault();
        this.$('.active').removeClass('active').parent().removeAttr('aria-selected');
        $a = $(event.currentTarget).addClass('active');
        $a.parent().attr('aria-selected', true);
        this.flickr_link = $a.attr('data-linkto');
        return this.setSelectedImage({
          src: $a.attr('data-fullsize'),
          alt: $a.attr('title')
        });
      };

      WistiaVideoView.prototype.onFileLinkDblclick = function(event) {
        return this.update();
      };

      WistiaVideoView.prototype.onImageUrlChange = function(event) {
        this.flickr_link = null;
        return this.setSelectedImage({
          src: $(event.currentTarget).val()
        });
      };

      WistiaVideoView.prototype.generateImageHtml = function() {
        var img_tag;

        img_tag = this.editor.dom.createHTML("img", this.getAttributes());
        if (this.flickr_link) {
          img_tag = "<a href='" + this.flickr_link + "'>" + img_tag + "</a>";
        }
        return img_tag;
      };

      WistiaVideoView.prototype.update = function() {
        this.editor.selection.moveToBookmark(this.prevSelection);
        this.$editor.editorBox('insert_code', this.generateImageHtml());
        this.editor.focus();
        return this.close();
      };

      return WistiaVideoView;

    })(DialogBaseView);
  });

}).call(this);
