import { ParseNode, ParseToAst } from "./yaml";

describe("Yaml parser", () => {
  it("parse yaml merge constructs <<", () => {
    const ast = ParseToAst(`
      Colors: &COLORS
        type: string
        enum: [one, two]
      Other:
        <<: *COLORS
    `);

    expect(ParseNode(ast)).toEqual({
      Colors: { type: "string", enum: ["one", "two"] },
      Other: { type: "string", enum: ["one", "two"] },
    });
  });
});
