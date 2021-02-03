// @ts-check

const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  setupFilesAfterEnv: ["<rootDir>/test/setupJest.ts"],
  testMatch: ["<rootDir>/test/**/*.test.ts", "<rootDir>/src/**/*.test.ts"],
};

module.exports = config;
