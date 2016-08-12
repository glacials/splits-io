$ ->
  if $("#reset-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = []
  for sheet in document.styleSheets
    continue if not sheet.cssRules?
    for rule in sheet.cssRules
      for color in gon.run.colors
        if rule.selectorText? and color is rule.selectorText
          color_styles.push rule.style["background"]

  reset_counter = gon.run.attempts
  reset_data = []
  $.each gon.run.raw_splits, (i, split) ->
    split_resets = reset_counter - split.history.length
    if split_resets > 0
      reset_data.push [split.name, split_resets]
      reset_counter = split.history.length
  c3.generate({
    bindto: "#reset-graph",
    data: {
      columns: reset_data,
      type: "donut",
    },
    color: { pattern: color_styles },
    donut: {
      title: "Resets/Split",
      label: { format: (v) -> return v }
    },
    tooltip: {
      format: { value: (value, ratio) -> return "#{value} | #{d3.round(ratio * 100, 1)}%" }
    }
  })
