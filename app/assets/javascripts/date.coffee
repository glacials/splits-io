$ ->
  $(".upload-date.needs-formatting").each (i, el) ->
    $(el).removeClass("needs-formatting")
    m = moment(el.innerHTML)
    el.innerHTML = m.fromNow()
