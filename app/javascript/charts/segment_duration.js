import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const buildSegmentDurationChart = function(timing, segment, chartOptions) {
  if (document.getElementById(`segment-duration-chart-${segment.id}`) === null) {
    return
  }

  const duration = `${timing}time_duration_ms`

  Highcharts.chart(`segment-duration-chart-${segment.id}`, {
    exporting: {enabled: false},
    chart: {
      borderRadius: 0,
      borderWidth: 0,
      plotBorderWidth: 0,
      type: 'spline',
      zoomType: 'xy'
    },
    colors: ['#fff'],
    legend: {enabled: false},
    plotOptions: {
      series: {connectNulls: true},
      spline: {
        marker: {enabled: false}
      }
    },
    series: [{
      name: segment.name,
      data: segment.histories.filter(attempt => attempt[duration] > 0).map(attempt => {
        return [`Attempt #${attempt.attempt_number}`, attempt[duration]]
      }),
      pointStart: 1
    }],
    title: {text: undefined},
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        let time = moment.duration(this.y).format('H:mm:ss')
        return `<span style="color: #fff">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
      }
    },
    xAxis: {
      allowDecimals: false,
      lineColor: '#fff',
      title: {text: 'Attempt Number'}
    },
    yAxis: {
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }},
      tickColor: 'rgba(255, 255, 255, 0.2)',
      title: {text: 'Duration of Segment'}
    }
  })
}

export {buildSegmentDurationChart}
