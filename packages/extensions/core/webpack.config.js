// @ts-check

const path = require("path");
const nodeExternals = require("webpack-node-externals");
const baseWebpackConfig = require("../../../common/config/webpack.base.config");

const coreBaseConfig = {
  ...baseWebpackConfig,
  output: {
    ...baseWebpackConfig.output,
    path: path.resolve(__dirname, "dist"),
  },
  externals: [
    nodeExternals({
      allowlist: [/^(?:(?!jsonpath|@azure-tools\/extension).)*$/],
    }),
  ],
};

/**
 * @type {import("webpack").Configuration}
 */
module.exports = [
  {
    ...coreBaseConfig,
    entry: {
      "app": "./src/app.ts",
      "language-service": "./src/language-service/language-service.ts",
    },
  },
  {
    ...coreBaseConfig,
    entry: {
      exports: "./src/exports.ts",
    },
    output: {
      ...coreBaseConfig.output,
      path: path.resolve(__dirname, "dist"),
      library: "AutoRestCore",
      libraryTarget: "commonjs2",
    },
  },
];
