$ ->
  if gon.raw_run isnt `undefined`
    pb_graph_data = ["PB - Gold"]
    pb_graph_ticks = []
    $.each gon.run.splits, (i, split) ->
      time = split.duration - split.best
      if time > 5
        pb_graph_data.push d3.round(time, 2)
        pb_graph_ticks.push split.name
    pb_graph = c3.generate({
      bindto: "#pb-graph",
      title: { text: "PB vs Golds" },
      data: {
        columns: [pb_graph_data],
        type: "bar"
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

    if gon.raw_run.program isnt "livesplit"
      return

    split_history_data = ["Mean - Gold"]
    split_history_ticks = []
    $.each gon.raw_run.splits, (i, split) ->
      if split.history is [] or split.history is null
        return
      mean = d3.round(d3.mean(split.history) - split.best, 2)
      if mean < 5
        return
      split_history_data.push d3.round(d3.mean(split.history) - split.best, 2)
      split_history_ticks.push split.name
    c3.generate({
      bindto: "#split-history-graph",
      title: { text: "Split History Mean vs Golds" },
      data: {
        columns: [split_history_data],
        type: "bar"
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

    duration_data = gon.raw_run.history.map((time) -> return time)
    duration_data.unshift "Run Length"
    c3.generate({
      bindto: "#run-duration-graph",
      title: { text: "Run Duration Over Time" }
      data: { columns: [duration_data] },
      axis: {
        x: {
          tick: {
            culling: false
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
    $.each gon.raw_run.splits, (i, split) ->
      seg_histories.push split.history
      seg_histories[i].unshift split.name
    c3.generate({
      bindto: "#segment-duration-graph",
      title: { text: "Segment Histories Over Time"},
      data: { columns: seg_histories },
      axis: {
        x: {
          tick: {
            culling: false
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

    reset_counter = gon.raw_run.attempts
    reset_data = []
    $.each gon.raw_run.splits, (i, split) ->
      split_resets = reset_counter - split.history.length
      if split_resets > 0
        reset_data.push [split.name, split_resets]
        reset_counter = split.history.length
    c3.generate({
      bindto: "#reset-graph",
      data: {
        columns: reset_data,
        type: "donut"
      },
      donut: {
        title: "Resets/Split",
        label: { format: (v) -> return v }
      },
      tooltip: {
        format: { value: (value, ratio) -> return "#{value} | #{d3.round(ratio * 100, 1)}%" }
      }
    })
