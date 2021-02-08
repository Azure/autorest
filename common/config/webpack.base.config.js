// @ts-check
const path = require("path");

/**
 * @type {import("webpack").Configuration}
 */
module.exports = {
  mode: "production",
  target: "node",
  devtool: "source-map",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "[name].js",
    devtoolModuleFilenameTemplate: "../../[resource-path]",
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".json"],
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: [
          {
            loader: "ts-loader",
            options: {
              configFile: "tsconfig.build.json",
            },
          },
        ],
      },
    ],
  },
  plugins: [],
  optimization: {
    minimize: false,
    moduleIds: "named",
    chunkIds: "named",
    mangleExports: false,
  },
};
