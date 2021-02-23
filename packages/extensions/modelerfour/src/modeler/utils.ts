import { Operation } from "@autorest/codemodel";

/**
 * Figure out if the provided operation already define a Content-Type parameter.
 * @param operation Operation.
 */
export function operationDefineContentTypeParameter(operation: Operation): boolean {
  return operation.parameters?.find((x) => x.language.default.serializedName === "Content-Type") !== undefined;
}
