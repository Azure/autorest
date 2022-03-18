import * as OpenAPI from "@azure-tools/openapi";
import { dereference } from "@azure-tools/openapi";

export function isSchemaBinary(schema: OpenAPI.Schema) {
  return <any>schema.type === "file" || schema.format === "file" || schema.format === "binary";
}

/**
 * @returns true if the schema is a basic string without format.
 */
export function isSchemaString(schema: OpenAPI.Schema) {
  return schema.type === "string" && schema.format === undefined && schema.enum === undefined;
}

/**
 * Figure out if a schema should be an enum. This is either it is marked itself as an enum or that it has allOf of an enum.
 * @param schema Schema.
 * @returns Boolean if schema is an enum.
 */
export function isSchemaAnEnum(schema: OpenAPI.Schema, spec: OpenAPI.Model): boolean {
  if (schema.enum || schema["x-ms-enum"]) {
    return true;
  }

  if (schema.allOf) {
    for (const item of schema.allOf) {
      const ref = dereference(spec, item);
      if (ref.instance) {
        if (isSchemaAnEnum(ref.instance, spec)) {
          return true;
        }
      }
    }
  }

  return false;
}
