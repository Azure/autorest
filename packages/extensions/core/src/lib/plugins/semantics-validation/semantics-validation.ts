import oai3 from "@azure-tools/openapi";
import { ResolveReferenceFn, SemanticError } from "./types";
import { createReferenceResolver } from "./utils";
import { validateDiscriminator, validateOutdatedExtensions, validatePaths, validateRefsSiblings } from "./validators";

export function validateOpenAPISemantics(spec: oai3.Model, resolve: ResolveReferenceFn | undefined): SemanticError[] {
  const resolveReference = createReferenceResolver(spec, resolve);

  return [
    ...validateDiscriminator(spec),
    ...validatePaths(spec, resolveReference),
    ...validateOutdatedExtensions(spec),
    ...validateRefsSiblings(spec),
  ];
}
