// In webpack.config.js
const path = require("path");
const { VueLoaderPlugin } = require("vue-loader");

// Extracts CSS into .css file
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require("webpack-remove-empty-scripts");

const mode =
  process.env.NODE_ENV === "development" ? "development" : "production";

module.exports = {
  mode,
  optimization: { moduleIds: "deterministic" },
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
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [
          {
            loader: "import-meta-loader",
            options: {
              // isVite2: true,
              // alias: {}
            },
          },
        ],
      },
      {
        test: /\.(?:sa|sc|c)ss$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
      },
      {
        test: /\.vue$/,
        loader: "vue-loader",
      },
    ],
  },
  output: {
    path: path.resolve(__dirname, "app/assets/build"),
  },
  resolve: {
    // Add additional file types
    extensions: [".js", ".jsx", ".scss", ".css", ".vue"],
  },
  plugins: [
    // Include plugins
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new VueLoaderPlugin(),
  ],
};
