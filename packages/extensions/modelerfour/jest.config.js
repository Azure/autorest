// @ts-check

const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  testMatch: ["<rootDir>/src/**/*.test.ts", "<rootDir>/test/**/*.test.ts"],
  setupFilesAfterEnv: ["<rootDir>/test/setupJest.ts"],
};

module.exports = config;
