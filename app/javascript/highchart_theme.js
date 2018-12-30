'use strict'
import Highcharts from 'highcharts'
import {blue, purple, green, yellow, red, orange} from 'colors.js'

Highcharts.theme = {
  colors: [
    blue,
    purple,
    green,
    yellow,
    red,
    orange
  ],
  chart: {
    backgroundColor: 'none',
    style: {
     fontFamily: '"Helvetica Neue", Helvetica, Arial, sans-serif'
   },
   plotBorderColor: '#606063'
  },

  title: {
    style: {
      color: '#FFFFFF',
      fontSize: '20px'
    }
  },
  subtitle: {
    style: {
      color: '#E0E0E3',
    }
  },

  xAxis: {
    gridLineColor: '#707070',
    labels: {
      style: {
        color: '#FFFFFF'
      }
    },
    lineColor: '#707070',
    minorGridLineColor: '#505050',
    tickColor: '#707070',
    title: {
      style: {
        color: '#FFFFFF'
      }
    }
  },
  yAxis: {
    gridLineColor: '#707070',
    labels: {
      style: {
        color: '#FFF'
      }
    },
    lineColor: '#707070',
    minorGridLineColor: '#505053',
    tickColor: '#707070',
    tickWidth: 1,
    title: {
      style: {
        color: '#FFFFFF'
      }
    }
  },

  tooltip: {
    backgroundColor: 'rgba(0, 0, 0, 0.85)',
    style: {
      color: '#F0F0F0'
    }
  },

  plotOptions: {
    series: {
      dataLabels: {
        color: '#B0B0B3'
      },
      marker: {
        lineColor: '#333'
      }
    },
    boxplot: {
      fillColor: '#505053'
    },
    candlestick: {
      lineColor: 'white'
    },
    errorbar: {
      color: 'white'
    }
  },

  legend: {
    itemStyle: {
      color: '#E0E0E3'
    },
    itemHoverStyle: {
      color: '#FFF'
    },
    itemHiddenStyle: {
      color: '#606063'
    }
  },

  credits: {
    enabled: false
  },

  drilldown: {
    activeAxisLabelStyle: {
      color: '#F0F0F3'
    },
    activeDataLabelStyle: {
      color: '#F0F0F3'
    }
  },

  navigation: {
    buttonOptions: {
      symbolStroke: '#DDDDDD',
      theme: {
        fill: '#505053'
      }
    }
  },

   // scroll charts
  rangeSelector: {
    buttonTheme: {
      fill: '#505053',
      stroke: '#000000',
      style: {
        color: '#CCC'
      },
      states: {
        hover: {
          fill: '#707073',
          stroke: '#000000',
          style: {
            color: 'white'
          }
        },
        select: {
          fill: '#000003',
          stroke: '#000000',
          style: {
            color: 'white'
          }
        }
      }
    },
    inputBoxBorderColor: '#505053',
    inputStyle: {
      backgroundColor: '#333',
      color: 'silver'
    },
    labelStyle: {
      color: 'silver'
    }
  },

  navigator: {
    handles: {
      backgroundColor: '#666',
      borderColor: '#AAA'
    },
    outlineColor: '#CCC',
    maskFill: 'rgba(255,255,255,0.1)',
    series: {
      color: '#7798BF',
      lineColor: '#A6C7ED'
    },
    xAxis: {
      gridLineColor: '#505053'
    }
  },

  scrollbar: {
    barBackgroundColor: '#808083',
    barBorderColor: '#808083',
    buttonArrowColor: '#CCC',
    buttonBackgroundColor: '#606063',
    buttonBorderColor: '#606063',
    rifleColor: '#FFF',
    trackBackgroundColor: '#404043',
    trackBorderColor: '#404043'
  },

   // special colors for some of the
  legendBackgroundColor: 'rgba(0, 0, 0, 0.5)',
  background2: '#505053',
  dataLabelsColor: '#B0B0B3',
  textColor: '#C0C0C0',
  contrastTextColor: '#F0F0F3',
  maskColor: 'rgba(255,255,255,0.3)'
}

// Apply the theme
Highcharts.setOptions(Highcharts.theme)
