// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'Backbone', 'compiled/backbone-ext/DefaultUrlMixin', 'compiled/str/splitAssetString'], function(_, Backbone, DefaultUrlMixin, splitAssetString) {
    var WikiPageRevision, pageRevisionOptions;
    pageRevisionOptions = ['contextAssetString', 'pageUrl', 'latest', 'summary'];
    return WikiPageRevision = (function(_super) {

      __extends(WikiPageRevision, _super);

      function WikiPageRevision() {
        return WikiPageRevision.__super__.constructor.apply(this, arguments);
      }

      WikiPageRevision.mixin(DefaultUrlMixin);

      WikiPageRevision.prototype.initialize = function(attributes, options) {
        WikiPageRevision.__super__.initialize.apply(this, arguments);
        _.extend(this, _.pick(options || {}, pageRevisionOptions));
        if (attributes != null ? attributes.url : void 0) {
          return this.set({
            id: attributes.url
          });
        }
      };

      WikiPageRevision.prototype.urlRoot = function() {
        return "/api/v1/" + (this._contextPath()) + "/pages/" + this.pageUrl + "/revisions";
      };

      WikiPageRevision.prototype.url = function() {
        var base;
        base = this.urlRoot();
        if (this.latest) {
          return "" + base + "/latest";
        }
        if (this.get('id')) {
          return "" + base + "/" + (this.get('id'));
        }
        return base;
      };

      WikiPageRevision.prototype.fetch = function(options) {
        var _base, _ref, _ref1;
        if (options == null) {
          options = {};
        }
        if (this.summary) {
          if ((_ref = options.data) == null) {
            options.data = {};
          }
          if ((_ref1 = (_base = options.data).summary) == null) {
            _base.summary = true;
          }
        }
        return WikiPageRevision.__super__.fetch.call(this, options);
      };

      WikiPageRevision.prototype.pollForChanges = function(interval) {
        var poll,
          _this = this;
        if (interval == null) {
          interval = 30000;
        }
        this.polling = true;
        if (!this._poller) {
          poll = function() {
            if (!_this.polling) {
              return;
            }
            return _this.fetch().done(function(data, status, xhr) {
              status = xhr.status.toString();
              if (!(status[0] === '4' || status[0] === '5')) {
                return poll();
              }
            });
          };
          this._poller = poll = _.throttle(poll, interval, {
            leading: false
          });
        }
        return this._poller();
      };

      WikiPageRevision.prototype.stopPolling = function() {
        return this.polling = false;
      };

      WikiPageRevision.prototype.parse = function(response, options) {
        if (response.url) {
          response.id = response.url;
        }
        return response;
      };

      WikiPageRevision.prototype.toJSON = function() {
        return _.omit(WikiPageRevision.__super__.toJSON.apply(this, arguments), 'id');
      };

      return WikiPageRevision;

    })(Backbone.Model);
  });

}).call(this);
