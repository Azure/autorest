import { walk } from "@azure-tools/json";
import oai3, { excludeXDash, omitXDashProperties } from "@azure-tools/openapi";
import { SemanticError, SemanticErrorCodes } from "../types";

/**
 * List of properties that autorest allows to be next to a $ref. This is not standard OpenAPI as it says all properties next to a $ref should be ignored.
 */
const allowedKeysNextToRef = new Set([
  "$ref",
  "description",
  "title",
  "readonly",
  "nullable",
  "x-ms-client-name",
  "x-ms-client-flatten",
]);

export function validateRefsSiblings(spec: oai3.Model) {
  const errors: SemanticError[] = [];
  walk(spec, (node: any, path) => {
    const key = path[path.length - 1];
    if (key === "x-ms-examples") {
      return "stop";
    }
    if (node.$ref && typeof node.$ref === "string") {
      const keys = Object.keys(node)
        .filter((x) => !allowedKeysNextToRef.has(x))
        .filter((x) => !x.startsWith("x-"));
      if (keys.length > 0) {
        errors.push({
          level: "warn",
          code: SemanticErrorCodes.IgnoredPropertyNextToRef,
          message: `Sibling values alongside $ref will be ignored. See https://github.com/Azure/autorest/blob/master/docs/openapi/howto/$ref-siblings.md for allowed values`,
          path,
          params: {
            keys,
          },
        });
      }
      return "stop";
    }
    return "visit-children";
  });
  return errors;
}
