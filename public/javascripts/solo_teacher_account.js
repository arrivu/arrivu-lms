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

    $(".solo_teacher_signup").click(function(event) {
        event.preventDefault();
        var $dialog = $("#solo_teacher_dialog");
        $dialog.dialog({
            title: I18n.t('add_solo_teacher_dialog_title', "Get a  Solo Teacher Account"),
            width: 500
        }).fixDialogButtons();
//        addPrivacyLinkToDialog($dialog);
        $("#add_solo_teacher_form :text:visible:first").focus().select();
        $('#add_solo_teacher_form').find("input[type=text], textarea").val("");
        $(".error_box").remove();
    });
    $("#add_solo_teacher_form").formSubmit({
        formErrors: false,
        required: ['user[name]','pseudonym[unique_id]','sub_account_name[account]'],
        beforeSubmit: function(data) {
            $(this).loadingImage();
            $("button").attr('disabled', true)
                .filter(".submit_button").text(I18n.t('creating_user_account', "Creating Account..."));
        },
        success: function(data) {
            $.flashMessage("Your solo teacher account created and you should receive an email confirmation shortly");
            $("#solo_teacher_dialog").dialog('close');
            window.location.href = "/dashboard"
        },
        error: function(data) {
            $(this).loadingImage('remove');
            $("button").attr('disabled', false)
                .filter(".submit_button").text(I18n.t('create_account_failed_message', "Create account Failed, please try again"));

            errorData = {};
            // Email errors
            if(data.pseudonym){
                if(data.pseudonym.unique_id){
                    errorList = [];
                    $.each(data.pseudonym.unique_id, function(i){
                        if(this.message){
                            errorList.push(this.message);
                        }
                    });
                    errorData['unique_id'] = errorList.join(', ');
                }
            }else{
                errorData['unique_id'] = data.course_limit
            }

            $(this).formErrors(errorData);

            $(this).find("button").attr('disabled', false)
                .filter(".submit_button").text(I18n.t('create_user_account', "Create Account"));
        }
    });
    $("#solo_teacher_dialog .cancel_button").click(function() {
        $("#solo_teacher_dialog").dialog('close');
    });
});