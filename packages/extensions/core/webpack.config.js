// @ts-check

const path = require("path");
const nodeExternals = require("webpack-node-externals");
const baseWebpackConfig = require("../../../common/config/webpack.base.config");

/**
 * @type {import("webpack").Configuration}
 */
module.exports = {
  ...baseWebpackConfig,
  entry: {
    "app": "./src/app.ts",
    "exports": "./src/exports.ts",
    "language-service": "./src/language-service/language-service.ts",
  },
  output: {
    ...baseWebpackConfig.output,
    path: path.resolve(__dirname, "dist"),
    library: "AutoRestCore",
    libraryTarget: "commonjs2",
  },
  externals: [
    nodeExternals({
      allowlist: [/^(?:(?!jsonpath|@azure-tools\/extension).)*$/],
    }),
  ],
  plugins: [],
};
