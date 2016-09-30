# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $('.pictures-list .picture-block, .pictures-list .look-picture-block').mouseenter -> $(this).find('.picture-action').show()

  $('.pictures-list .picture-block, .pictures-list .look-picture-block').mouseleave -> $(this).find('.picture-action').hide()

  $('.pictures-list .image-block').click -> $(this).parent().find('.modal').modal 'show'

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

    $('.remove-look-picture-btn').click ->
      

  return

$(document).ready(ready)
$(document).on('page:load', ready)






