import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const buildSegmentGraphs = function(run) {
  if (document.getElementById('segment-graphs') === null) {
    return
  }

  const url = new URL(window.location.href)
  const durationString = `${url.searchParams.get('timing') || 'real'}time_duration_ms`
  const shortestString = `${url.searchParams.get('timing') || 'real'}time_shortest_duration_ms`

  const pbData = []
  const meanData = []
  let resetCounter = run.attempts
  const resetData = []

  run.segments.forEach((segment, i) => {
    let time = (segment[durationString] - segment[shortestString]) / 1000
    if (time < 0) {
      time = 0
    }
    pbData.push([segment.name, time])

    time = 0
    let counter = 0
    if (segment.histories.length !== 0) {
      segment.histories.forEach((attempt) => {
        if (attempt[durationString] === 0) {
          return
        } else if (run.segments[i - 1] !== undefined) {
          const prevSegAttempt = run.segments[i - 1].histories.find((prevAttempt) => {
            return prevAttempt.attempt_number === attempt.attempt_number
          })
          if (prevSegAttempt !== undefined && prevSegAttempt[durationString] === 0) {
            return
          }
        }

        time += attempt[durationString]
        counter++
      })

      time = ((time / counter) - segment[shortestString]) / 1000
    }
    meanData.push([segment.name, time])

    resetData.push([segment.name, (1 - (segment.histories.length / resetCounter)) * 100])
    resetCounter = segment.histories.length
  })

  Highcharts.chart('segment-graphs', {
    exporting: {
      chartOptions: {
        plotOptions: {
          series: {
            dataLabels: {enabled: true}
          }
        }
      },
      fallbackToExportServer: false
    },
    chart: {
      type: 'column',
      zoomType: 'x'
    },
    title: {text: 'Individual Segment Stats'},
    subtitle: {text: '(PB - Gold) | (Average - Gold) | (1 - (Finished Attempts / Total Attempts))'},
    tooltip: {
      shared: true,
      pointFormat: ''
    },
    legend: {enabled: false},
    xAxis: {
      categories: pbData.map(function(seg) { return seg[0] }),
      crosshair: true
    },
    yAxis: [{
      title: {text: 'Possible Time Save (s)'}
    }, {
      title: {text: 'Reset Attempts Per Split (%)'},
      min: 0,
      max: 100,
      opposite: true
    }],
    series: [{
      name: 'PB - Gold',
      data: pbData,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.1f}s</b><br/>'
      }
    }, {
      name: 'History Mean - Gold',
      data: meanData,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.1f}s</b><br/>'
      }
    }, {
      name: 'Resets',
      data: resetData,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.1f}%</b><br/>'
      }
    }]
  })
}

export {buildSegmentGraphs}
