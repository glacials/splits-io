// In webpack.config.js
const path = require("path");
const { VueLoaderPlugin } = require("vue-loader");

// Extracts CSS into .css file
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require("webpack-remove-empty-scripts");
const { EnvironmentPlugin } = require("webpack");

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
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new VueLoaderPlugin(),
    new EnvironmentPlugin({
      PAYPAL_CLIENT_ID: "",
      PAYPAL_PLAN_ID: "",
      SPLITSIO_CLIENT_ID: "",
      STRIPE_PUBLISHABLE_KEY: "",
    }),
  ],
};
