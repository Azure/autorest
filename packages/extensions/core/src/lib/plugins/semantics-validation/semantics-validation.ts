import { EnhancedPosition } from "@azure-tools/datastore";
import oai3 from "@azure-tools/openapi";
import { Position } from "source-map";

export enum SemanticErrorCodes {
  DiscriminatorNotRequired = "DiscriminatorNotRequired",
}

export function validateOpenAPISemantics(spec: oai3.Model) {
  return [...validateDiscriminator(spec)];
}

export function validateDiscriminator(spec: oai3.Model): SemanticError[] {
  const schemas = spec.components?.schemas;
  if (!schemas) {
    return [];
  }
  const errors: SemanticError[] = [];
  for (const [name, model] of Object.entries(schemas)) {
    if ("$ref" in model) {
      continue;
    }
    const discriminator = model.discriminator;
    if (discriminator) {
      if (model.oneOf || model.anyOf) {
        // Not validating in this case. This is valid OpenAPI but we don't support discriminator defined that way yet.
      } else {
        if (!model.required || !model.required.includes(discriminator.propertyName)) {
          errors.push({
            code: SemanticErrorCodes.DiscriminatorNotRequired,
            params: { discriminator },
            message: "Discriminator must be a required property.",
            path: ["components", "schemas", name],
          });
        }
      }
    }
  }

  return errors;
}

export interface SemanticError {
  code: string;
  message: string;
  params: Record<string, unknown>;
  path: string[];
}
