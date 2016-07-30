ready = ->
  window.myCustomConfirmBox = (message,callback) ->
    chbox = "<label for='delete-with-sub'> Destroy with subcategories </label>  <input type='checkbox' name='delete_with_sub' value='destroy'> "
    bootbox.dialog
      message: message + chbox
      class: 'class-confirm-box'
      className: "my-modal"
      value: "makeusabrew"
      buttons:
        success:
          label: "Destroy"
          className: "btn-danger"
          callback: -> callback()
        chickenout:
          label: "Cancel"
          className: "btn-success pull-left"


  $.rails.allowAction = (element) ->
    message = element.data("confirm")
    return true  unless message

    answer = false
    callback = undefined



    if $.rails.fire(element, "confirm")
      myCustomConfirmBox message, ->
        callback = $.rails.fire(element, "confirm:complete", [answer])
        if $("input[name='delete_with_sub']").is(':checked')
          element[0].attributes['href'].value += "?delete_with_sub=true"
        if callback
          oldAllowAction = $.rails.allowAction
          $.rails.allowAction = ->
            true

          element.trigger "click"
          $.rails.allowAction = oldAllowAction
          #alert($("input[name='delete_with_sub']:checked").val())

    false


$(document).ready(ready)
$(document).on('page:load', ready)