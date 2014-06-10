require([
    'jquery' /* $ */,
    'jquery.instructure_forms' /* formSubmit */,
    'jqueryui/dialog',
    'jquery.disableWhileLoading'
], function($) {
    var clicked_create;

    $(document).ready(function() {
        var showChar = 400;
        var ellipsestext = "...";
        var moretext = "more";
        var lesstext = "less";
        $('.more').each(function() {
            var content = $(this).html();

            if(content.length > showChar) {
                var c = content.substr(0, showChar);
                var h = content.substr(showChar-1, content.length - showChar);

                var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span class="morecontent"><span>' + h + '</span>&nbsp;&nbsp;<a href="" class="morelink">' + moretext + '</a></span>';

                $(this).html(html);
            }

        });

        $(".morelink").click(function(){

            if($(this).hasClass("less")) {
                $(this).removeClass("less");
                $(this).html(moretext);
            } else {
                $(this).addClass("less");
                $(this).html(lesstext);
            }
            $(this).parent().prev().toggle();
            $(this).prev().toggle();
            return false;
        });
    });



    $('input:radio[name="initial_action"]').change(
        function(){
            if ($(this).is(':checked') && $(this).val() == 'create') {
                $("#create_user_info").show();
                $("#log_in_user_info").hide();
                clicked_create= 1;
            }else{
                $("#create_user_info").hide();
                $("#log_in_user_info").show();
                clicked_create= 0;
            }
        });
    $("#submit_button").click(function(event) {
        event.preventDefault();
        var $this = $(this);
        if (clicked_create == 1){
//                    validation

            if ($('#student_email').val() == ""){
                result = $('#student_email').validateForm({required: ['pseudonym[unique_id]']});
                return false;
            }

            if ($('#student_name').val() == ""){
                result = $('#student_name').validateForm({required: ['user[name]']});
                return false;
            }

            if (!$('#terms_of_use').is(":checked")){
                result = $('#terms_of_use').validateForm({required: ['user[terms_of_use]']});
                return false;
            }
//                    validation
            $("#enrollment_dialog").disableWhileLoading($.ajax({
                type: 'POST',
                url: $("#email_info").attr('rel'),
                data: {pseudonym: {unique_id: $("#student_email").val()},user: {name: $("#student_name").val()} },
                success: function(res){
                    $.flashMessage('User account created successfully!')
                    window.location.href = $("#enrollment_dialog").attr( 'action' );

                },
                error: function(res){
                    $.flashMessage('Email already taken!')

                }
            })
            );

        }else if (clicked_create == 0){
            //                    validation
            if ($('#student_email').val() == ""){
                result = $('#student_email').validateForm({required: ['pseudonym[unique_id]']});
                return false;
            }

            if ($('#student_password').val() == ""){
                result = $('#student_password').validateForm({required: ['pseudonym[password]']});
                return false;
            }
//                    validation

            $("#enrollment_dialog").disableWhileLoading($.ajax({
                type: 'POST',
                url: $("#login_url").attr('rel'),
                data: {pseudonym_session: {unique_id: $("#student_email").val(),password: $("#student_password").val() ,remember_me: 0} },
                success: function(res){
                    $.flashMessage('You have logged in successfully!')
                    window.location.href = $("#enrollment_dialog").attr( 'action' );

                },
                error: function(res){
                    $.flashMessage('Your name password is worong')
                }
            })
            );
        }

    });
//


});