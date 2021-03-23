import { patchPythonPath, PythonCommandLine, resolvePythonRequirement, updatePythonPath } from "./python";
import { execute } from "../exec-cmd";

jest.mock("../exec-cmd");

const mockExecute = execute as jest.Mock;

const mockInstalledPython = (map: { [pythonCmd: string]: string }) => {
  mockExecute.mockImplementation(async (cmd) => {
    const expectedVersion = map[cmd];
    if (expectedVersion) {
      return { stdout: expectedVersion };
    } else {
      throw new Error("ENOENT");
    }
  });
};

describe("Python system requirement", () => {
  let originalPlatform: NodeJS.Platform;

  beforeAll(() => {
    originalPlatform = process.platform;
    Object.defineProperty(process, "platform", {
      value: "win32",
    });
  });

  afterAll(() => {
    Object.defineProperty(process, "platform", {
      value: originalPlatform,
    });
  });

  beforeEach(() => {
    mockExecute.mockReset();
  });

  it("returns all errors when no python is installed", async () => {
    mockInstalledPython({});
    const result = await resolvePythonRequirement({ version: ">=3.6" });
    expect(result).toEqual({
      command: "python",
      error: true,
      message: [
        "Couldn't find a valid python interpreter satisfying the requirement (version: >=3.6). Tried:",
        " - py ('py' command line is not found in the path. Make sure to have it installed.)",
        " - python3 ('python3' command line is not found in the path. Make sure to have it installed.)",
        " - python ('python' command line is not found in the path. Make sure to have it installed.)",
      ].join("\n"),
      name: "python",
    });
  });

  it("returns all errors when no python version has the right version", async () => {
    mockInstalledPython({
      python3: "3.4.0",
      python: "2.7.0",
    });
    const result = await resolvePythonRequirement({ version: ">=3.6" });
    expect(result).toEqual({
      command: "python",
      error: true,
      message: [
        "Couldn't find a valid python interpreter satisfying the requirement (version: >=3.6). Tried:",
        " - py ('py' command line is not found in the path. Make sure to have it installed.)",
        " - python3 ('python3' version is '3.4.0' but doesn't satisfy requirement '>=3.6'. Please update.)",
        " - python ('python' version is '2.7.0' but doesn't satisfy requirement '>=3.6'. Please update.)",
      ].join("\n"),
      name: "python",
    });
  });

  it("returns the first valid version it finds", async () => {
    mockInstalledPython({
      python3: "3.7.0",
      python: "3.9.0",
    });
    const result = await resolvePythonRequirement({ version: ">=3.6" });
    expect(result).toEqual({
      name: "python",
      command: "python3",
    });
  });

  describe("patchPythonPath", () => {
    it("stub with the only compatible python version", async () => {
      mockInstalledPython({
        python3: "3.7.0",
        python: "2.7.0",
      });
      const input: PythonCommandLine = ["python", "-c", "print();"];
      const result = await patchPythonPath(input, { version: ">=3.6" });
      expect(result).toEqual(["python3", "-c", "print();"]);
    });

    it("stub with the first compatible python version(python3 is 3.7)", async () => {
      mockInstalledPython({
        python3: "3.7.0",
        python: "3.9.0",
      });
      const input: PythonCommandLine = ["python", "-c", "print();"];
      const result = await patchPythonPath(input, { version: ">=3.6" });
      expect(result).toEqual(["python3", "-c", "print();"]);
    });

    it("stub with the first compatible python version(python3 is 2.0)", async () => {
      mockInstalledPython({
        python3: "2.0.0",
        python: "3.9.0",
      });
      const input: PythonCommandLine = ["python", "-c", "print();"];
      const result = await patchPythonPath(input, { version: ">=3.6" });
      expect(result).toEqual(["python", "-c", "print();"]);
    });
  });

  describe("updatePythonPath (Deprecated)", () => {
    it("stub with the only compatible python version(python3 is 3.7)", async () => {
      mockInstalledPython({
        python3: "3.7.0",
        python: "2.7.0",
      });
      const input: PythonCommandLine = ["python", "-c", "print();"];
      const result = await updatePythonPath(input);
      expect(input).toEqual(["python3", "-c", "print();"]);
      expect(result).toEqual(["python3", "-c", "print();"]);
    });

    it("stub with the first compatible python version(python3 is 3.7, python is 3.9)", async () => {
      mockInstalledPython({
        python3: "3.7.0",
        python: "3.9.0",
      });
      const input: PythonCommandLine = ["python", "-c", "print();"];
      const result = await updatePythonPath(input);
      expect(input).toEqual(["python3", "-c", "print();"]);
      expect(result).toEqual(["python3", "-c", "print();"]);
    });

    it("stub with the first compatible python version(python3 is 2.0)", async () => {
      mockInstalledPython({
        python3: "2.0.0",
        python: "3.9.0",
      });
      const input: PythonCommandLine = ["python", "-c", "print();"];
      const result = await updatePythonPath(input);
      expect(input).toEqual(["python", "-c", "print();"]);
      expect(result).toEqual(["python", "-c", "print();"]);
    });
  });
});
