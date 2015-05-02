$ ->
  if !$('#follows').length
    return false
  $.get '/users/' + gon.user.name + '/follows', (data, status) ->
    if status == 'success'
      $('#follows').append data
