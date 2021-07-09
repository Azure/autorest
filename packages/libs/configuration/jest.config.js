// @ts-check

const defaultConfig = require("../../../jest.default.config");

const config = {
  ...defaultConfig,
  setupFilesAfterEnv: ["<rootDir>/test/setup-jest.ts"],
  testMatch: ["<rootDir>/src/**/*.test.ts", "<rootDir>/test/**/*.test.ts"],
};

module.exports = config;
