// Generated by CoffeeScript 1.3.3
(function() {

  define(['underscore', 'i18n!registration', 'compiled/fn/preventDefault', 'compiled/registration/registrationErrors', 'jst/registration/teacherDialog', 'jst/registration/studentDialog', 'jst/registration/parentDialog', 'compiled/util/addPrivacyLinkToDialog', 'compiled/jquery/validate', 'jquery.instructure_forms', 'jquery.instructure_date_and_time'], function(_, I18n, preventDefault, registrationErrors, teacherDialog, studentDialog, parentDialog, addPrivacyLinkToDialog) {
    var $nodes, signupDialog, templates;
    $nodes = {};
    templates = {
      teacherDialog: teacherDialog,
      studentDialog: studentDialog,
      parentDialog: parentDialog
    };
    signupDialog = function(id, title) {
      var $form, $node, el, _ref,
        _this = this;
      if (!templates[id]) {
        return;
      }
      $node = (_ref = $nodes[id]) != null ? _ref : $nodes[id] = $('<div />');
      $node.html(templates[id]({
        account: ENV.ACCOUNT.registration_settings,
        terms_required: ENV.ACCOUNT.terms_required,
        terms_url: ENV.ACCOUNT.terms_of_use_url,
        privacy_url: ENV.ACCOUNT.privacy_policy_url
      }));
      $node.find('.date-field').datetime_field();
      $node.find('.signup_link').click(preventDefault(function() {
        $node.dialog('close');
        return signupDialog($(this).data('template'), $(this).prop('title'));
      }));
      $form = $node.find('form');
      $form.formSubmit({
        required: (function() {
          var _i, _len, _ref1, _results;
          _ref1 = $form.find(':input[name]').not('[type=hidden]');
          _results = [];
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            el = _ref1[_i];
            _results.push(el.name);
          }
          return _results;
        })(),
        disableWhileLoading: 'spin_on_success',
        errorFormatter: registrationErrors,
        success: function(data) {
          if (data.course) {
            return window.location = "/courses/" + data.course.course.id + "?registration_success=1";
          } else {
            return window.location = "/?registration_success=1";
          }
        }
      });
      $node.dialog({
        resizable: false,
        title: title,
        width: 550,
        open: function() {
          $(this).find('a').eq(0).blur();
          return $(this).find(':input').eq(0).focus();
        },
        close: function() {
          return $('.error_box').filter(':visible').remove();
        }
      });
      $node.fixDialogButtons();
      if (!ENV.ACCOUNT.terms_required) {
        return addPrivacyLinkToDialog($node);
      }
    };
    signupDialog.templates = templates;
    return signupDialog;
  });

}).call(this);
