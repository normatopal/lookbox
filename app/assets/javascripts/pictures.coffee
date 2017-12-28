# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

$(document).on('mouseenter', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').show()
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
)
.on('click', '.image-crop', (e) ->
  if ($(e.currentTarget).hasClass('ok'))
    $('#picture_rotation').val(0)
    PictureCropperSwitch({'image': 'hide', 'crop': 'show', 'switch': true})
  else if ($(e.currentTarget).hasClass('cancel'))
    PictureCropperSwitch({'switch': true})
  else
    preview_image_src = $('.fileinput-preview.thumbnail img').attr('src')
    crop_image_scr = $('#picturedecorator_image_cropbox').attr('src')
    if ($('.file-image-preview').is(":visible") && preview_image_src != crop_image_scr)
      PictureCropperSwitch({'switch': true})
    else
      PictureCropperSwitch({'switch': true})
  return
).on('click', '.fileinput-exists', ->
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
).on('click', '.image-refresh', ->
  $('.fileinput-preview.thumbnail').removeClass(ConstantsList.Images.rotationClasses)
  $('#picture_rotation').val(0)
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
).on('mouseenter', '.title-input-wrapper', ->
  if ($(this).find($('input:text')).val().length > 0)
    $(this).find($('.clear-input-btn')).css('display', 'inline-block')
).on('mouseleave', '.title-input-wrapper', ->
  $(this).find($('.clear-input-btn')).hide()
).on('click', '.clear-input-btn', ->
  $(this).siblings($('input:text')).val('')
  $(this).hide()
)








