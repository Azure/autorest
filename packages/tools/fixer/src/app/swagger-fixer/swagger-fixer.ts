import { cloneDeep } from "lodash";
import { Fix, FixCode, FixResult } from "../types";

export function fixSwagger(spec: any): FixResult {
  return fixSwaggerMissingType(spec);
}

export function fixSwaggerMissingType(spec: any): FixResult {
  const newSpec = cloneDeep(spec);
  const fixes: Fix[] = [];

  forEachDefinitions(newSpec, (definition, path) => {
    if (definition.properties && !("type" in definition)) {
      definition.type = "object";
      fixes.push({
        code: FixCode.MissingTypeObject,
        message: `Schema is defining properties but is missing type: object.`,
        path,
      });
    }
  });

  return { spec: newSpec, fixes };
}

function forEachDefinitions(spec: any, handler: (definition: any, path: string[]) => void) {
  for (const [name, definition] of Object.entries<any>(spec.definitions)) {
    forEachNestedDefinitions(definition, ["definitions", name], handler);
  }
}

function forEachNestedDefinitions(definition: any, path: string[], handler: (definition: any, path: string[]) => void) {
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
