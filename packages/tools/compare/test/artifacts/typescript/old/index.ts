class SomeClass {
  private removedField: string;
  public visibilityChangedField: Namespace.Type;
  private readonly readOnlyChangedField = "stuff";

  removedMethod(optional?: string): void {}
  changedParamType(firstParam: string): void {}
  changedReturnType(firstParam: string): string {
    const booString = "boo";
    return booString;
  }

  reorderedParams(firstParam: string, secondParam: string): void {}
  protected hasGenericParam<T>(genericParam: T): void {}
}

export function someFunction<T>(genericParam: T): string {
  return "test";
}

interface SomeInterface {}
interface BaseInterface {}
export interface AnotherInterface extends BaseInterface {}

class BaseClass {}
export class ExportedClass extends BaseClass
  implements SomeInterface, AnotherInterface {}

export type SomeUnion = "red" | "green" | "brurple";

export const SomeConst: SomeUnion = "red";
