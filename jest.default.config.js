// @ts-check

const config = {
  transform: {
    "^.+\\.ts$": "ts-jest",
  },
  moduleFileExtensions: ["ts", "js", "json", "node"],
  moduleNameMapper: {},
  collectCoverage: true,
  collectCoverageFrom: ["src/**/*.ts", "!**/node_modules/**"],
  coverageReporters: ["json", "html", "cobertura"],
  coveragePathIgnorePatterns: ["/node_modules/", ".*/test/.*"],
  modulePathIgnorePatterns: ["<rootDir>/sdk"],
  globals: {
    "ts-jest": {
      tsconfig: "tsconfig.json",
    },
  },
  setupFilesAfterEnv: [],
  verbose: true,
  testEnvironment: "node",
};

module.exports = config;
