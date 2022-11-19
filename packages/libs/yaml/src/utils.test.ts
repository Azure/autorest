import { parseYAMLAst } from "./parser";
import { Kind } from "./types";
import { getYamlNodeByPath } from "./utils";

describe("Utils", () => {
  describe("getYamlNodeByPath", () => {
    const ast = parseYAMLAst(`
      foo: 123
      bar:
        nested:
          - one
          - two
    `);

    it("get a mapping returns the mapping node", () => {
      const node = getYamlNodeByPath(ast, ["foo"]);
      expect(node.kind).toEqual(Kind.MAPPING);
      expect(node.value.kind).toEqual(Kind.SCALAR);
      expect(node.value.value).toEqual("123");
    });

    it("get array item returns the value", () => {
      const node = getYamlNodeByPath(ast, ["bar", "nested", 1]);
      expect(node.kind).toEqual(Kind.SCALAR);
      expect(node.value).toEqual("two");
    });

    it("Throws an error if path doesn't exists", () => {
      expect(() => getYamlNodeByPath(ast, ["bar", "invalid"])).toThrow(
        "Error retrieving 'bar>invalid' (Error: Trying to retrieve 'invalid' from mapping that contains no such key)",
      );
    });
  });
});
