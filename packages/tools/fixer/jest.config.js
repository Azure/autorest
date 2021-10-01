// @ts-check

// eslint-disable-next-line node/no-unpublished-require
const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  testMatch: ["<rootDir>/src/**/*.test.ts", "<rootDir>/test/**/*.test.ts"],
};

module.exports = config;
