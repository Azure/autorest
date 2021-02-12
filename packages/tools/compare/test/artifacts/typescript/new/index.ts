class SomeClass {
  // removedField is removed
  private visibilityChangedField: Namespace.Type;
  private readOnlyChangedField = "stuff";

  // removedMethod is removed
  changedParamType(firstParam: number): void {}
  changedReturnType(firstParam: string): number {
    return 311;
  }
  reorderedParams(secondParam: string, firstParam: string): void {}
  hasGenericParam<S>(genericParam: S): void {}
}

function someFunction(genericParam: number): string {
  return "test";
}

interface SomeInterface {}
class DifferentBaseClass {}

export class ExportedClass extends DifferentBaseClass
  implements SomeInterface {}

let SomeConst: SomeOtherUnion = "blue";
