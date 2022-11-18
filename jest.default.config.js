// @ts-check

const config = {
  transform: {
    "^.+\\.ts$": [
      "ts-jest",
      {
        tsconfig: "tsconfig.json",
      },
    ],
  },
  moduleFileExtensions: ["ts", "js", "json", "node"],
  moduleNameMapper: {},
  collectCoverage: true,
  collectCoverageFrom: ["src/**/*.ts", "!**/node_modules/**"],
  coverageReporters: ["json", "html", "cobertura"],
  coveragePathIgnorePatterns: ["/node_modules/", ".*/test/.*"],
  modulePathIgnorePatterns: ["<rootDir>/sdk"],
  setupFilesAfterEnv: [],
  verbose: true,
  testEnvironment: "node",
};

// Disable ts-jest warning because we are using alpha version of jest 28.x to resolve this issue https://github.com/facebook/jest/issues/9771
process.env.TS_JEST_DISABLE_VER_CHECKER = "1";

module.exports = config;
