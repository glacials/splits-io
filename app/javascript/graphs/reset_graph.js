import Highcharts from 'highcharts';

$(function() {
  if ($("#reset-graph-highchart").length === 0 || gon.run.program !== "livesplit") {
    return;
  }

  let reset_counter = gon.run.attempts;
  let reset_data = [];

  gon.run.segments.forEach(function(segment, i) {
    if (reset_counter - segment.histories.length > 0) {
      reset_data.push([segment.name, reset_counter - segment.histories.length]);
      reset_counter = segment.histories.length;
    }
  });

  Highcharts.chart('reset-graph-highchart', {
    chart: {
      type: 'pie'
    },
    title: {
      text: 'Resets Per Split'
    },
    tooltip: {
      pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: {point.y} | {point.percentage:.1f}%',
    },
    plotOptions: {
      pie: {
        showInLegend: true,
        events: {
          afterAnimate: function() {
            let chart = this.chart;
            let legend = chart.legend;
            let tooltip = this.chart.tooltip;
            for (let item of legend.allItems) {
              item.legendItem.on('mouseover', function (e) {
                let data = item.series.data[item.index];
                tooltip.refresh(data);
              }).on('mouseout', function (e) {
                tooltip.hide();
              });
            }
          }
        }
      }
    },
    yAxis: {
      title: {
        text: 'Resets'
      }
    },
    series: [{
      name: 'Resets',
      data: reset_data,
      innerSize: '50%'
    }]
  });
});
