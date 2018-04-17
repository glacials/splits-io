const { environment } = require('@rails/webpacker')
const merge = require('webpack-merge')
const webpack = require('webpack')

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    Popper: ['popper.js', 'default'],
    moment: 'moment',
    d3: 'd3',
    c3: 'c3',
    underscore: 'underscore',
    clipboard: 'clipboard',
    tipsy: 'tipsy',
    "jquery.turbolink": "jquery.turbolinks",
    "bootstrap-toggle": "bootstrap-toggle"
  })
)

const envConfig = module.exports = environment
const aliasConfig = module.exports = {
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery',
      clipboard: 'clipboard/dist/clipboard',
      tipsy: 'tipsy/src/javascripts/jquery.tipsy',
      "jquery.turbolinks": 'jquery.turbolinks/vendor/assets/javascripts/jquery.turbolinks',
      "bootstrap-toggle": 'bootstrap-toggle/js/bootstrap-toggle'
    }
  }
}

module.exports = merge(envConfig.toWebpackConfig(), aliasConfig)
