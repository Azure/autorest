import { getRequestedCoreVersion, parseMemory } from "./utils";

describe("autorest: Utils", () => {
  it("resolve max memory config from gb string", () => {
    expect(parseMemory("4g")).toEqual(4096);
  });

  it("resolve max memory config from mb string", () => {
    expect(parseMemory("1024m")).toEqual(1024);
  });

  it("throws if in invalid format", () => {
    expect(() => parseMemory("1024k")).toThrow();
    expect(() => parseMemory("abdef")).toThrow();
    expect(() => parseMemory("4096")).toThrow();
  });

  describe("getRequestedCoreVersion", () => {
    it("returns version in config if present", () => {
      expect(getRequestedCoreVersion({ version: "3.1.0" })).toEqual("3.1.0");
      expect(getRequestedCoreVersion({ version: "3.1.0", latest: true })).toEqual("3.1.0");
      expect(getRequestedCoreVersion({ version: "3.1.0", preview: true })).toEqual("3.1.0");
    });

    it("returns 'latest' in latest flag is on but config is not passed", () => {
      expect(getRequestedCoreVersion({ latest: true })).toEqual("latest");
      expect(getRequestedCoreVersion({ latest: true, preview: true })).toEqual("latest");
    });

    it("returns 'preview' in preview flag is on but config and latest is not passed", () => {
      expect(getRequestedCoreVersion({ preview: true })).toEqual("preview");
    });
  });
});
