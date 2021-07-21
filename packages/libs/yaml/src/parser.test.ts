import { getYamlNodeValue, parseYAMLAst } from "./parser";

function parseYAML(yaml: string): any {
  const ast = parseYAMLAst(yaml);
  const { result, errors } = getYamlNodeValue(ast);

  expect(errors).toHaveLength(0);
  return result;
}

describe("Yaml parser", () => {
  it("parse primitive types", () => {
    const value = parseYAML(`
      number: 123
      boolean: true
      string: foobar
      quotedString: 'quotedString'
      doubleQuotedString: "doubleQuotedString"
    `);

    expect(value).toEqual({
      number: 123,
      boolean: true,
      string: "foobar",
      doubleQuotedString: "doubleQuotedString",
      quotedString: "quotedString",
    });
  });

  it("parse yaml merge constructs <<", () => {
    const value = parseYAML(`
      Colors: &COLORS
        type: string
        enum: [one, two]
      Other:
        <<: *COLORS
    `);

    expect(value).toEqual({
      Colors: { type: "string", enum: ["one", "two"] },
      Other: { type: "string", enum: ["one", "two"] },
    });
    // Should be a copy and not the same reference
    expect(value.Colors).not.toBe(value.Other);
  });

  it("parse yaml reference anchors", () => {
    const value = parseYAML(`
      Colors: &COLORS
        type: string
        enum: [one, two]
      Other:
        color: *COLORS
    `);

    expect(value).toEqual({
      Colors: { type: "string", enum: ["one", "two"] },
      Other: { color: { type: "string", enum: ["one", "two"] } },
    });

    // Should be a the same reference.
    expect(value.Colors).toBe(value.Other.color);
  });

  it("parse circular dependency anchors", () => {
    const value = parseYAML(`
      Foo: &FOO
        bar: &BAR
          foo: *FOO
    `);

    // Should be a the same reference.
    expect(value.Foo.bar.foo).toBe(value.Foo);
  });
});
