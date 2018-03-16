import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_segment_duration_graph = function(run) {
  if ($('#segment-duration-graph-highchart').length === 0) {
    return
  }

  const url = new URL(window.location.href)
  const duration_string = `${url.searchParams.get('timing') || 'real'}time_duration_ms`

  let graph_data = []
  run.segments.forEach(function(segment) {
    const non_zero_values = segment.histories.filter((attempt) => attempt[duration_string] > 0)
    graph_data.push({
      name: segment.name,
      data: non_zero_values.map(function(attempt) { return [attempt.attempt_number, attempt[duration_string]] }),
      visible: false,
      pointStart: 1
    })
  })
  graph_data[0].visible = true

  Highcharts.chart('segment-duration-graph-highchart', {
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
      zoomType: 'x'
    },
    title: {
      text: 'Segment Durations Over Time'
    },
    plotOptions: {
      series: {
        connectNulls: true
      }
    },
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        let time = moment.utc(moment.duration(this.y).asMilliseconds()).format('H:mm:ss')
        return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
      }
    },
    xAxis: {
      title: {
        text: 'Attempt Number'
      }
    },
    yAxis: {
      title: {
        text: 'Duration of History'
      },
      labels: {
        formatter: function() { return moment.utc(moment.duration(this.value).asMilliseconds()).format('H:mm:ss') }
      }
    },
    series: graph_data
  })
}

export {build_segment_duration_graph}
