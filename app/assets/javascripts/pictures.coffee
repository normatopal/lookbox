ReloadSelectedCategory = ->
  $('#q_category_search').select2({
    theme: "bootstrap",
    placeholder: 'All',
    maximumSelectionLength: 4
  })

  selected_categories = $('#selected_categories').val()
  if (selected_categories != undefined && selected_categories != '')
    $('#q_category_search').val(selected_categories.split(',')).trigger("change")

  return

$(document).on('turbolinks:load', ReloadSelectedCategory)

IncreaseRotationAngle = (preview, thumb, angle) ->
  if ($(preview).is(':visible'))
    $(thumb).removeClass(ConstantsList.Images.rotationClasses).addClass('rotate' + angle)
  return

PictureCropperSwitch = (opts={}) ->
  $('.file-image-preview')[opts['image'] || 'children']()
  $('.crop-image-preview')[opts['crop'] || 'children']()
  if (opts['switch'])
    ['.picture-form-block', '.crop-image-block'].forEach((el) -> $(el).toggle() )
  return

RefreshPictureThumbnail = (original_rotation) ->
  $('.fileinput-preview.thumbnail').removeClass(ConstantsList.Images.rotationClasses)
  $('#current_picture_rotation').val(0)
  $('#picture_rotation').val(original_rotation)
  $('#original_picture_rotation').val(original_rotation)
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
  return


$(document).on(
  'mouseenter', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').show()

).on('mouseleave', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').hide()

).on('click', '#rotate_image', (e) ->
  [ current_angle, original_angle ] = [ parseInt($('#current_picture_rotation').val()), parseInt($('#original_picture_rotation').val()) ]
  current_angle = (current_angle + ConstantsList.Images.rotationAngle) % 360
  $('#current_picture_rotation').val(current_angle)
  $('#picture_rotation').val((current_angle + original_angle) % 360)
  IncreaseRotationAngle('.file-image-preview', '.fileinput-preview.thumbnail', current_angle)
  IncreaseRotationAngle('.crop-image-preview', '.crop-previewbox.thumbnail', current_angle)
  return false

).on('change.bs.fileinput', '.fileinput', ->
  if $('#picture_title').val() == ''
    $('#picture_title').val($('input[type=file]').val().split('\\').pop().split('.').shift().replace(/_/g, ' '))

).on('click', '.image-crop', (e) ->
  if ($(e.currentTarget).hasClass('ok'))
    $('#picture_rotation').val(0)
    $("input[id^='picturedecorator_image_crop']").prop('disabled', false)
    PictureCropperSwitch({'image': 'hide', 'crop': 'show', 'switch': true})
  else if ($(e.currentTarget).hasClass('cancel'))
    PictureCropperSwitch({'switch': true})
  else
    window.PictureCropper = new window.CarrierWaveImageCropper()
    preview_image_src = $('.fileinput-preview.thumbnail img').attr('src')
    crop_image_scr = $('#picturedecorator_image_cropbox').attr('src')
    if ($('.file-image-preview').is(":visible") && preview_image_src != crop_image_scr)
      PictureCropperSwitch({'switch': true})
    else
      PictureCropperSwitch({'switch': true})
  return

).on('click', '.fileinput-exists', ->
  $('.fileinput-preview').on("DOMNodeInserted", "img", ->
    RefreshPictureThumbnail(0)
  )

).on('focus', '#picture_direct_image_url', ->
  $('.image-uploader').addClass('disabled')

).on('blur', '#picture_direct_image_url', (e) ->
  if (this.value == '')
    $('.image-uploader').removeClass('disabled')

).on('click', '.image-refresh', ->
   image_preview = $('.fileinput-preview.thumbnail')
   if (image_preview.is(':empty'))
     # because of reset name collision
     $($('.image-uploader.fileinput input')[0].form).off('reset.bs.fileinput')
     $('.image-uploader.fileinput').fileinput('reset')
     $($('.image-uploader.fileinput input')[0].form).on('reset.bs.fileinput')
   else
     RefreshPictureThumbnail($('#original-image-rotation').val())

).on('mouseenter', '.title-input-wrapper', ->
  if ($(this).find($('input:text')).val().length > 0)
    $(this).find($('.clear-input-btn')).css('display', 'inline-block')

).on('mouseleave', '.title-input-wrapper', ->
  $(this).find($('.clear-input-btn')).hide()

).on('click', '.clear-input-btn', ->
  $(this).closest('.title-input-wrapper').find($('input:text')).val('').focus()
  $(this).hide()

).on('change', '.image-load', (e) ->
  image = e.target.files[0]
)

window.LoadImageWithOrientation = (image) ->
    window.loadImage(image, (img) ->
      if (img.type == "error")
        console.log("couldn't load image:", img)
      else
        window.EXIF.getData(image, ->
          orientation = window.EXIF.getTag(this, "Orientation")
          canvas = window.loadImage.scale(img,  {orientation: orientation || 0, canvas: true, maxWidth: 150})
          $(".fileinput-preview").empty().append(canvas))
    )
    return








