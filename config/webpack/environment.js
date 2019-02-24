const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.config.set('resolve.alias', {
  handlebars: 'handlebars/dist/handlebars.js'
})

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    Popper: ['popper.js', 'default'],
    moment: 'moment',
    underscore: 'underscore',
    clipboard: 'clipboard'
  })
)

environment.loaders.append('expose', {
  test: require.resolve('jquery'),
  use: [{
    loader: 'expose-loader',
    options: '$'
  }, {
    loader: 'expose-loader',
    options: 'jQuery'
  }, {
    loader: 'expose-loader',
    options: 'jquery'
  }]
})

module.exports = environment
