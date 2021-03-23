// @ts-check

const path = require("path");
const baseWebpackConfig = require("../../../common/config/webpack.base.config");
const CopyPlugin = require("copy-webpack-plugin");

/**
 * @type {import("webpack").Configuration}
 */
module.exports = {
  ...baseWebpackConfig,
  entry: {
    "app": "./src/app.ts",
    "language-service": "./src/language-service/language-service.ts",
    "exports": "./src/exports.ts",
  },
  output: {
    ...baseWebpackConfig.output,
    path: path.resolve(__dirname, "dist"),
    libraryTarget: "commonjs2",
  },
  resolve: {
    ...baseWebpackConfig.resolve,
    alias: {
      jsonpath: path.resolve(__dirname, "node_modules", "jsonpath", "jsonpath.min.js"),
    },
  },
  plugins: [
    // We need to copy the yarn cli.js so @azure-tools/extensions can call the file as it is.(Not bundled in the webpack bundle.)
    new CopyPlugin({
      patterns: [{ from: "node_modules/@azure-tools/extension/dist/yarn/cli.js", to: "yarn/cli.js" }],
    }),

    // We need to copy the default configuration resources files.
    new CopyPlugin({
      patterns: [{ from: "node_modules/@autorest/configuration/resources", to: "resources" }],
    }),
  ],
  optimization: {
    ...baseWebpackConfig.optimization,
    // Makes sure the different endpoints don't duplicate share common code.
    splitChunks: {
      chunks: "all",
    },
  },
};
