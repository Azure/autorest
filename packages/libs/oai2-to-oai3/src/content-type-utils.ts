import { OpenAPI2Operation } from "./oai2";

/**
 * Resolve the list of content types produced by an operation.
 * @param operationProduces: List of content type produces by the operation.
 * @param globalProduces: List of default content type produced by the API.
 * @returns list of produced content types. Array will have at least one entry.
 */
export const resolveOperationProduces = (operation: OpenAPI2Operation, globalProduces: string[]): string[] => {
  const operationProduces = operation.produces;
  const produces = operationProduces
    ? operationProduces.indexOf("application/json") !== -1
      ? operationProduces
      : [...new Set([...operationProduces])]
    : globalProduces;

  // default
  if (produces.length === 0) {
    produces.push("*/*");
  }

  return produces;
};

/**
 * Resolve the list of content types consumed by an operation.
 * @param operationConsumes: List of content type consumed by the operation.
 * @param globalConsumes: List of default content type consumed by the API.
 */
export const resolveOperationConsumes = (operation: OpenAPI2Operation, globalConsumes: string[]): string[] => {
  const operationConsumes = operation.consumes;
  return operationConsumes
    ? operationConsumes.indexOf("application/octet-stream") !== -1
      ? operationConsumes
      : [...new Set([...operationConsumes])]
    : globalConsumes;
};
