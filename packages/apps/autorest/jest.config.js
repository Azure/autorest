// @ts-check

/** @type {jest.InitialOptions} */
const config = {
  transform: {
    "^.+\\.ts$": "ts-jest",
  },
  moduleFileExtensions: ["ts", "js", "json", "node"],
  moduleNameMapper: {},
  collectCoverage: true,
  collectCoverageFrom: ["**/*.ts", "!**/node_modules/**", "!dist/**"],
  coverageReporters: ["json", "lcov", "cobertura", "text", "html", "clover"],
  coveragePathIgnorePatterns: ["/node_modules/", ".*/test/.*"],
  modulePathIgnorePatterns: ["<rootDir>/sdk"],
  globals: {
    "ts-jest": {
      tsconfig: "tsconfig.json",
    },
  },
  testMatch: ["<rootDir>/test/**/*.test.ts"],
  verbose: true,
  testEnvironment: "node",
};

module.exports = config;
