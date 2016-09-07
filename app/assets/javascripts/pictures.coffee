# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('mouseenter', '.picture-block', ->
  $(this).find('.picture-action').show()
  return
).on('mouseleave', '.picture-block', ->
  $(this).find('.picture-action').hide()
  return
).on('click', '.image-space', ->
  $(this).parent().find('.modal').modal 'show'
  return
).on('click', '.add-picture-block', ->
  chbox = $(this).find('.mark-picture-chbox')
  is_checked = chbox.is(':checked')
  if is_checked
    $(this).find('.picture-action').hide()
  else
    $(this).find('.picture-action').show()
  chbox.prop('checked', !is_checked)
  return
)


