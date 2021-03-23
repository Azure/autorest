import * as OpenAPI from "@azure-tools/openapi";

export function isSchemaBinary(schema: OpenAPI.Schema) {
  return <any>schema.type === "file" || schema.format === "file" || schema.format === "binary";
}
