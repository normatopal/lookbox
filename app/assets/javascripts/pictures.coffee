# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('mouseenter', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').show()
).on('mouseleave', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').hide()
).on('click', '#rotate_image', ->
  angle = parseInt($('#picture_rotation').val()) || 0
  angle = (angle + 90) % 360
  $('.fileinput-preview.thumbnail').removeClass("rotate0 rotate90 rotate180 rotate270").addClass("rotate" + angle)
  $('#picture_rotation').val(angle)
  return false
).on('change.bs.fileinput', '.fileinput', ->
  if $('#picture_title').val() == ''
    $('#picture_title').val($('input[type=file]').val().split('.')[0])
)

ready = ->
  $('.pictures-list .look-block').click -> $(this).parent().find('.modal').modal 'show'


  $('.edit_category .image-block').click ->
    chbox = $(this).parent().find('.mark-picture-chbox')
    image_opacity = 1
    is_checked = chbox.is(':checked')
    if is_checked
      image_opacity = 0.5
      #$(this).find('.picture-action .glyphicon').removeClass('glyphicon-remove').addClass('glyphicon-ok')
    $(this).css({ opacity: image_opacity })
    chbox.prop('checked', !is_checked)
    return

  $('.show-picture-image').elevateZoom({
    zoomType: "inner",
    cursor: "crosshair"
  })

  return

$(document).ready(ready)
$(document).on('page:load', ready)




