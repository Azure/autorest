import { getExecutablePath } from "./common";

describe("System requirement common", () => {
  describe("getExecutablePath", () => {
    afterEach(() => {
      delete process.env["MY_CUSTOM_TEST_PATH"];
    });

    it("returns path described in env", () => {
      process.env["MY_CUSTOM_TEST_PATH"] = "/path/to/exe";

      expect(getExecutablePath({ environmentVariable: "MY_CUSTOM_TEST_PATH" })).toEqual("/path/to/exe");
    });

    it("returns undefined if environment is not set described in env", () => {
      expect(getExecutablePath({ environmentVariable: "MY_CUSTOM_TEST_PATH" })).toBeUndefined();
    });

    it("returns undefined if requirement doesn't specify an environment variable name", () => {
      process.env["MY_CUSTOM_TEST_PATH"] = "/path/to/exe";

      expect(getExecutablePath({})).toBeUndefined();
    });
  });
});
