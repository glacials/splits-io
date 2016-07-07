$ ->
  $(".time.needs-formatting").each (i, el) ->
    $(el).removeClass("needs-formatting")

    time = Number el.innerHTML
    sign = (if time < 0 then "-" else "+")
    time = Math.abs time

    s = Math.trunc time
    cs = Math.trunc((time - s) * 100)

    formatted = numeral(s).format("+00:00:00")
    if $(el).hasClass "short"
      $(el).removeClass "short"
      formatted += "." + ("00" + cs).substr(-2, 2)

    if formatted == '0:00:00.00'
      el.innerHTML = "-"
      return

    if $(el).hasClass "signed"
      $(el).removeClass "signed"
      el.innerHTML = sign + formatted
      return

    el.innerHTML = formatted
