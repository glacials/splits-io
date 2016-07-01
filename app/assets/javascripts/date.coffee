$ ->
  $(".upload-date.date-formatting").each (i, el) ->
    $(el).removeClass("date-formatting")
    m = moment(el.innerHTML)
    el.innerHTML = m.fromNow()
