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
      title: 'Confirm'
      message: removeImageButton.data('message').replace('%{filename}', chosenImageText.text())
      buttons: [
        {
          label: 'Yes'
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
          label: 'No'
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