$(document).on('click', '.add-picture', ->
  chbox = $(this).find('.mark-picture-chbox')
  #if $.inArray(chbox.val(), $.cookie("extra_pictures").split(',')) > -1
    #return false
  is_checked = chbox.is(':checked')
  if is_checked
    $(this).find('.picture-action').hide()
  else
    $(this).find('.picture-action').show()
    $('.btn-add-picture').attr('disabled', false)
  chbox.prop('checked', !is_checked)
  return
)
