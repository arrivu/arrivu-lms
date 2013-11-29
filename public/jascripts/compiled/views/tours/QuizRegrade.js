// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['compiled/views/TourView', 'jst/tours/QuizRegrade', 'vendor/usher/usher'], function(TourView, template, Usher) {
    var QuizRegrade;
    return QuizRegrade = (function(_super) {

      __extends(QuizRegrade, _super);

      function QuizRegrade() {
        return QuizRegrade.__super__.constructor.apply(this, arguments);
      }

      QuizRegrade.prototype.template = template;

      QuizRegrade.prototype.attach = function() {
        var _this = this;
        return $(document).one('click', '.select_answer_link', function() {
          return setTimeout(function() {
            return _this.tour.start();
          }, 500);
        });
      };

      return QuizRegrade;

    })(TourView);
  });

}).call(this);
