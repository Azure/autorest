import oai3, { dereference } from "@azure-tools/openapi";
import { ResolveReferenceFn } from "./types";

export function createReferenceResolver<T extends {}>(
  spec: oai3.OpenAPI3Document,
  resolveReference: ResolveReferenceFn<T> | undefined,
): ResolveReferenceFn<T> {
  return resolveReference ?? ((item) => dereference(spec, item).instance);
}
