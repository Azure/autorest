// @ts-check

const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  testMatch: ["<rootDir>/test/**/*.test.ts"],
};

module.exports = config;
