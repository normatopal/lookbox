# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

PictureCropperSwitch = (opts={}) ->
  $('.file-image-preview')[opts['image'] || 'children']()
  $('.crop-image-preview')[opts['crop'] || 'children']()
  if (opts['switch'])
    ['.picture-form-block', '.crop-image-block'].forEach((el) -> $(el).toggle() )
  return

$(document).on('mouseenter', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').show()
).on('mouseleave', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').hide()
).on('click', '#rotate_image', (e) ->
  [ angle, original_angle ] = [ parseInt($('#picture_rotation').val()), parseInt($('#original_image_rotation').val()) ]
  new_angle = (angle - original_angle + 90) % 360
  $('#picture_rotation').val((new_angle + original_angle) % 360)
  if ($('.file-image-preview').is(':visible'))
    $('.fileinput-preview.thumbnail').removeClass('rotate0 rotate90 rotate180 rotate270').addClass('rotate' + new_angle)
  if ($('.crop-image-preview').is(':visible'))
    $('.crop-previewbox.thumbnail').removeClass('rotate0 rotate90 rotate180 rotate270').addClass('rotate' + new_angle)
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
      #[ angle, original_angle ] = [ parseInt($('#picture_rotation').val()), parseInt($('#original_image_rotation').val()) ]
      #image_angle = (angle + original_angle) % 360
      #window.PictureCropper.changeImage($('#original_image_url').val().replace('a_' + original_angle, 'a_' + image_angle))
      PictureCropperSwitch({'switch': true})
    else
      PictureCropperSwitch({'switch': true})
  return
).on('click', '.fileinput-exists', ->
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
).on('click', '.image-refresh', ->
  $('.fileinput-preview.thumbnail').removeClass('rotate0 rotate90 rotate180 rotate270')
  $('#picture_rotation').val(0)
  #window.PictureCropper.changeImage($('.fileinput-preview.thumbnail img')[0].src)
  PictureCropperSwitch({'image': 'show', 'crop': 'hide', 'switch': false})
)








