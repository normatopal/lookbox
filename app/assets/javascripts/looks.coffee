ready = ->

  draggable_options = {
    #start: drag_start
    stop: (event, ui) ->
      look_position_element = $('#' + this.id + '-position')
      look_position_element.find($("input[id$='position_top']")).get(0).value = ui.position["top"]
      look_position_element.find($("input[id$='position_left']")).get(0).value = ui.position["left"]
      return
    stack: ".draggable"
  }

  set_look_canvas = ->

    $("#look-canvas").resizable({ handles: 'e, s, se' })

    $(".draggable" ).draggable(draggable_options)


    $("#look-screenshot").click ->
      encode_image_url()
      $("<a>", {href: $('#preview-image-url').val(), download: $("#look_name").val()})
        .on("click", -> $(this).remove()).appendTo("body")[0].click()
      return false

    $(".draggable").click -> change_zindex($(this))

    $("#look-canvas").on("DOMNodeInserted", ".draggable", -> set_draggable($(this)) )

    $("#look-save-btn").click (e) ->
      e.preventDefault()
      $("#preview-image-title").val($("#look_name").val() + " screen")
      encode_image_url($("#look-save-form"))
      return

    max_zindex = 100

    change_zindex = (e) ->
      max_zindex += 1
      e.css('z-index', max_zindex)
      return

    set_draggable = (e) ->
      e.draggable(draggable_options)
      e.click -> change_zindex($(this))
      return

    encode_image_url = (e) ->
      html2canvas($('#look-canvas'), {
        onrendered: (canvas) ->
          #return Canvas2Image.saveAsPNG(canvas)
          url = canvas.toDataURL(("image/png"));
          $('#preview-image-url').val(url)
          if (e)
            e.submit()
          return
      })
      return

    return

  if $("#look-canvas").length > 0
    set_look_canvas()

  return


$(document).ready(ready)
$(document).on('page:load', ready)









