// @ts-check

const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  testMatch: ["<rootDir>/src/**/*.spec.ts", "<rootDir>/test/**/*.spec.ts"],
};

module.exports = config;
