import { cloneDeep } from "lodash";
export interface FixResult {
  spec: any;
  fixes: Fix[];
}

export interface Fix {
  code: FixCode;
  message: string;
  path: string[];
}

export enum FixCode {
  MissingTypeObject = "missing-type-object",
}

export function fixSwagger(spec: any): FixResult {
  return fixSwaggerMissingType(spec);
}

export function fixSwaggerMissingType(spec: any): FixResult {
  const newSpec = cloneDeep(spec);
  const fixes: Fix[] = [];
  for (const [name, definition] of Object.entries<any>(newSpec.definitions)) {
    if (definition.properties && !("type" in definition)) {
      newSpec.definitions[name] = { ...definition, type: "object" };
      fixes.push({
        code: FixCode.MissingTypeObject,
        message: `Schema is defining properties but is missing type: object.`,
        path: ["definitions", name],
      });
    }
  }
  return { spec: newSpec, fixes };
}
