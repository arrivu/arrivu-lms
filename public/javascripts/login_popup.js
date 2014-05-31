require([
    'i18n!accounts' /* I18n.t */,
    'jquery' /* $ */,
    'compiled/util/addPrivacyLinkToDialog',
    'user_sortable_name',
    'jquery.instructure_forms' /* formSubmit */,
    'jqueryui/dialog',
    'compiled/jquery/fixDialogButtons' /* fix dialog formatting */,
    'compiled/jquery.rails_flash_notifications'
], function(I18n, $, addPrivacyLinkToDialog) {

    $("#log_in_popup").click(function(event) {
        event.preventDefault();
        var $dialog = $("#login_pop_up");
        $dialog.dialog({
            title: I18n.t('E-learning_login_pop_up', "Log In"),
            width: 510,
            poition: 'center'
        }).fixDialogButtons();
        $(".ui-dialog-buttonset").find("#request_password_button").hide();
    });
    $("#e_learning_login_form").formSubmit({
        required: ['pseudonym_session[unique_id]','pseudonym_session[password]'],
        beforeSubmit: function(data) {
            $("button").attr('disabled', true)
                .filter(".submit_button").text(I18n.t('logging_message', "Logging In..."));
        },
        success: function(data) {
            $.flashMessage("Successfully Logged IN");
            window.location.href ="/"

        }
    });
    $("#elearning_forgot_passowrd_link").click(function(event) {
        $("#only_login").hide();
        $("#e_learning_forgot_password_form").show();
        $(".ui-dialog-buttonset").find("#request_password_button").show();
        $(".ui-dialog-buttonset").find("#elearning_login_button").hide();
    });
    $("#elearning_login_link").click(function(event) {
        $("#only_login").show();
        $("#e_learning_forgot_password_form").hide();
        $(".ui-dialog-buttonset").find("#request_password_button").hide();
        $(".ui-dialog-buttonset").find("#elearning_login_button").show();
    });
});