process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const { environment } = require('@rails/webpacker')  // Import environment from @rails/webpacker

module.exports = environment.toWebpackConfig()  // Export the Webpack configuration
