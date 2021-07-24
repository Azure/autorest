import { Mapping } from "../source-map";
import { createMappingTree } from "./mapping-tree";

interface Model {
  id: number;
  nested: {
    name: string;
  };
}
describe("MappingTree", () => {
  const mappings: Mapping[] = [];
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
    expect(() => ((root as any).foo = 123)).toThrowError(
      "Use __set__ or __push__ to modify proxy graph. Trying to set foo with value: 123",
    );
  });
});
