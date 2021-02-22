import { MemoryFileSystem } from "@azure-tools/datastore";
import { AutorestConfiguration } from "../autorest-configuration";
import { ConfigurationManager } from "./configuration-manager";

describe("ConfigurationManager", () => {
  let manager: ConfigurationManager;
  let fs: MemoryFileSystem;

  beforeEach(() => {
    fs = new MemoryFileSystem(new Map());
    manager = new ConfigurationManager("/dev/path", fs);
  });

  it("adds a single config", async () => {
    await manager.addConfig({
      "output-folder": "generated",
      "api-version": ["1234-56-78"],
    });

    const output = await manager.resolveConfig();
    expect(output["output-folder"]).toEqual("generated");
    expect(output["api-version"]).toEqual(["1234-56-78"]);
  });

  describe("when joining 2 simple config", () => {
    let output: AutorestConfiguration;

    beforeEach(async () => {
      await manager.addConfig({
        "output-folder": "generated-1",
        "api-version": ["version-1"],
      });
      await manager.addConfig({
        "output-folder": "generated-2",
        "api-version": ["version-2"],
        "base-folder": "base-folder-2",
      });

      output = await manager.resolveConfig();
    });

    it("keeps first config value", async () => {
      expect(output["output-folder"]).toEqual("generated-1");
    });

    it("combines array values", async () => {
      expect(output["api-version"]).toEqual(["version-1", "version-2"]);
    });

    it("adds value from 2nd config if not present in 1st", async () => {
      expect(output["base-folder"]).toEqual("base-folder-2");
    });
  });

  describe("adding a single file with multiple blocks", () => {
    it("override values with blocks defined later", async () => {
      await manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              "output-folder": "generated-1",
              "api-version": ["version-1"],
              "base-folder": "base-folder-1",
            },
          },
          {
            config: {
              "output-folder": "generated-2",
              "api-version": ["version-2"],
            },
          },
        ],
      });

      const output = await manager.resolveConfig();
      expect(output["output-folder"]).toEqual("generated-2");
      expect(output["base-folder"]).toEqual("base-folder-1");
      expect(output["api-version"]).toEqual(["version-2", "version-1"]);
    });

    it("use condition from previous blocks", async () => {
      await manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              "output-folder": "generated-1",
              "api-version": ["version-1"],
              "base-folder": "base-folder-1",
            },
          },
          {
            condition: "yaml $(output-folder) !== 'generated-1'",
            config: {
              "output-folder": "generated-2",
              "api-version": ["version-2"],
            },
          },
          {
            condition: "yaml $(output-folder) === 'generated-1'",
            config: {
              "api-version": ["version-3"],
            },
          },
        ],
      });

      const output = await manager.resolveConfig();
      expect(output["output-folder"]).toEqual("generated-1");
      expect(output["base-folder"]).toEqual("base-folder-1");
      expect(output["api-version"]).toEqual(["version-3", "version-1"]);
    });
  });
});
