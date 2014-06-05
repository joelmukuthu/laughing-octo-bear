# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.DIALOG = 
  error: (message) ->
    BootstrapDialog.show
      type: BootstrapDialog.TYPE_DANGER
      title: I18n.dialogs.error.title
      message: message
      buttons: [
        {
          label: I18n.dialogs.error.ok
          cssClass: 'btn-primary'
          action: (dialog) ->
            dialog.close()
        }
      ]
