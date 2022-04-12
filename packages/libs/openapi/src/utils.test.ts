import { omitXDashKeys, includeXDashKeys, includeXDashProperties, omitXDashProperties, isExtensionKey } from "./utils";

describe("OpenAPI utils", () => {
  it("isExtensionKey returns true when starts with x-", () => {
    expect(isExtensionKey("x-foo")).toBe(true);
  });

  it("isExtensionKey returns false when does not starts with x-", () => {
    expect(isExtensionKey("foo")).toBe(false);
  });

  it("includeXDashKeys returns x- properties keys", () => {
    // Type validation
    const result: ("x-foo" | "x-other")[] = includeXDashKeys({
      foo: 1,
      bar: 2,
      "x-foo": 3,
      "x-other": 4,
    });
    expect(result).toEqual(["x-foo", "x-other"]);
  });

  it("omitXDashKeys returns non x- properties keys", () => {
    // Type validation
    const result: ("foo" | "bar")[] = omitXDashKeys({
      foo: 1,
      bar: 2,
      "x-foo": 3,
      "x-other": 4,
    });
    expect(result).toEqual(["foo", "bar"]);
  });

  it("includeXDashProperties returns x- properties", () => {
    const result = includeXDashProperties({
      foo: 1,
      bar: 2,
      "x-foo": 3,
      "x-other": 4,
    });
    // Type validation
    expect<{ "x-foo": number; "x-other": number }>(result).toEqual({
      "x-foo": 3,
      "x-other": 4,
    });
  });

  it("includeXDashProperties returns undefined if undefined is passed", () => {
    const result = includeXDashProperties(undefined);
    // Type validation
    expect<undefined>(result).toEqual(undefined);
  });

  it("omitXDashProperties returns x- properties", () => {
    // Type validation
    const result = omitXDashProperties({
      foo: 1,
      bar: 2,
      "x-foo": 3,
      "x-other": 4,
    });
    expect<{ foo: number; bar: number }>(result).toEqual({
      foo: 1,
      bar: 2,
    });
  });

  it("omitXDashProperties returns undefined if undefined is passed", () => {
    const result = omitXDashProperties(undefined);
    // Type validation
    expect<undefined>(result).toEqual(undefined);
  });
});
