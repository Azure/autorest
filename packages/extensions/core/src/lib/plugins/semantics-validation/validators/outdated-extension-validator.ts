import oai3 from "@azure-tools/openapi";
import { SemanticError, SemanticErrorCodes } from "../types";

/**
 * Validate for x- extension that were previously supported but are
 * @param spec
 * @returns
 */
export function validateOutdatedExtensions(spec: oai3.Model): SemanticError[] {
  const errors: SemanticError[] = [];
  if (spec.info["x-ms-code-generation-settings"]) {
    errors.push({
      level: "warn",
      code: SemanticErrorCodes.OutdatedExtension,
      message: `Extension 'x-ms-code-generation-settings' is not supported in Autorest V3. It will just be ignored.`,
      path: ["info", "x-ms-code-generation-settings"],
      params: {},
    });
  }
  return errors;
}
