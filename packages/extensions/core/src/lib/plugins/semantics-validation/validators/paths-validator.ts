import { ResolveReferenceFn, SemanticError, SemanticErrorCodes } from "../types";
import oai3, { ParameterLocation, Refable } from "@azure-tools/openapi";
import { createReferenceResolver } from "../utils";

export const PATH_TEMPLATES_REGEX = /\{(.*?)\}/g;

const operationKeys = new Set(["get", "post", "put", "delete", "options", "head", "patch", "trace"]);

/**
 * Semantic validation for paths.
 * @param spec OpenAPI Spec to validate.
 * @param resolveReference
 * @returns
 */
export function validatePaths(spec: oai3.Model, resolve?: ResolveReferenceFn): SemanticError[] {
  const resolveReference = createReferenceResolver(spec, resolve);
  const paths = spec.paths;
  const errors: SemanticError[] = [];
  for (const [uri, pathItem] of Object.entries(paths)) {
    const paramNames = (uri.match(PATH_TEMPLATES_REGEX) || []).map((x) => x.replace("{", "").replace("}", ""));
    for (const paramName of paramNames) {
      if (!paramName || paramName === "") {
        errors.push(createPathParameterEmptyError(uri));
        continue;
      }

      errors.push(...validatePathParameterExists(uri, paramName, pathItem, resolveReference));
    }
  }
  return errors;
}

function validatePathParameterExists(
  uri: string,
  paramName: string,
  pathItem: oai3.PathItem,
  resolveReference: ResolveReferenceFn,
): SemanticError[] {
  if (pathItem.parameters) {
    if (findPathParameter(paramName, pathItem.parameters, resolveReference)) {
      return [];
    }
  }

  const misssingFromMethods = [];
  for (const [method, operation] of Object.entries(pathItem).filter(([method]) => operationKeys.has(method))) {
    if (!findPathParameter(paramName, operation.parameters ?? [], resolveReference)) {
      misssingFromMethods.push(method);
    }
  }
  return misssingFromMethods.length > 0
    ? [createPathParameterMissingDefinitionError(uri, paramName, misssingFromMethods)]
    : [];
}

function findPathParameter(
  paramName: string,
  parameters: Refable<oai3.Parameter>[],
  resolveReference: ResolveReferenceFn,
): oai3.Parameter | undefined {
  return parameters
    .map((x) => resolveReference(x))
    .find((x) => x.in === ParameterLocation.Path && x.name === paramName);
}

function createPathParameterEmptyError(uri: string): SemanticError {
  return {
    level: "error",
    code: SemanticErrorCodes.PathParameterEmtpy,
    message: `A path parameter in uri ${uri} is empty.`,
    params: { uri },
    path: ["paths", uri],
  };
}

function createPathParameterMissingDefinitionError(uri: string, paramName: string, methods: string[]): SemanticError {
  const missingStr = methods.map((str) => `'${str}'`).join(", ");
  return {
    level: "error",
    code: SemanticErrorCodes.PathParameterMissingDefinition,
    message: `Path parameter '${paramName}' referenced in path '${uri}' needs to be defined in every operation at either the path or operation level. (Missing in ${missingStr})`,
    params: { paramName, uri, methods },
    path: ["paths", uri],
  };
}
