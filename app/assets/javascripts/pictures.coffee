# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

PictureCropperSwitch = (opts={}) ->
  $('.picture-image-preview')[opts['image'] || 'children']()
  $('.image-crop-previewbox')[opts['crop'] || 'children']()
  if (opts['switch'])
    ['.picture-form-block', '.crop-image-block'].forEach((el) -> $(el).toggle() )
  return

$(document).on('mouseenter', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').show()
).on('mouseleave', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').hide()
).on('click', '#rotate_image', ->
  angle = parseInt($('#picture_rotation').val()) || 0
  angle = (angle + 90) % 360
  $('.fileinput-preview.thumbnail').removeClass('rotate0 rotate90 rotate180 rotate270').addClass('rotate' + angle)
  $('#picture_rotation').val(angle)
  return false
).on('change.bs.fileinput', '.fileinput', ->
  if $('#picture_title').val() == ''
    $('#picture_title').val($('input[type=file]').val().split('\\').pop().split('.').shift().replace(/_/g, ' '))
)
.on('click', '.image-crop', (e) ->
  if ($(e.currentTarget).hasClass('ok'))
    PictureCropperSwitch({'image': 'hide', 'crop': 'show', 'switch': true})
  else if ($(e.currentTarget).hasClass('cancel'))
    PictureCropperSwitch({'switch': true})
  else
    preview_image_src = $('.fileinput-preview.thumbnail img').attr('src')
    crop_image_scr = $('#picturedecorator_image_cropbox').attr('src')
    if ($('.picture-image-preview').is(":visible") && preview_image_src != crop_image_scr)
      window.PictureCropper.changeImage(preview_image_src)
    PictureCropperSwitch({'switch': true})
  return
).on('click', '.fileinput-exists', ->
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
).on('click', '.image-refresh', ->
  $('.fileinput-preview.thumbnail').empty().append("<img src='#{$('.show-picture-image').attr('src')}'>")
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
)








