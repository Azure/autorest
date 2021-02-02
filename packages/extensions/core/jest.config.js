// @ts-check

const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  setupFilesAfterEnv: ["<rootDir>/test/setupJest.ts"],
  testMatch: ["<rootDir>/test/**/*.test.ts"],
  globals: {
    "ts-jest": {
      tsconfig: "tsconfig.json",
      diagnostics: {
        pathRegex: /\.test\.ts$/,
      },
    },
  },
};

module.exports = config;
