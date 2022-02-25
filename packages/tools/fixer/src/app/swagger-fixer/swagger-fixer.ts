import { cloneDeep } from "lodash";
import { AllFixers } from "..";
import { Fix, FixCode, FixResult } from "../types";

export function fixSwagger(filename: string, spec: any, fixers: FixCode[] | typeof AllFixers): FixResult {
  let current: FixResult = { spec, fixes: [] };

  const addResult = (result: FixResult) => {
    current = {
      spec: result.spec,
      fixes: current.fixes.concat(result.fixes),
    };
  };

  const runFixer = (name: FixCode, callback: () => FixResult) => {
    if (fixers === AllFixers || fixers.includes(name)) {
      addResult(callback());
    }
  };
  runFixer(FixCode.MissingTypeObject, () => fixSwaggerMissingType(filename, current.spec));
  runFixer(FixCode.SingleValueEnumConstant, () => fixSingleValueEnumConstant(filename, current.spec));

  return current;
}

/**
 * Find definitions with missing type: object that should be object according to autorest historic behavior.
 * @param filename Filename
 * @param spec Spec.
 * @returns FixResult
 */
export function fixSwaggerMissingType(filename: string, spec: any): FixResult {
  const newSpec = cloneDeep(spec);
  const fixes: Fix[] = [];

  forEachDefinitions(newSpec, (definition, path) => {
    if (!("type" in definition) && autorestAssumeSchemaIsObject(definition)) {
      // Set type:object as the "first" property.
      fixes.push({
        filename,
        code: FixCode.MissingTypeObject,
        message: `Schema is defining properties but is missing type: object.`,
        path,
      });
      return { type: "object", ...definition };
    }
    return definition;
  });

  return { spec: newSpec, fixes };
}
/**
 * Find definitions with missing type: object that should be object according to autorest historic behavior.
 * @param filename Filename
 * @param spec Spec.
 * @returns FixResult
 */
export function fixSingleValueEnumConstant(filename: string, spec: any): FixResult {
  const newSpec = cloneDeep(spec);
  const fixes: Fix[] = [];

  findRecursive(newSpec, [], (definition, path) => {
    if (definition.enum && definition.enum.length === 1 && definition["x-ms-enum"]?.modelAsString === undefined) {
      // Set type:object as the "first" property.
      fixes.push({
        filename,
        code: FixCode.SingleValueEnumConstant,
        message: `Schema is defining a single value enum that used to be a constant. Explicitly setting to be a constant`,
        path,
      });
      const copy = { ...definition };
      if (!copy["x-ms-enum"]) {
        copy["x-ms-enum"] = {};
      }
      copy["x-ms-enum"].modelAsString = false;
      return copy;
    }
    return definition;
  });

  return { spec: newSpec, fixes };
}

function autorestAssumeSchemaIsObject(definition: any) {
  return definition.properties || definition.additionalProperties || definition.allOf;
}

function forEachDefinitions(spec: any, handler: (definition: any, path: string[]) => any) {
  if (!spec.definitions) {
    return;
  }

  for (const [name, definition] of Object.entries<any>(spec.definitions)) {
    spec.definitions[name] = forEachNestedDefinitions(definition, ["definitions", name], handler);
  }
}

function findRecursive(obj: any, currentPath: string[], handler: (definition: any, path: string[]) => any) {
  if (!obj) {
    return obj;
  }

  obj = handler(obj, currentPath);

  if (Array.isArray(obj)) {
    for (const [key, item] of obj.entries()) {
      const result = findRecursive(item, [...currentPath, key as any], handler);
      if (result !== item) {
        obj[key] = result;
      }
    }
  } else if (typeof obj === "object") {
    for (const [key, item] of Object.entries(obj)) {
      const result = findRecursive(item, [...currentPath, key], handler);
      if (result !== item) {
        obj[key] = result;
      }
    }
  }
  return obj;
}

function forEachNestedDefinitions(
  definition: any,
  path: string[],
  handler: (definition: any, path: string[]) => any,
): any {
  if (typeof definition !== "object") {
    return definition;
  }

  definition = handler(definition, path);

  if (definition.properties) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.properties)) {
      definition.properties[name] = forEachNestedDefinitions(nestedDefinition, [...path, "properties", name], handler);
    }
  }

  if (definition.allOf) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.allOf)) {
      definition.allOf[name] = forEachNestedDefinitions(nestedDefinition, [...path, "allOf", name], handler);
    }
  }

  if (definition.oneOf) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.oneOf)) {
      definition.oneOf[name] = forEachNestedDefinitions(nestedDefinition, [...path, "oneOf", name], handler);
    }
  }

  if (definition.anyOf) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.anyOf)) {
      definition.anyOf[name] = forEachNestedDefinitions(nestedDefinition, [...path, "anyOf", name], handler);
    }
  }
  return definition;
}
