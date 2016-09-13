$ ->
  max_zindex = 100
  #drag_start = (e) ->

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
    if $("#look-canvas").length < 1
      return

    $("#look-canvas").resizable({
      handles: 'e, s, se'
      #animate: true
    })

    $(".draggable" ).draggable(draggable_options)

    return

  set_position_change = (e) ->
    max_zindex += 1
    e.css('z-index', max_zindex)
    return

  set_draggable = (e) ->
    e.draggable(draggable_options)
    e.click -> set_position_change($(this))
    return

  $(document).on('page:change', set_look_canvas)

  $("#look-canvas").on("DOMNodeInserted", ".draggable", -> set_draggable($(this)) )

  $('.draggable').click -> set_position_change($(this))


