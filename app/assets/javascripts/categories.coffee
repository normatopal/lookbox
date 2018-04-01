$(document).on('click', '.add-picture', ->
  chbox = $(this).find('.mark-picture-chbox')
  #if $.inArray(chbox.val(), $.cookie("extra_pictures").split(',')) > -1
    #return false
  is_checked = chbox.is(':checked')
  if is_checked
    $(this).find('.tick-mark-green').hide()
  else
    $(this).find('.tick-mark-green').show()
    $('.btn-add-picture').attr('disabled', false)
  chbox.prop('checked', !is_checked)
  return
).on('click', '.select-diselect-picture', ->
    picture = $(this).parents('.picture-block')
    chbox = picture.find('.mark-picture-chbox')
    is_checked = chbox.is(':checked')
    image_opacity = if is_checked then 0.5 else 1
    if is_checked
      $(this).find('.remove-picture').hide()
      $(this).find('.refresh-picture').show()
    else
      $(this).find('.remove-picture').show()
      $(this).find('.refresh-picture').hide()
    picture.css({ opacity: image_opacity })
    chbox.prop('checked', !is_checked)
    return
).on('click', '.category-expand', ->
  $(this).closest('.item').siblings('.nested_set').toggleClass('hide-nested-set')
  $(this).toggleClass('glyphicon-minus').toggleClass('glyphicon-plus')
)
