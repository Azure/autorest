import { resolveDotnetRequirement } from "./dotnet";
import { execute } from "../exec-cmd";

jest.mock("../exec-cmd");

const mockExecute = execute as jest.Mock;

const mockDotnetVersionResult = (version: string) => mockExecute.mockResolvedValue({ stdout: version });

describe("Dotnet System Requirements", () => {
  beforeEach(() => {
    mockExecute.mockReset();
  });

  describe("when not requesting any specific version", () => {
    it("succeed if dotnet is installed", async () => {
      mockDotnetVersionResult("1.2.3");
      expect(await resolveDotnetRequirement({})).toEqual({ command: "dotnet", name: "dotnet" });
    });

    it("return error if dotnet is not found", async () => {
      mockExecute.mockRejectedValue(new Error("ENOENT"));
      expect(await resolveDotnetRequirement({})).toEqual({
        error: true,
        name: "dotnet",
        command: "dotnet",
        message: "'dotnet' command line is not found in the path. Make sure to have dotnet installed.",
      });
    });
  });

  describe("when not requesting a specific version", () => {
    it("return error if dotnet is not found", async () => {
      mockExecute.mockRejectedValue(new Error("ENOENT"));
      expect(await resolveDotnetRequirement({ version: ">3.1" })).toEqual({
        error: true,
        name: "dotnet",
        command: "dotnet",
        message: "'dotnet' command line is not found in the path. Make sure to have dotnet installed.",
      });
    });

    it("succeed if dotnet is installed with the same version", async () => {
      mockDotnetVersionResult("3.1.0");
      expect(await resolveDotnetRequirement({ version: ">=3.1" })).toEqual({ command: "dotnet", name: "dotnet" });
    });

    it("succeed if dotnet is installed with the same version but beta tag", async () => {
      mockDotnetVersionResult("3.1.0-beta.1");
      expect(await resolveDotnetRequirement({ version: ">=3.1.0" })).toEqual({ command: "dotnet", name: "dotnet" });
    });

    it("error if dotnet is installed with an older version than requested", async () => {
      mockDotnetVersionResult("3.0.8");
      expect(await resolveDotnetRequirement({ version: ">=3.1" })).toEqual({
        error: true,
        actualVersion: "3.0.8",
        message: "'dotnet' version is '3.0.8' but doesn't satisfy requirement '>=3.1'. Please update.",
        name: "dotnet",
        command: "dotnet",
        neededVersion: ">=3.1",
      });
    });
  });
});
