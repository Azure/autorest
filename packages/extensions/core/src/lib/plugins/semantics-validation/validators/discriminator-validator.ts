import oai3 from "@azure-tools/openapi";
import { SemanticError, SemanticErrorCodes } from "../types";

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
            level: "error",
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
