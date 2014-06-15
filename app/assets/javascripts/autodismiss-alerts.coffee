window.setTimeout (->
  $('.alert-success').animate width: '0%', 400, ->
    $(this).remove()
), 2500
