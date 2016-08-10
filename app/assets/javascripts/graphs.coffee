$ ->
  if gon.run.raw_splits?
    colors_obj = {}
    $(".timeline").children(".split").each (index) ->
      color = $(this).css("background-color")
      return if color is "rgba(0, 0, 0, 0)"
      colors_obj[$(this).children()[0].innerHTML] = color
    default_color = $(".timeline").children(".split").first().css("background-color")


    pb_graph_data = ["PB - Gold"]
    pb_graph_ticks = []
    $.each gon.run.splits, (i, split) ->
      time = d3.round(split.duration - split.best, 2)
      return if time <= 0
      pb_graph_data.push time
      pb_graph_ticks.push split.name
    pb_graph = c3.generate({
      bindto: "#pb-graph",
      title: { text: "PB vs Golds" },
      data: {
        columns: [pb_graph_data],
        type: "bar",
        color: (color, d) -> return default_color
      },
      axis: {
        x: {
          type: "category",
          categories: pb_graph_ticks,
          tick: {
            rotate: -45,
            multiline: false
          },
          height: 80
        },
        y: {
          label: {
            text: "Possible Time Save",
            position: "outer-middle"
          },
          tick: {
            format: (d) -> return d + "s"
          }
        }
      },
      legend: { hide: true }
    })

    if gon.run.program isnt "livesplit"
      return

    split_history_data = ["Mean - Gold"]
    split_history_ticks = []
    $.each gon.run.raw_splits, (i, split) ->
      if split.history is [] or split.history is null
        return
      time = d3.round(d3.mean(split.history) - split.best, 2)
      return if time <= 0
      split_history_data.push time
      split_history_ticks.push split.name
    c3.generate({
      bindto: "#split-history-graph",
      title: { text: "Split History Mean vs Golds" },
      data: {
        columns: [split_history_data],
        type: "bar",
        color: (color, d) -> return default_color
      },
      axis: {
        x: {
          type: "category",
          categories: split_history_ticks,
          tick: {
            rotate: -45,
            multiline: false
          },
          height: 80
        },
        y: {
          label: {
            text: "Possible Time Save",
            position: "outer-middle"
          },
          tick: {
            format: (d) -> return d + "s"
          }
        }
      },
      legend: { hide: true }
    })

    duration_data = gon.run.history.map((time) -> return time)
    duration_data.unshift "Run Length"
    c3.generate({
      bindto: "#run-duration-graph",
      title: { text: "Run Duration Over Time" }
      data: {
        columns: [duration_data],
        color: (color, d) -> return default_color
      },
      axis: {
        x: {
          type: "category",
          categories: index + 1 for split, index in gon.run.history,
          tick: {
            culling: true,
            multiline: false
          }
        },
        y: {
          label: {
            text: "Duration of Run",
            position: "outer-middle"
          },
          tick: {
            format: (d) -> moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
          }
        }
      },
      legend: { hide: true }
    })


    seg_histories = []
    $.each gon.run.raw_splits, (i, split) ->
      seg_histories.push JSON.parse(JSON.stringify(split.history))
      seg_histories[i].unshift split.name
    c3.generate({
      bindto: "#segment-duration-graph",
      title: { text: "Segment Histories Over Time"},
      data: {
        columns: seg_histories,
        color: (color, d) -> return if d.id then colors_obj[d.id] else colors_obj[d]
      }
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
        color: (color, d) -> return if d.id then color else colors_obj[d]
      },
      donut: {
        title: "Resets/Split",
        label: { format: (v) -> return v }
      },
      tooltip: {
        format: { value: (value, ratio) -> return "#{value} | #{d3.round(ratio * 100, 1)}%" }
      }
    })
