// @ts-check
const path = require("path");
const baseWebpackConfig = require("../../../common/config/webpack.base.config");

/**
 * @type {import("webpack").Configuration}
 */
module.exports = {
  ...baseWebpackConfig,
  entry: {
    main: "./src/main.ts",
  },
  output: {
    ...baseWebpackConfig.output,
    path: path.resolve(__dirname, "dist"),
  },
  resolve: {
    ...baseWebpackConfig.resolve,
    alias: {
      jsonpath: path.resolve(__dirname, "node_modules", "jsonpath", "jsonpath.min.js"),
    },
  },
};
