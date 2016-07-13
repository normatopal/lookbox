# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('mouseenter', '.picture-block', ->
  $(this).find('.picture-action-links').show()
  return
).on('mouseleave', '.picture-block', ->
  $(this).find('.picture-action-links').hide()
  return
).on 'click', '.image-space', ->
  $(this).parent().find('.modal').modal 'show'
  return
