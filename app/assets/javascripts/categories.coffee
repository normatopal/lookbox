$(document).on('click', '.image-space.remove-picture', ->
  chbox = $(this).siblings('.category-picture-chbox')
  image_opacity = 1
  is_checked = chbox.is(':checked')
  $('.picture-action .glyphicon').removeClass('glyphicon-ok').addClass('glyphicon-remove')
  if is_checked
    image_opacity = 0.5
    $('.picture-action .glyphicon').removeClass('glyphicon-remove').addClass('glyphicon-ok')
  $(this).css({ opacity: image_opacity })
  chbox.prop('checked', !is_checked)
  return
)