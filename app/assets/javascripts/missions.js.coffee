# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  imageFieldDiv = $('#image_field')
  imageField = $('#mission_image', imageFieldDiv)
  removeImageButton = $('#remove_image', imageFieldDiv)
  changeImageButton = $('#change_image', imageFieldDiv)
  addImageButton = $('#add_image', imageFieldDiv)
  removeImageCheck = $('#mission_remove_image', imageFieldDiv)
  image = $('img', imageFieldDiv)
  imageLabel = $('label', imageFieldDiv)
  chosenImageText = $('#chosen_image')
  imageType = /image.*/
  allowedImageTypes = ['.jpg', '.png', '.jpeg']

  imageLabel.data 'original', imageLabel.text()

  resetFormElement = (e) -> 
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()

  removeImageButton.click (e) ->
    e.preventDefault()
    BootstrapDialog.show
      title: I18n.dialogs.confirm.title
      message: removeImageButton.data('message').replace('%{filename}', chosenImageText.text())
      buttons: [
        {
          label: I18n.dialogs.confirm.ok
          action: (dialog) ->
            image.hide()
            removeImageButton.hide()
            imageLabel.text imageLabel.data('original')
                      .show()
            changeImageButton.hide()
            addImageButton.show()
            chosenImageText.text ''
            removeImageCheck.prop 'checked', true
            resetFormElement imageField
            dialog.close()
        }, 
        {
          label: I18n.dialogs.confirm.cancel
          action: (dialog) ->
            dialog.close()
        }
      ]

  changeImageButton.click (e) -> 
    e.preventDefault()
    imageField.click()

  addImageButton.click (e) -> 
    e.preventDefault()
    imageField.click()

  imageField.change ->
    filename = imageField.val().split('\\').pop()
    return if !filename
    valid = $.inArray(filename.substring(filename.lastIndexOf('.')), allowedImageTypes) > -1
    # TODO: display error to user
    if !valid
      resetFormElement imageField
      return
    removeImageCheck.prop 'checked', false
    chosenImageText.text filename
    if window.File and window.FileReader
      file = imageField.get(0).files[0]
      if file.type.match(imageType)
        reader = new FileReader()
        reader.onload = (e) -> 
          imageLabel.hide()
          image.attr 'src', reader.result
          image.show()
        reader.readAsDataURL file
      else
        # TODO: display error to user
        console.log 'invalid file type'
    else
      imageLabel.text imageLabel.data('unsupported').replace('%{filename}', filename)
                .show()
      image.hide()
    if addImageButton.is ':visible'
      addImageButton.hide()
      changeImageButton.show()
      removeImageButton.show()

  listedMissionsContainer = $ '#listed-missions'
  listedMissions = listedMissionsContainer.find('.missions')
  missionsFlagContainers = listedMissionsContainer.find('.flag')

  # disabled tooltip
  # missionsFlagDropdownContainers = missionsFlagContainers.children('div').first()
  # missionsFlagContainers.tooltip()
  # missionsFlagDropdownContainers.on 'show.bs.dropdown', ->
  #   $(this).parent().tooltip('hide')

  missionsFlagContainers.find('.ok').click (e) ->
    e.preventDefault()
    return if $(this).data 'busy'
    $this = $(this).data 'busy', true
    $flag = $this.parents('.flag').first().addClass('spin')
    $mission = $this.parents('.mission').first()
    $flag.find('[data-toggle="dropdown"]').click()
    stopSpinner = ->
      $this.data 'busy', false
      $flag.removeClass('spin')
    $.ajax 
      url: $this.data 'url'
      type: $this.data 'method'
      dataType: 'text' # we expect no data from the server, this avoids a JSON parse error [https://github.com/toastdriven/django-tastypie/issues/886]
      success: ->
        message = $('<p style="display:none">').text $this.data('message-flagged')
        $mission.height $mission.height()
        $mission.children().fadeOut 'fast', ->
                  $(this).remove()
        $mission.addClass('flagged')
                .append(message)
        message.fadeIn 'fast'
        $mission.height message.outerHeight() + 20
        restackMissions = ->
          if Masonry
            listedMissions.masonry()
        if Modernizr.csstransitions
          $mission.on 'transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd', restackMissions
        else
          restackMissions()
        stopSpinner()
      error: ->
        DIALOG.error($this.data('message-flag-error'))
        stopSpinner()

  missionsFlagContainers.find('.cancel').click (e) ->
    e.preventDefault()
    $(this).parents('.flag').first().find('[data-toggle="dropdown"]').click()
