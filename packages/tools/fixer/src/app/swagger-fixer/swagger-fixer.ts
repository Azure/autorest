import { cloneDeep } from "lodash";
import { Fix, FixCode, FixResult } from "../types";

export function fixSwagger(filename: string, spec: any): FixResult {
  return fixSwaggerMissingType(filename, spec);
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
      definition.type = "object";
      fixes.push({
        filename,
        code: FixCode.MissingTypeObject,
        message: `Schema is defining properties but is missing type: object.`,
        path,
      });
    }
  });

  return { spec: newSpec, fixes };
}

function autorestAssumeSchemaIsObject(definition: any) {
  return definition.properties || definition.additionalProperties || definition.allOf;
}

function forEachDefinitions(spec: any, handler: (definition: any, path: string[]) => void) {
  if (!spec.definitions) {
    return;
  }

  for (const [name, definition] of Object.entries<any>(spec.definitions)) {
    forEachNestedDefinitions(definition, ["definitions", name], handler);
  }
}

function forEachNestedDefinitions(definition: any, path: string[], handler: (definition: any, path: string[]) => void) {
  if (typeof definition !== "object") {
    return;
  }

  handler(definition, path);

  if (definition.properties) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.properties)) {
      forEachNestedDefinitions(nestedDefinition, [...path, "properties", name], handler);
    }
  }

  if (definition.allOf) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.allOf)) {
      forEachNestedDefinitions(nestedDefinition, [...path, "allOf", name], handler);
    }
  }

  if (definition.oneOf) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.oneOf)) {
      forEachNestedDefinitions(nestedDefinition, [...path, "oneOf", name], handler);
    }
  }

  if (definition.anyOf) {
    for (const [name, nestedDefinition] of Object.entries<any>(definition.anyOf)) {
      forEachNestedDefinitions(nestedDefinition, [...path, "anyOf", name], handler);
    }
  }
}
