import { evalDirectiveTransform } from "./eval";

function transform(code: string, initialValue: any): any {
  return evalDirectiveTransform(code, {
    value: initialValue,
  } as any);
}

describe("Transformer > Eval", () => {
  it("add a new property to value", () => {
    const value = {
      name: "Foo",
    };
    expect(transform("$.age = 123", value)).toEqual({
      ...value,
      age: 123,
    });
  });

  it("replace current value", () => {
    const value = {
      name: "Foo",
    };
    expect(transform("$ = 123", value)).toEqual(123);
  });

  it("takes return value", () => {
    const value = {
      name: "Foo",
    };
    expect(transform("return 456", value)).toEqual(456);
  });
});
