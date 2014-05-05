window.setTimeout (->
  $('.alert-success').slideUp(500, -> $(this).remove())
), 3000
