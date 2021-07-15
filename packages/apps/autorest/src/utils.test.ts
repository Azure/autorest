import { parseMemory } from "./utils";

describe("autorest: Utils", () => {
  it("resolve max memory config from gb string", () => {
    expect(parseMemory("4g")).toEqual(4096);
  });

  it("resolve max memory config from mb string", () => {
    expect(parseMemory("1024m")).toEqual(1024);
  });

  it("throws if in invalid format", () => {
    expect(() => parseMemory("1024k")).toThrowError();
    expect(() => parseMemory("abdef")).toThrowError();
    expect(() => parseMemory("4096")).toThrowError();
  });
});
