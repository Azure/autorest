import oai3 from "@azure-tools/openapi";
import { SemanticError } from "./types";
import { validateDiscriminator, validatePaths } from "./validators";

export function validateOpenAPISemantics(spec: oai3.Model): SemanticError[] {
  return [...validateDiscriminator(spec), ...validatePaths(spec)];
}
