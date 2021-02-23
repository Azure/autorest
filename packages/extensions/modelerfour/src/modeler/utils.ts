import { Operation, Parameter } from "@autorest/codemodel";

/**
 * Figure out if the provided operation already define a Content-Type parameter.
 * @param operation Operation.
 */
export function isContentTypeParameterDefined(operation: Operation): boolean {
  return operation.parameters?.find(isParameterContentTypeHeader) !== undefined;
}

function isParameterContentTypeHeader(parameter: Parameter): boolean {
  const serializedName = parameter.language.default.serializedName;
  if (!serializedName || typeof serializedName !== "string") {
    return false;
  }
  if (parameter.protocol.http?.in !== "header") {
    return false;
  }
  return serializedName?.toLowerCase() === "content-type";
}
