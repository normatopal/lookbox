ready = ->
  $("#look-canvas").resizable({ handles: 'e, s, se', minHeight: 200, minWidth: 200 })
  return

$(document).ready(ready)
$(document).on('page:load', ready)

$(document).on('change', '#category-pictures-filter', ->
  picture_ids = $(this).find(':selected').attr('data-picture-ids')
  if typeof picture_ids != "undefined"
    $('.picture-block').hide()
    picture_ids.split(',').forEach (id, index) ->  $('#picture-block-' + id).show()
  else
    $('.picture-block').show()
  return
).on('blur', '#look_name', (e) ->
  $("#preview-image-title").val(e.target.value + ' screen')
).on('shown.bs.collapse', '#look_options', ->
  $('.btn-look-options').html('Hide params...')
).on('hidden.bs.collapse', '#look_options', ->
  $('.btn-look-options').html('Params...')
)












