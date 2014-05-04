$('tr[href]').click(->
  window.document.location = $(this).attr('href')
)
