# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(document).on('mouseenter', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').show()
#).on('mouseleave', '.pictures-list .picture-block, .pictures-list .look-picture-block', -> $(this).find('.picture-action').hide()
#)

ready = ->

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

  return

$(document).ready(ready)
$(document).on('page:load', ready)






