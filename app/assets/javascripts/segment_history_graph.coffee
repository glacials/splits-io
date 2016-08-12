$ ->
  if $("#segment-duration-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = []
  for sheet in document.styleSheets
    continue if not sheet.cssRules?
    for rule in sheet.cssRules
      for color in gon.run.colors
        if rule.selectorText? and color is rule.selectorText
          color_styles.push rule.style["background"]

  seg_histories = []
  $.each gon.run.raw_splits, (i, split) ->
    seg_histories.push JSON.parse(JSON.stringify(split.history))
    seg_histories[i].unshift split.name
  c3.generate({
    bindto: "#segment-duration-graph",
    title: { text: "Segment Histories Over Time"},
    data: {
      columns: seg_histories,
    },
    color: { pattern: color_styles },
    axis: {
      x: {
        type: "category",
        categories: index + 1 for split, index in gon.run.history
        tick: {
          culling: true,
          multiline: false
        }
      },
      y: {
        label: {
          text: "Duration of History",
          position: "outer-middle"
        },
        tick: {
          format: (d) -> moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
        }
      }
    }
  })
