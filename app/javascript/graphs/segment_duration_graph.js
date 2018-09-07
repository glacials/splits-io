import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_segment_graph = function(segment) {
  const url = new URL(window.location.href)
  const duration_string = `${url.searchParams.get('timing') || gon.run.default_timing}time_duration_ms`

  let graph_data = []
  const non_zero_values = segment.histories.filter((attempt) => attempt[duration_string] > 0)
  graph_data.push({
    name: segment.name,
    data: non_zero_values.map(function(attempt) { return ['Attempt #' + attempt.attempt_number, attempt[duration_string]] }),
    pointStart: 1
  })

  Highcharts.chart('segment-graph-holder-' + segment.id, {
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
      borderRadius: 0,
      borderWidth: 0,
      plotBorderWidth: 0,
      zoomType: 'xy'
    },
    colors: ['#fff'],
    legend: {
      enabled: false
    },
    title: {
      text: 'Segment Duration over Time'
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
        return `<span style="color: #fff">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
      }
    },
    xAxis: {
      allowDecimals: false,
      lineColor: '#fff',
      title: {
        text: 'Attempt Number'
      }
    },
    yAxis: {
      gridLineColor: 'rgba(1, 1, 1, 0.3)',
      min: 0,
      tickColor: 'rgba(1, 1, 1, 0.3)',
      title: {
        text: 'Duration of Segment'
      },
      labels: {
        formatter: function() { return moment.utc(moment.duration(this.value).asMilliseconds()).format('H:mm:ss') }
      }
    },
    series: graph_data
  })
}

export {build_segment_graph}
