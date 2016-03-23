$ ->
  $(".time.needs-formatting").each (i, el) ->
    $(el).removeClass("needs-formatting")
    seconds = Math.floor el.innerHTML
    negative = seconds < 0
    formatted = numeral(Math.abs seconds).format("+00:00:00")
    if formatted == '0:00:00'
      el.innerHTML = '-'
      return
    if !negative
      if $(el).hasClass "signed"
        el.innerHTML = "+" + formatted
      else
        el.innerHTML = formatted
    else if negative
      el.innerHTML = "-" + formatted
