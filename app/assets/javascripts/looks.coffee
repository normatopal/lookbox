ready = ->

  set_look_canvas = ->

    check_position_range = (top, left, picture_id) ->
      canvas_width = $('#look-canvas').width(); canvas_height = $('#look-canvas').height()
      position_top = if top < -200 then -200 else top
      position_top = if (canvas_height - position_top < 50) then canvas_height - 50 else position_top
      position_left = if left < -150 then -150 else left
      position_left = if (canvas_width - position_left < 50) then canvas_width - 50 else position_left
      $('#' + picture_id).css('top', position_top + 'px') if position_top != top
      $('#' + picture_id).css('left', position_left + 'px') if position_left != left
      return {top: position_top, left: position_left}

    draggable_options = {
      #start: drag_start
      stop: (event, ui) ->
        position = check_position_range(ui.position["top"], ui.position["left"], this.id)
        look_position_element = $('#' + this.id + '-position')
        look_position_element.find($("input[id$='position_top']")).get(0).value = position['top']
        look_position_element.find($("input[id$='position_left']")).get(0).value = position['left']
        change_zindex($(this)) # just use element.draggable({ stack: "div", distance: 0 })
        return
      stack: ".draggable"
    }

    resizeable_options = {
        handles: 'se',
        minHeight: 30,
        minWidth: 30,
        aspectRatio: true, # resize image proportionally
        stop: (event, ui) ->
          res = ui
          return
    }

    set_draggable_resizable = (e) ->
      e.find('.resizable').resizable(resizeable_options)
      e.draggable(draggable_options)
      e.click -> change_zindex($(this))
      return

    $("#look-canvas").resizable({ handles: 'e, s, se' })

    #$(".draggable").draggable(draggable_options)
    set_draggable_resizable($(".draggable"))



    $("#look-screenshot").click ->
      encode_image_url((image_url) -> $("<a>",
                                  {href: image_url, download: $("#look_name").val()}).on("click",
                                  -> $(this).remove()).appendTo("body")[0].click())
      return false

    $(".draggable").click -> change_zindex($(this))

    $("#look-canvas").on("DOMNodeInserted", ".draggable", -> set_draggable_resizable($(this)) )

    $("#look-save-btn").click (e) ->
      e.preventDefault()
      $("#preview-image-title").val($("#look_name").val() + " screen")
      encode_image_url((image_url) -> $("#look-save-form").submit())
      return

    max_zindex = 100

    change_zindex = (e) ->
      max_zindex += 1
      e.css('z-index', max_zindex)
      $('#' + e.attr('id') + '-position').find($("input[id$='order']")).get(0).value = max_zindex
      return

    encode_image_url = (fn) ->
      html2canvas($('#look-canvas'), {
        onrendered: (canvas) ->
          #return Canvas2Image.saveAsPNG(canvas)
          url = canvas.toDataURL(('image/png'));
          $('#preview-image-url').val(url)
          fn(url)
      })
      return

    return

  if $("#look-canvas").length > 0
    set_look_canvas()

  return

$(document).ready(ready)
$(document).on('page:load', ready)

$(document).on('click', '.remove-look-picture-btn', ->
  picture_id = $(this).attr('picture-removed-id')
  $('#look-picture-' + picture_id).hide()
  $('#look-picture-' + picture_id + '-position').find($("input[id$='_destroy']")).get(0).value = 'true'
  look_pictures_ids = $.cookie('look_pictures_ids').split(',')
  index = $.inArray(picture_id, look_pictures_ids)
  if (index >= 0)
    look_pictures_ids.splice(index, 1)
    $.cookie('look_pictures_ids', look_pictures_ids.join(','), { path: '/' })
  return
).on('railsAutocomplete.select', '#user-email-autocomplete', (event, data) ->
  unless data.item.id
    $(this).val('')
    return
  exist_user = $("#shared-user-id-" + data.item.id)
  if exist_user.length && !exist_user.is(':visible')
    exist_user.find($("input[id$='_destroy']")).get(0).value = 'false'
    exist_user.show()
  return if exist_user.length > 0
  users_count = parseInt($('#shared-users-count').val())
  data = { users_count: users_count, user: { id: data.item.id, email: data.item.value } }
  $('#shared-user-template').tmpl(data).appendTo('#shared-users-list')
  return
).on('click', '.remove-shared-user-btn', ->
  user_id = $(this).attr('user-removed-id')
  $('#shared-user-id-' + user_id).find($("input[id$='_destroy']")).get(0).value = 'true'
  $('#shared-user-id-' + user_id).hide()
  return false
).on('keyup', "#user-email-autocomplete", ->
  visibility = if this.value.length > 0 then "visible" else "hidden"
  $(".clear-input-btn").css('visibility', visibility)
  return
).on('click', '.clear-input-btn', ->
#  $(this).prev('input').first().val('')
#  $(this).css('visibility', 'hidden')
  return
).on('change', '#category-pictures-filter', ->
  picture_ids = $(this).find(':selected').attr('data-picture-ids')
  if typeof picture_ids != "undefined"
    $('.picture-block').hide()
    picture_ids.split(',').forEach (id, index) ->  $('#picture-block-' + id).show()
  else
    $('.picture-block').show()
  return
)












