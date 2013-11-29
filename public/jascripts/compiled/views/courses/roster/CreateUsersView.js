// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['compiled/models/CreateUserList', 'underscore', 'i18n!create_users_view', 'compiled/views/DialogFormView', 'jst/courses/roster/createUsers', 'jst/EmptyDialogFormWrapper', 'vendor/jquery.placeholder'], function(CreateUserList, _, I18n, DialogFormView, template, wrapper) {
    var CreateUsersView;
    return CreateUsersView = (function(_super) {

      __extends(CreateUsersView, _super);

      function CreateUsersView() {
        this.maybeShowPrivileges = __bind(this.maybeShowPrivileges, this);
        return CreateUsersView.__super__.constructor.apply(this, arguments);
      }

      CreateUsersView.optionProperty('rolesCollection');

      CreateUsersView.optionProperty('courseModel');

      CreateUsersView.prototype.defaults = {
        width: 700,
        height: 500
      };

      CreateUsersView.prototype.els = {
        '#privileges': '$privileges',
        '#user_list_textarea': '$textarea'
      };

      CreateUsersView.prototype.events = _.extend({}, CreateUsersView.prototype.events, {
        'click .createUsersStartOver': 'startOver',
        'click .createUsersStartOverFrd': 'startOverFrd',
        'change #enrollment_type': 'changeEnrollment',
        'click #enrollment_type': 'changeEnrollment',
        'click .dialog_closer': 'close'
      });

      CreateUsersView.prototype.template = template;

      CreateUsersView.prototype.wrapperTemplate = wrapper;

      CreateUsersView.prototype.initialize = function() {
        var _ref;
        if ((_ref = this.model) == null) {
          this.model = new CreateUserList;
        }
        return CreateUsersView.__super__.initialize.apply(this, arguments);
      };

      CreateUsersView.prototype.attach = function() {
        this.model.on('change:step', this.render, this);
        return this.model.on('change:enrollment_type', this.maybeShowPrivileges);
      };

      CreateUsersView.prototype.maybeShowPrivileges = function() {
        var role, _ref;
        role = _.findWhere(this.model.get('roles'), {
          name: this.model.get('enrollment_type')
        });
        if (role && ((_ref = role.base_role_name) === 'TeacherEnrollment' || _ref === 'TaEnrollment')) {
          return this.$privileges.show();
        } else {
          return this.$privileges.hide();
        }
      };

      CreateUsersView.prototype.changeEnrollment = function(event) {
        return this.model.set('enrollment_type', event.target.value);
      };

      CreateUsersView.prototype.openAgain = function() {
        this.startOverFrd();
        return CreateUsersView.__super__.openAgain.apply(this, arguments);
      };

      CreateUsersView.prototype.hasUsers = function() {
        var _ref;
        return (_ref = this.model.get('users')) != null ? _ref.length : void 0;
      };

      CreateUsersView.prototype.onSaveSuccess = function() {
        var newUsers, role, _ref;
        this.model.incrementStep();
        if (this.model.get('step') === 3) {
          role = this.rolesCollection.where({
            name: this.model.get('enrollment_type')
          })[0];
          if (role != null) {
            role.increment('count', this.model.get('users').length);
          }
          newUsers = this.model.get('users').length;
          return (_ref = this.courseModel) != null ? _ref.increment('pendingInvitationsCount', newUsers) : void 0;
        }
      };

      CreateUsersView.prototype.validateBeforeSave = function(data) {
        if (this.model.get('step') === 1 && !data.user_list) {
          return {
            user_list: [
              {
                type: 'required',
                message: I18n.t('required', 'Please enter some email addresses')
              }
            ]
          };
        } else {
          return {};
        }
      };

      CreateUsersView.prototype.startOver = function() {
        return this.model.startOver();
      };

      CreateUsersView.prototype.startOverFrd = function() {
        var _ref;
        this.model.startOver();
        if (this.model.get('limit_privileges_to_course_section') === "0") {
          this.$el.find('#limit_privileges_to_course_section').prop('checked', false);
        }
        return (_ref = this.$textarea) != null ? _ref.val('') : void 0;
      };

      CreateUsersView.prototype.afterRender = function() {
        this.$('[placeholder]').placeholder();
        return this.maybeShowPrivileges();
      };

      return CreateUsersView;

    })(DialogFormView);
  });

}).call(this);
