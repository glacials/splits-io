import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_segment_history_mean_graph = function(run) {
  if ($('#segment-history-graph-highchart').length === 0) {
    return
  }

  const url = new URL(window.location.href)
  const duration_string = `${url.searchParams.get('timing') || 'real'}time_duration_ms`
  const shortest_string = `${url.searchParams.get('timing') || 'real'}time_shortest_duration_ms`


  const graph_data = []
  run.segments.forEach(function(segment) {
    let time = 0
    if (segment.histories.length !== 0) {
      const non_zero_values = segment.histories.filter(attempt => attempt[duration_string] > 0)
      time = non_zero_values.map((attempt) => attempt[duration_string]).reduce((a, b) => a + b, 0) / non_zero_values.length
      time = (time - segment[shortest_string]) / 1000
    }
    graph_data.push([segment.name, time])
  })

  Highcharts.chart('segment-history-graph-highchart', {
    exporting: {
        chartOptions: {
            plotOptions: {
                series: {
                    dataLabels: {
                        enabled: true
                    }
                }
            }
        },
        fallbackToExportServer: false
    },
    chart: {
      type: 'column',
      zoomType: 'x'
    },
    title: {
      text: 'Split History Mean vs Golds'
    },
    subtitle: {
      text: 'Calculated: (Mean Of Each Segment\'s History - Segment Gold)'
    },
    tooltip: {
      pointFormat: 'Time Save: {point.y:.1f}s',
      shared: true
    },
    legend: {
      enabled: false
    },
    xAxis: {
      categories: graph_data.map(function(seg) { return seg[0] }),
      crosshair: true
    },
    yAxis: {
      title: {
        text: 'Possible Time Save (s)'
      }
    },
    series: [{
      name: 'History Mean - Gold',
      data: graph_data
    }]
  })
}

export {build_segment_history_mean_graph}
