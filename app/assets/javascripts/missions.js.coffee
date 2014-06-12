# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # no need to proceed if not on a /missions page. thankfully turbolinks updates the body class
  return if !$('body').hasClass('missions')

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

  $('#deadline').datepicker()

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

  missionsContainer = $ '#missions'
  listedMissionsContainer = $ '#listed-missions', missionsContainer
  showcasedMissionsContainer = $ '#showcased-missions', missionsContainer
  listedMissions = $ '.missions', listedMissionsContainer
  showcasedMissions = $ '.missions', showcasedMissionsContainer
  missionsFlagContainers = $ '.flag', listedMissionsContainer
  missionsActionButtons = $ '.sponsors, .torches', missionsContainer

  # TODO: add popovers
  # TODO: add spin animation
  # TODO: better notification of successful sponshorship
  missionsActionButtons.click (e) -> 
    e.preventDefault()
    $btn = $(this)
    return if ($btn.data('busy'))
    $btn.addClass('loading').data 'busy', true
    $parent = $btn.parent()
    id = $parent.parents('.mission').first().data('mission-id')
    class_name = $btn.attr('class').match /(torches|sponsors)/
    class_name = class_name[1]
    if listedMissionsContainer.is $parent.data('container')
      other = showcasedMissionsContainer
    else
      other = listedMissionsContainer
    $otherButton = other.find('.mission[data-mission-id="'+id+'"] .actions .'+class_name)
    $otherButton.addClass('loading').data 'busy', true
    if $btn.hasClass('activated')
      method = 'DELETE'
      error = $btn.data('destroy-error')
    else
      method = 'POST'
      error = $btn.data('create-error')
    $.ajax
      url: $btn.data('url')
      type: method
      dataType: 'json'
      success: (data) -> 
        $btn.add($otherButton).toggleClass('activated activate').find('span').text data.count
      error: ->
        DIALOG.error(error)
      complete: ->
        $btn.add($otherButton).removeClass('loading').data 'busy', false

  # disabled tooltip
  # missionsFlagDropdownContainers = missionsFlagContainers.children('div').first()
  # missionsFlagContainers.tooltip()
  # missionsFlagDropdownContainers.on 'show.bs.dropdown', ->
  #   $(this).parent().tooltip('hide')

  # use masonry to properly stack listed missions
  listedMissions.imagesLoaded ->
    listedMissions.masonry();

  missionsFlagContainers.find('.ok').click (e) ->
    e.preventDefault()
    return if $(this).data 'busy'
    $this = $(this).data 'busy', true
    $flag = $this.parents('.flag').first().addClass('loading')
    $mission = $this.parents('.mission').first()
    $flag.find('[data-toggle="dropdown"]').click()
    $.ajax 
      url: $this.data 'url'
      type: $this.data 'method'
      dataType: 'text' # we expect no data from the server, this avoids a JSON parse error [https://github.com/toastdriven/django-tastypie/issues/886]
      success: ->
        message = $('<p style="display:none">').text $this.data('message-flagged')
        missionId = $mission.data('mission-id')
        $mission.height $mission.height()
        $mission.children().fadeOut 'fast', ->
                  $(this).remove()
        $mission.addClass('flagged')
                .append(message)
        message.fadeIn 'fast'
        $mission.height message.outerHeight() + 20
        restackMissions = ->
          listedMissions.masonry()
        if Modernizr.csstransitions
          $mission.on 'transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd', restackMissions
        else
          restackMissions()
        if showcasedMissions.length 
          missions = showcasedMissions.find('.mission')
          missions.each (i,v) ->
            $mission = $(this)
            removeMissionAndUpdateIndicators = ->
              showcasedMissionsContainer.carousel('pause')
              $mission.remove()
              showcasedMissionsContainer.find('ol li[data-slide-to="' + index + '"]').remove()
              indicators = showcasedMissionsContainer.find('ol li')
              indicators.each (i,v) ->
                $(this).attr('data-slide-to', i).data('slide-to', i)
              if indicators.length == 1
                indicators.first().addClass('active')
              showcasedMissionsContainer.carousel('cycle')
            if $mission.data('mission-id') == missionId
              index = missions.index()
              if $mission.hasClass('active')
                showcasedMissionsContainer.one 'slid.bs.carousel', removeMissionAndUpdateIndicators
                showcasedMissionsContainer.carousel('next')
              else
                removeMissionAndUpdateIndicators()
              return false
            return true
      error: ->
        DIALOG.error($this.data('message-flag-error'))
      complete: ->
        $this.data 'busy', false
        $flag.removeClass('loading')

  missionsFlagContainers.find('.cancel').click (e) ->
    e.preventDefault()
    $(this).parents('.flag').first().find('[data-toggle="dropdown"]').click()
