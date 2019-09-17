const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)
require('highcharts/highcharts-more')(Highcharts)

const defaults = require('deep-defaults')
const moment = require('moment')

import {logoColors} from '../colors.js'
import {quantile} from '../stats.js'

const buildBoxPlot = (runs, options = {}) => {
  if (document.getElementById('box-plot') === null) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || runs[0].default_timing
  const duration = `${timing}time_duration_ms`

  Highcharts.chart('box-plot', defaults(_.clone(options), {
    exporting: {
      chartOptions: {
        plotOptions: {
          series: {
            dataLabels: {enabled: false}
          },
          line: {
            dataLabels: {
              enabled: false
            }
          }
        }
      }
    },
    chart: {
      type: 'boxplot',
      scrollablePlotArea: {minWidth: 75 * runs[0].segments.length},
      zoomType: 'xy'
    },
    colors: logoColors,
    subtitle: {text: 'Excludes Outliers'},
    plotOptions: {
      boxplot: {
        lineWidth: 2,
      }
    },
    series: runs.map(run => ({
      data: run.segments.map(segment => {
        const histories = segment.filteredHistories.map(attempt => attempt[duration])
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
      name: (run.runners[0] || {name: '???'}).name,
      tooltip: {
        pointFormatter: function() {
          return `Worst: ${moment.duration(this.high).format('H:mm:ss')}<br/>
            Upper quartile: ${moment.duration(this.q3).format('H:mm:ss')}<br/>
            Median: ${moment.duration(this.median).format('H:mm:ss')}<br/>
            Lower quartile: ${moment.duration(this.q1).format('H:mm:ss')}<br/>
            Best: ${moment.duration(this.low).format('H:mm:ss')}<br/>`
        }
      }
    })),
    title: {text: 'Segment Box Plot'},
    xAxis: {
      title: {text: 'Segment'},
      categories: runs[0].segments.map(segment => segment.display_name)
    },
    yAxis: {
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }},
      tickColor: 'rgba(255, 255, 255, 0.2)',
      title: {text: 'Segment Durations'}
    }
  }))
}

export {buildBoxPlot}
