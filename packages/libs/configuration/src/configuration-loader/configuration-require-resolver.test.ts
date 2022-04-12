import { IFileSystem, MemoryFileSystem } from "@azure-tools/datastore";
import { createConfigFromRawConfig } from "../autorest-configuration";
import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { getIncludedConfigurationFiles } from "./configuration-require-resolver";

const configFile1 = "foo.md";
const configFile2 = "bar.md";

const defaultConfig = { "base-folder": "file://.", "output-folder": "./generated" };
describe("getIncludedConfigurationFiles", () => {
  let fs: IFileSystem;

  const getRequiredFiles = async (raw: AutorestNormalizedConfiguration) => {
    const result: string[] = [];

    const config = createConfigFromRawConfig(".", { ...defaultConfig, ...raw }, []);
    const gen = getIncludedConfigurationFiles(() => Promise.resolve(config), fs, new Set());

    for await (const req of gen) {
      result.push(req);
    }
    return result;
  };

  beforeEach(async () => {
    const files = new Map().set(`file://./${configFile1}`, "Content").set(`file://./${configFile2}`, "Content");
    fs = new MemoryFileSystem(files);
  });

  describe("when using require", () => {
    it("resolve simple required files", async () => {
      const result = await getRequiredFiles({ require: ["foo.md", "bar.md"] });
      expect(result).toEqual(["file://./foo.md", "file://./bar.md"]);
    });

    it("still resolve file path if they don't exists", async () => {
      const result = await getRequiredFiles({ require: ["doesnot-exists.md"] });
      expect(result).toEqual(["file://./doesnot-exists.md"]);
    });

    it("resolve duplicate require only once", async () => {
      const result = await getRequiredFiles({ require: ["foo.md", "bar.md", "foo.md", "bar.md"] });
      expect(result).toEqual(["file://./foo.md", "file://./bar.md"]);
    });
  });

  describe("when using try-require", () => {
    it("only resolve file that exists when using", async () => {
      const result = await getRequiredFiles({ "try-require": ["foo.md", "bar.md", "doesnot-exists.md"] });
      expect(result).toEqual(["file://./foo.md", "file://./bar.md"]);
    });
  });
});
