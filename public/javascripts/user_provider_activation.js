require([
    'jquery', /* $ */
    'jquery.disableWhileLoading'
], function($) {
    var check_box_state;
    $(".activate").click(function() {
        var $self = $(this);
        if ($(this).is(':checked')) {
            check_box_state = 'checked';
        } else {
            check_box_state = 'unchecked';
        }
        $("#content").disableWhileLoading( $.ajax({
            type: 'POST',
            url: 'update_user',
            data: {
                'id': $self.attr('id'),
                'state': check_box_state
            },
            complete: function(msg){
                $.flashMessage('User status updated!')
            }
        })
        );
    });
    $('select#provider_select').change(function() {
        $("#content").disableWhileLoading( $.ajax({
            type: 'POST',
            url: 'update_user',
            data: {
                'id': $("#provider_select").attr('name'),
                'provider': $("#provider_select").val()
            },
            complete: function(msg){
                $.flashMessage('Provider Updated!')
            }
        })
        );
    });
});