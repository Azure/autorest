import { ResolvedDirective } from "./directive";

describe("Directive", () => {
  it("resolve propertis", () => {
    const resolved = new ResolvedDirective({
      from: "foo",
      transform: ["123", "456"],
    });

    expect(resolved.from).toEqual(["foo"]);
    expect(resolved.transform).toEqual(["123", "456"]);
    expect(resolved.reason).toEqual(undefined);
    expect(resolved.suppress).toEqual([]);
  });
});
