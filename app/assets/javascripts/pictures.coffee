# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.coffee.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('click', '.image-space', ->
  $(this).parent().find('.modal').modal 'show'
  return
).on('click', '.add-picture-block', ->
  chbox = $(this).find('.mark-picture-chbox')
  if $.inArray(chbox.val(), $.cookie("extra_pictures").split(',')) > -1
    return false
  is_checked = chbox.is(':checked')
  if is_checked
    $(this).find('.picture-action').hide()
  else
    $(this).find('.picture-action').show()
    $('.btn-add-picture').attr('disabled', false)
  chbox.prop('checked', !is_checked)
  return
)

$ ->

  $('.picture-block').mouseenter -> $(this).find('.picture-action').show()

  $('.picture-block').mouseleave -> $(this).find('.picture-action').hide()






