import {logoBlue} from '../colors.js'
import Highcharts from 'highcharts'
require('highcharts/modules/exporting')(Highcharts)
require('highcharts/highcharts-more')(Highcharts)

const buildBoxPlot = (run, chartOptions = {}) => {
  if (document.getElementById('box-plot') === null) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || run.default_timing
  const duration = `${timing}time_duration_ms`

  const asc = arr => arr.sort((a, b) => a - b)
  const sum = arr => arr.reduce((a, b) => a + b, 0)
  const mean = arr => sum(arr) / arr.length
  const quantile = (arr, q) => {
    const sorted = asc(arr)
    const pos = ((sorted.length) - 1) * q
    const base = Math.floor(pos)
    const rest = pos - base
    if ((sorted[base + 1] !== undefined)) {
      return sorted[base] + rest * (sorted[base + 1] - sorted[base])
    } else {
      return sorted[base]
    }
  }

  Highcharts.chart('box-plot', {
    exporting: {
      chartOptions: Object.assign(chartOptions, {
        plotOptions: {
          series: {
            dataLabels: {enabled: true}
          },
          line: {
            dataLabels: {
              enabled: true,
              formatter: () => this.x
            }
          }
        }
      }),
      fallbackToExportServer: false
    },
    chart: {
      type: 'boxplot',
      scrollablePlotArea: {
        minWidth: 75 * run.segments.length
      },
      zoomType: 'y'
    },
    colors: [logoBlue],
    legend: {enabled: false},
    plotOptions: {
      boxplot: {
        lineWidth: 2,
        fillColor: '#fff',
        whiskerColor: '#fff'
      }
    },
    series: [{
      name: 'Segments',
      data: run.segments.map(segment => {
        const histories = segment.histories.map(attempt => attempt[duration]).filter(duration => duration > 0)
        return {
          low:    Math.min(...histories),
          q1:     quantile(histories, .25),
          median: quantile(histories, .5),
          q3:     quantile(histories, .75),
          high:   Math.max(...histories)
        }
      }),
      tooltip: {
        pointFormatter: function() {
          return `Worst: ${moment.duration(this.high).format('H:mm:ss')}<br/>
            Upper quartile: ${moment.duration(this.q3).format('H:mm:ss')}<br/>
            Median: ${moment.duration(this.median).format('H:mm:ss')}<br/>
            Lower quartile: ${moment.duration(this.q1).format('H:mm:ss')}<br/>
            Best: ${moment.duration(this.low).format('H:mm:ss')}<br/>`
        }
      }
    }],
    title: {text: 'Segment Box Plot'},
    xAxis: {
      title: {text: 'Segment'},
      categories: run.segments.map(segment => segment.name)
    },
    yAxis: {
      labels: {
        formatter: function() { return moment.duration(this.value).format('H:mm:ss') }
      },
      title: {text: 'Segment Durations'},
      min: 0
    }
  })
}

export {buildBoxPlot}
