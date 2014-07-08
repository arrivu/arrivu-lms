require([
    'jquery' /* $ */,
    'jquery.instructure_forms' /* formSubmit */,
    'jqueryui/dialog',
    'compiled/jquery/fixDialogButtons' /* fix dialog formatting */,
    'compiled/jquery.rails_flash_notifications'
], function( $) {
    $(".logo").hover(function() {
        $(".hide").css("display","block");
    });
    $("#header-inner").hover(function() {
        $(".hide").css("display","none");
    });
    $("#header-logo").hover(function() {
        $(".hide").css("display","block");
    });
    $(".navbar-inner").hover(function() {
        $(".hide").css("display","none");
    });
    $(".hide").click(function(event) {
        $(".hide").css("display","none");
        var $dialog = $("#header_logo_dialog");
        $dialog.dialog({
            title: ( "Add Account Header Details"),
            width:550,
            closeOnEscape: false
        })
    });
    $("#upload_header_logo_form").formSubmit({
            fileUpload: true,
            preparedFileUpload: true,
            singleFile: true,
            object_name: 'attachment',
            context_code: $("#editor_tabs .context_code").text(),
            folder_id: function() {
                return $(this).find("[name='attachment[folder_id]']").val();
            },
            upload_only: true,
            processData: function(data) {
            data['attachment[display_name]'] = $("#header_logo_uploaded_data").find(".file_name").val();
            return data;
           },
           beforeSubmit: function(data) {
               $("#upload_header_logo_form").find(".uploading").slideDown();
               var val = $("#header_logo_uploaded_data").val();
               if (val === "")
               {
                   $("#upload_header_logo_form").find(".uploading").slideUp();
                   alert ("Please choose your logo to upload");
               }
           },
           success: function(data){
             account_id = $("#label_id").attr('rel');
             course_background_image = $(".logo");
             course_background_image.attr('src', "/accounts/"+account_id+"/files/"+ data.attachment.id +"/preview");
             $("#upload_header_logo_form").find(".uploading").slideUp();
             $("#header_logo_dialog").dialog("close")

           }
       })

});