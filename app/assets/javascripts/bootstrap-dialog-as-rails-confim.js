$(function(){

    /*** CONFIRM MODAL OVERRIDE ***/
    //override the use of js alert on confirms
    //requires bootstrap3-dialog from https://github.com/nakupanda/bootstrap3-dialog
    //source: https://gist.github.com/Genkilabs/bdcc5f62c5b46a8e0904
    $.rails.allowAction = function(link) {
        if( !link.is('[data-confirm]') )
            return true;
        BootstrapDialog.show({
            type: BootstrapDialog.TYPE_DANGER,
            title: I18n.dialogs.confirm.title,
            message: link.attr('data-confirm'),
            buttons: [{
                label: I18n.dialogs.confirm.ok,
                cssClass: 'btn-primary',
                action: function(dialogRef){
                    link.removeAttr('data-confirm');
                    link.trigger('click.rails');
                    dialogRef.close();
                }
            }, {
                label: I18n.dialogs.confirm.cancel,
                action: function(dialogRef){
                    dialogRef.close();
                }
            }]
        });
        return false; // always stops the action since code runs asynchronously
    };

});