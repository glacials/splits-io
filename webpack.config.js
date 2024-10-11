// In webpack.config.js

// Extracts CSS into .css file
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require("webpack-remove-empty-scripts");

module.exports = {
  entry: {
    // add your css or sass entries
    application: [
      "./app/javascript/application.js",
      "./app/assets/stylesheets/application.sass",
    ],
    // custom: "./app/assets/stylesheets/custom.scss",
  },
  module: {
    rules: [
      // Add CSS/SASS/SCSS rule with loaders
      {
        test: /\.(?:sa|sc|c)ss$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
      },
    ],
  },
  resolve: {
    // Add additional file types
    extensions: [".js", ".jsx", ".scss", ".css"],
  },
  plugins: [
    // Include plugins
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
  ],
};
