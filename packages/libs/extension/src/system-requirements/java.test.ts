import { validateJavaRequirement } from "./java";
import { execute } from "../exec-cmd";

jest.mock("../exec-cmd");

const mockExecute = execute as jest.Mock;

const javaVersionTemplate = (version: string) => {
  return `java version "${version}"
Java(TM) SE Runtime Environment (build 1.8.0_281-b09)
Java HotSpot(TM) 64-Bit Server VM (build 25.281-b09, mixed mode`;
};

const mockJavaVersionResult = (version: string) =>
  mockExecute.mockResolvedValue({ stdout: javaVersionTemplate(version) });

describe("java System Requirements", () => {
  beforeEach(() => {
    mockExecute.mockReset();
  });

  describe("when not requesting any specific version", () => {
    it("succeed if java is installed", async () => {
      mockJavaVersionResult("1.8.0_281");
      expect(await validateJavaRequirement({})).toBeUndefined();
    });

    it("return error if java is not found", async () => {
      mockExecute.mockRejectedValue(new Error("ENOENT"));
      expect(await validateJavaRequirement({})).toEqual({
        name: "java",
        message: "java command line is not found in the path. Make sure to have java installed.",
      });
    });
  });

  describe("when not requesting a specific version", () => {
    it("return error if java is not found", async () => {
      mockExecute.mockRejectedValue(new Error("ENOENT"));
      expect(await validateJavaRequirement({ version: ">3.1" })).toEqual({
        name: "java",
        message: "java command line is not found in the path. Make sure to have java installed.",
      });
    });

    it("succeed if java is installed with the same version", async () => {
      mockJavaVersionResult("1.8.0_281");
      expect(await validateJavaRequirement({ version: ">=1.8" })).toBeUndefined();
    });

    it("error if java is installed with an older version than requested", async () => {
      mockJavaVersionResult("1.7.0_123");
      expect(await validateJavaRequirement({ version: ">=1.8" })).toEqual({
        actualVersion: "1.7.0_123",
        message: "System java version is '1.7.0_123' but doesn't satisfy requirement '>=1.8'. Please update.",
        name: "java",
        neededVersion: ">=1.8",
      });
    });
  });
});
