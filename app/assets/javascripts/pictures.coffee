# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

setZoomLoupe = (image) ->
  image.elevateZoom({
    zoomType: "lens",
    containLensZoom: true,
    lensShape: "round", #rectangle
    lensSize: 150
  })
  $('.btn-zoom-loupe').addClass('disable')
  return

removeZoomLoupe = () ->
  $(".zoomContainer").remove()
  $('.show-picture-image').removeData("elevateZoom")
  $('.btn-zoom-loupe').removeClass('disable')
  return

ready = ->

  $("[id^='picture-modal']").on('shown.bs.modal', ->
    if ($(this).find('.btn-zoom-loupe.disable').length)
      removeZoomLoupe()
      setZoomLoupe($(this).find('.show-picture-image'))
      return
  ).on('hidden.bs.modal', ->
    if (!$('.modal').hasClass('in') && $('.zoomContainer').length)
      removeZoomLoupe()
  )
  return

$(document).ready(ready)
$(document).on('page:load', ready)

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
).on('click', '.picture-show .btn-left, .picture-show .btn-right, .btn-back-pictures', (e)->
  $('#picture-modal-' + $(this).attr('data-picture-id')).modal('hide')
  $('#picture-modal-form').modal('hide')
  return false
).on('shown.bs.modal', '#picture-modal-form', ->
  new CarrierWaveCropper()
  return
).on('click', '.btn-zoom-loupe', ->
  if ($('.zoomContainer').length)
    removeZoomLoupe()
  else
    image_element = $('#picture-modal-' + $(this).attr('data-picture-id')).find('.show-picture-image')
    setZoomLoupe(image_element)
  return false
)






