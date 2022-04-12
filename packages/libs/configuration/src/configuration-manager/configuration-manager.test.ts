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

    it("combines array values in order of higher priority", async () => {
      expect(output["api-version"]).toEqual(["version-1", "version-2"]);
    });

    it("adds value from 2nd config if not present in 1st", async () => {
      expect(output["base-folder"]).toEqual("base-folder-2");
    });

    it("combine nested objects", async () => {
      await manager.addConfig({
        "use-extension": {
          "@autorest/csharp": "latest",
        },
      });
      await manager.addConfig({
        "use-extension": {
          "@autorest/modelerfour": "latest",
        },
      });

      const output = await manager.resolveConfig();
      expect(output["use-extension"]).toEqual({
        "@autorest/csharp": "latest",
        "@autorest/modelerfour": "latest",
      });
    });
  });

  describe("adding a single file with multiple blocks", () => {
    it("override values with blocks defined later", async () => {
      manager.addConfigFile({
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
      expect(output["api-version"]).toEqual(["version-1", "version-2"]);
    });

    it("merges array in the order they are defined", async () => {
      manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              "api-version": ["version-1"],
            },
          },
          {
            config: {
              "api-version": ["version-2"],
            },
          },
          {
            config: {
              "api-version": ["version-3"],
            },
          },
        ],
      });

      const output = await manager.resolveConfig();
      expect(output["api-version"]).toEqual(["version-1", "version-2", "version-3"]);
    });

    it("use condition from previous blocks", async () => {
      manager.addConfigFile({
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
      expect(output["api-version"]).toEqual(["version-1", "version-3"]);
    });

    it("merge directives defined as object", async () => {
      manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              directive: [{ from: "swagger-document", transform: "$.swagger=true" }],
            },
          },
          {
            config: {
              directive: [{ from: "openapi-document", transform: "$.openapi3=true" }],
            },
          },
        ],
      });

      const output = await manager.resolveConfig();
      expect(output.directive).toEqual([
        { from: "swagger-document", transform: "$.swagger=true" },
        { from: "openapi-document", transform: "$.openapi3=true" },
      ]);
    });
  });

  describe("interpolate previous values", () => {
    it("interpolate from previous config", async () => {
      await manager.addConfig({
        name: "FooBar",
      });
      await manager.addConfig({
        namespace: "$(name).Client",
      });

      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBar.Client");
    });

    it("interpolate from same config but defined before", async () => {
      await manager.addConfig({
        name: "FooBar",
        namespace: "$(name).Client",
      });

      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBar.Client");
    });

    it("interpolate with higher priority value(defined before) instead of the one in the same block", async () => {
      await manager.addConfig({
        name: "FooBarOverride",
      });
      await manager.addConfig({
        name: "FooBar",
        namespace: "$(name).Client",
      });

      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBarOverride.Client");
    });

    it("interpolate with higher priority value(defined in previous config) instead of the one in the same block", async () => {
      await manager.addConfig({
        name: "FooBarOverride",
      });

      manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              name: "FooBar",
              namespace: "$(name).Client",
            },
          },
        ],
      });
      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBarOverride.Client");
    });

    it("interpolate from previous block", async () => {
      manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              name: "FooBar",
            },
          },
          {
            config: {
              namespace: "$(name).Client",
            },
          },
        ],
      });
      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBar.Client");
    });

    it("interpolate with value from same block overriding the last block value", async () => {
      manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              name: "FooBar",
            },
          },
          {
            config: {
              name: "FooBarOverride",
              namespace: "$(name).Client",
            },
          },
        ],
      });
      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBarOverride.Client");
    });

    it("interpolate from the previous config", async () => {
      await manager.addConfig({
        name: "FooBarCLIOverride",
      });
      manager.addConfigFile({
        type: "file",
        fullPath: "/dev/path/readme.md",
        configs: [
          {
            config: {
              name: "FooBar",
            },
          },
          {
            config: {
              name: "FooNextBlockOverride",
              namespace: "$(name).Client",
            },
          },
        ],
      });
      const output = await manager.resolveConfig();
      expect(output["namespace"]).toEqual("FooBarCLIOverride.Client");
    });
  });
});
