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

/**
 * Takes a configuration value that can be either an array, a single value or empty and returns an array with all values.
 * @param value Value to wrap in an array.
 * @returns Array of all the values.
 */
export function arrayify<T>(value: T | T[] | undefined): T[] {
  if (value === undefined) {
    return [];
  }

  switch (typeof value) {
    case "string": // Need to do this case as String is iterable.
      return [value];
    case "object":
      if (isIterable(value)) {
        return [...value];
      }
      break;
  }
  return [value];
}

function isIterable(target: any): target is Iterable<any> {
  return !!target && typeof target[Symbol.iterator] === "function";
}
