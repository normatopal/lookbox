$(document).on('click', '.picture-block', ->
  chbox = $(this).find('.category-picture-chbox')
  image_opacity = 1
  is_checked = chbox.is(':checked')
  if is_checked
    image_opacity = 0.5
    $(this).find('.picture-action .glyphicon').removeClass('glyphicon-remove').addClass('glyphicon-ok')
  $(this).css({ opacity: image_opacity })
  chbox.prop('checked', !is_checked)
  return
)
