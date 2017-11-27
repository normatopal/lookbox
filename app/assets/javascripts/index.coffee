ready = ->
  if (window.location.href.endsWith('#'))
    history.pushState({}, null, window.location.href.slice(0,-1));

  $(".sortable_tree a:not('.edit, .delete')").attr('data-remote', true)
  $("div[id^='flash_']").fadeOut(5000);

  $('[data-toggle="tooltip"]').tooltip();

  window.myCustomConfirmBox = (message, success_label, callback) ->
    bootbox.dialog
      message: message
      class: 'class-confirm-box'
      className: "my-modal"
      value: "makeusabrew"
      onEscape: () -> {}
      backdrop: true
      buttons:
        success:
          label: success_label
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
    success_label = if element.data("confirm-success-label") != undefined then element.data("confirm-success-label") else "OK"
    callback = undefined

    if $.rails.fire(element, "confirm")
      if element.closest('li').find('.nested_set').length > 0
        message += "<label for='delete_with_sub'> Destroy with subcategories </label>  <input type='checkbox' name='delete_with_sub' value='destroy'> "
      myCustomConfirmBox message, success_label, ->
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

$(document).on('keypress', '.lookbox-form', (e) ->
  if (e.keyCode == 13)
    return false
  return
).on('focus', "[data-behaviour~='datepicker']", (e) ->
 $(this).datepicker(format: "dd-mm-yyyy", weekStart: 1, autoclose: true, container: '.datepicker-container')
)

document.addEventListener "turbolinks:before-cache", ->
  $('.modal.in').hide()
  $('.modal-backdrop').hide()
  return

