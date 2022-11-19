import { PathMapping } from "../source-map";
import { createMappingTree } from "./mapping-tree";

interface Model {
  id: number;
  nested: {
    name: string;
  };
  array: string[];
}
describe("MappingTree", () => {
  let mappings: PathMapping[];

  beforeEach(() => {
    mappings = [];
  });

  it("create tree from existing value", () => {
    const root = createMappingTree(
      "foo",
      {
        id: 123,
        nested: {
          name: "Bar",
        },
      },
      mappings,
    );

    expect(root.id).toEqual(123);
    expect(root.nested.name).toEqual("Bar");
  });

  it("cannot assign property", () => {
    const root = createMappingTree<Model>("foo", {}, mappings);
    expect(() => ((root as any).foo = 123)).toThrow(
      "Use __set__ or __push__ to modify proxy graph. Trying to set foo with value: 123",
    );
  });

  it("create mappings when setting new values", () => {
    const root = createMappingTree<Model>("foo", {}, mappings);
    root.__set__("id", { value: 123, sourcePointer: "/original/path" });

    expect(root.id).toEqual(123);
    expect(mappings).toEqual([
      {
        generated: ["id"],
        original: ["original", "path"],
        source: "foo",
      },
    ]);
  });

  it("create mappings when pushing new values", () => {
    const root = createMappingTree<Model>("foo", { array: [] }, mappings);
    root.array?.__push__({ value: "new-value", sourcePointer: "/original/path/0" });
    expect(root.array).toEqual(["new-value"]);

    expect(mappings).toEqual([
      {
        generated: ["array", 0],
        original: ["original", "path", 0],
        source: "foo",
      },
    ]);
  });
});
