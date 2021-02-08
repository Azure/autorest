const path = require("path");

// @ts-check
const baseWebpackConfig = require("../../../common/config/webpack.base.config");

/**
 * @type {import("webpack").Configuration}
 */
module.exports = {
  ...baseWebpackConfig,
  entry: {
    app: "./src/app.ts",
    exports: "./src/exports.ts",
  },
  output: {
    ...baseWebpackConfig.output,
    path: path.resolve(__dirname, "dist"),
  },
};
