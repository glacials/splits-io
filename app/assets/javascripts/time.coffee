$ ->
  $(".time").each (i, el) ->
    seconds = Math.floor el.innerHTML
    negative = seconds < 0
    formatted = numeral(Math.abs seconds).format("+00:00:00")
    if !negative
      if $(el).hasClass "signed"
        el.innerHTML = "+" + formatted
      else
        el.innerHTML = formatted
    else if negative
      el.innerHTML = "-" + formatted
