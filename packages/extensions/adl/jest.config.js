// @ts-check

import defaultConfig from "../../../jest.default.config.js";

const config = {
  ...defaultConfig,
  testMatch: ["<rootDir>/src/**/*.test.ts", "<rootDir>/test/**/*.test.ts"],
};

export default config;
