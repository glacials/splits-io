const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)
require('highcharts/highcharts-more')(Highcharts)
const moment = require('moment')

import {logoBlue} from '../colors.js'
import {quantile} from '../stats.js'

const buildBoxPlot = (run, chartOptions = {}) => {
  if (document.getElementById('box-plot') === null) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || run.default_timing
  const duration = `${timing}time_duration_ms`

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
      scrollablePlotArea: {minWidth: 75 * run.segments.length},
      zoomType: 'y'
    },
    colors: [logoBlue],
    subtitle: {text: 'Excludes Outliers'},
    legend: {enabled: false},
    plotOptions: {
      boxplot: {
        lineWidth: 2,
        fillColor: '#fff',
        whiskerColor: '#fff'
      }
    },
    series: [{
      data: run.segments.map(segment => {
        const histories = segment.histories.map(attempt => attempt[duration]).filter(duration => duration > 0)
        const q1 = quantile(histories, .25)
        const q3 = quantile(histories, .75)
        const iqr = q3 - q1 // interquartile range, used for finding outliers (below)
        const historiesSansOutliers = histories.filter(duration => duration >= (q1 - 1.5*iqr) && duration <= (q3 + 1.5*iqr))

        return {
          low:    Math.min(...historiesSansOutliers),
          q1:     q1,
          median: quantile(historiesSansOutliers, .5),
          q3:     q3,
          high:   Math.max(...historiesSansOutliers)
        }
      }),
      name: 'Segments',
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
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }},
      tickColor: 'rgba(255, 255, 255, 0.2)',
      title: {text: 'Segment Durations'}
    }
  })
}

export {buildBoxPlot}
