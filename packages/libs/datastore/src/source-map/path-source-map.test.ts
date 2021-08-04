import { PathSourceMap } from "./path-source-map";

const store = new Map();
jest.mock("fs", () => ({
  ...(jest.requireActual("fs") as any),
  promises: {
    writeFile: jest.fn((file, content) => store.set(file, content)),
    readFile: jest.fn((file) => store.get(file)),
  },
}));
import fs from "fs";

const source = "source.json";

describe("PathSourceMap", () => {
  let sourceMap: PathSourceMap;

  beforeEach(() => {
    store.clear();
    sourceMap = new PathSourceMap("my-test.json", [
      { generated: ["components", "schemas", "Foo"], original: ["definitions", "Foo"], source },
      { generated: ["components", "schemas", "Bar"], original: ["definitions", "Bar"], source },
      { generated: ["components", "parameters", "filter"], original: ["parameters", "filter"], source },
    ]);
  });

  it("return original mapping for a path that it knows", async () => {
    expect(await sourceMap.getOriginalLocation({ path: ["components", "schemas", "Foo"] })).toEqual({
      path: ["definitions", "Foo"],
      source,
    });

    expect(await sourceMap.getOriginalLocation({ path: ["components", "schemas", "Bar"] })).toEqual({
      path: ["definitions", "Bar"],
      source,
    });
  });

  it("return undefined if it cannot find the path", async () => {
    expect(await sourceMap.getOriginalLocation({ path: ["components", "schemas", "Unknown"] })).toBeUndefined();
    expect(await sourceMap.getOriginalLocation({ path: ["servers"] })).toBeUndefined();
  });

  describe("unload sourcemap from memory", () => {
    beforeEach(async () => {
      await sourceMap.unload();
    });

    it("cached the file to disk", () => {
      expect(fs.promises.writeFile).toHaveBeenCalledTimes(1);
      expect(fs.promises.writeFile).toHaveBeenCalledWith("my-test.json.pathmap", expect.any(String));
    });

    it("will reload the file when sourcemap is requested", async () => {
      expect((sourceMap as any).data.data).toEqual({ status: "unloaded" });

      expect(await sourceMap.getOriginalLocation({ path: ["components", "schemas", "Foo"] })).toEqual({
        path: ["definitions", "Foo"],
        source,
      });

      expect((sourceMap as any).data.data).toMatchObject({ status: "loaded" });
    });
  });
});
