$(document).on('mouseenter', '#look-canvas', ->

  drag_start = (e) ->
    #$(this).css('z-index', 1)
    return


  $(".draggable" ).draggable({
    start: drag_start
    stop: (event, ui) ->
      look_position_element = $('#' + this.id + '-position')
      look_position_element.find($("input[id$='position_top']")).get(0).value = ui.position["top"]
      look_position_element.find($("input[id$='position_left']")).get(0).value = ui.position["left"]
      return
    stack: ".draggable"
  })
  return
)