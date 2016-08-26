ready = ->
  $(".sortable_tree a:not('.edit, .delete')").attr('data-remote', true)
  $("div[id^='flash_']").fadeOut(5000);

  $('[data-toggle="tooltip"]').tooltip();

  window.myCustomConfirmBox = (message,callback) ->
    bootbox.dialog
      message: message
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
    return true unless message

    #message = "Are you sure about removing? "
    answer = false
    callback = undefined

    if $.rails.fire(element, "confirm")
      if element.closest('li').find('.nested_set').length > 0
        message += "<label for='delete_with_sub'> Destroy with subcategories </label>  <input type='checkbox' name='delete_with_sub' value='destroy'> "
      myCustomConfirmBox message, ->
        callback = $.rails.fire(element, "confirm:complete", [answer])
        if $("input[name='delete_with_sub']").is(':checked')
          element[0].attributes['href'].value += "?delete_with_sub=destroy"
        if callback
          oldAllowAction = $.rails.allowAction
          $.rails.allowAction = ->
            true

          element.trigger "click"
          $.rails.allowAction = oldAllowAction

    false


$(document).ready(ready)
$(document).on('page:load', ready)