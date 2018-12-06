const merge = require('webpack-merge')
const environment = require('./environment')

const config = environment.toWebpackConfig()
config.devtool = 'sourcemap'

module.exports = config
