window.toggleDarkmode = ->
  if Cookies.get('darkmode') is '1'
    Cookies.remove('darkmode')
  else
    Cookies.set('darkmode', '1')
  location.reload()
