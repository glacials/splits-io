import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_pb_graph = function(run) {
  if ($('#pb-graph-highchart').length === 0) {
    return
  }

  const url = new URL(window.location.href)
  const duration_string = `${url.searchParams.get('timing') || 'real'}time_duration_ms`
  const shortest_string = `${url.searchParams.get('timing') || 'real'}time_shortest_duration_ms`

  let graph_data = []
  run.segments.forEach(function(segment, i) {
    let time = (segment[duration_string] - segment[shortest_string]) / 1000
    if (time < 0) {
      time = 0
    }

    graph_data.push([segment.name, time])
  })

  Highcharts.chart('pb-graph-highchart', {
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
      text: 'PB vs Golds'
    },
    subtitle: {
      text: 'Calculated: PB - Gold'
    },
    tooltip: {
      pointFormat: 'Time Save: {point.y:.1f}s',
      shared: true
    },
    legend: {
      enabled: false
    },
    xAxis: {
      categories: graph_data.map(function(seg) { return seg[0]; }),
      crosshair: true
    },
    yAxis: {
      title: {
        text: 'Possible Time Save (s)'
      }
    },
    series: [{
      name: 'PB - Gold',
      data: graph_data
    }]
  })
}

export {build_pb_graph}
