require([
    'i18n!accounts' /* I18n.t */,
    'jquery' /* $ */,
    'compiled/util/addPrivacyLinkToDialog',
    'str/htmlEscape',
    'user_sortable_name',
    'jquery.instructure_forms' /* formSubmit */,
    'jqueryui/dialog',
    'compiled/jquery/fixDialogButtons' /* fix dialog formatting */,
    'compiled/jquery.rails_flash_notifications'
], function(I18n, $, addPrivacyLinkToDialog,htmlEscape) {

    $("#log_in_popup").click(function(event) {
        event.preventDefault();
        var $dialog = $("#login_pop_up");
        $dialog.dialog({
            title: I18n.t('e_learning_login_pop_up', "Log In"),
            width: 510,
            poition: 'center'
        }).fixDialogButtons();
        $(".ui-dialog-buttonset").find("#request_password_button").hide();
        $('#e_learning_login_form').find("input[type=text],input[type=password], textarea").val("");
        $(".error_box").remove();
    });
    $("#e_learning_login_form").formSubmit({
        required: ['pseudonym_session[unique_id]','pseudonym_session[password]'],
        beforeSubmit: function(data) {
            $(this).loadingImage();
            $("button").attr('disabled', true)
                .filter(".button_type_submit").text(I18n.t('logging_message', "Logging In..."));
        },
        success: function(data) {
            $.flashMessage("Successfully Logged IN");
            $(this).loadingImage('remove');
            window.location.href ="/"

        },
        error: function(data){
            $(this).loadingImage('remove');
            $("button").attr('disabled', false)
                .filter(".button_type_submit").text(I18n.t('login_failed', "Login Failed"));
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

    $("#e_learning_forgot_password_form").formSubmit({
        object_name: 'pseudonym_session',
        required: ['unique_id_forgot'],
        beforeSubmit: function(data) {
            $(this).loadingImage();
        },
        success: function(data) {
            $(this).loadingImage('remove');
            $.flashMessage(htmlEscape(I18n.t("password_confirmation_sent", "Password confirmation sent to %{email_address}. Make sure you check your spam box.", {email_address: $(this).find(".email_address").val()})));
            $(".login_link:first").click();
        },
        error: function(data) {
            $(this).loadingImage('remove');
        }
    });
});