import { parseNode, ParseToAst } from "./yaml";

function parseYAML(yaml: string): any {
  const ast = ParseToAst(yaml);
  const { result, errors } = parseNode(ast);

  expect(errors).toHaveLength(0);
  return result;
}

describe("Yaml parser", () => {
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
});
