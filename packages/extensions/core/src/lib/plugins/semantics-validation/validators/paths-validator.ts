import { SemanticError, SemanticErrorCodes } from "../types";
import oai3, { dereference, ParameterLocation, Refable } from "@azure-tools/openapi";

export const PATH_TEMPLATES_REGEX = /\{(.*?)\}/g;

export function validatePaths(spec: oai3.Model): SemanticError[] {
  const paths = spec.paths;
  const errors: SemanticError[] = [];
  for (const [uri, pathItem] of Object.entries(paths)) {
    const paramNames = (uri.match(PATH_TEMPLATES_REGEX) || []).map((x) => x.replace("{", "").replace("}", ""));
    for (const paramName of paramNames) {
      if (!paramName || paramName === "") {
        errors.push(createPathParameterEmptyError(uri));
        continue;
      }

      errors.push(...validatePathParameterExists(uri, paramName, pathItem, spec));
    }
  }
  return errors;
}

function validatePathParameterExists(
  uri: string,
  paramName: string,
  pathItem: oai3.PathItem,
  spec: oai3.Model,
): SemanticError[] {
  if (pathItem.parameters) {
    if (findPathParameter(paramName, pathItem.parameters, spec)) {
      return [];
    }
  }

  const misssingFromMethods = [];
  for (const [method, operation] of Object.entries(pathItem)) {
    if (!findPathParameter(paramName, operation.parameters ?? [], spec)) {
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
  spec: oai3.Model,
): oai3.Parameter | undefined {
  return parameters
    .map((x) => dereference(spec, x).instance)
    .find((x) => x.in === ParameterLocation.Path && x.name === paramName);
}

function createPathParameterEmptyError(uri: string): SemanticError {
  return {
    code: SemanticErrorCodes.PathParameterEmtpy,
    message: `A path parameter in uri ${uri} is empty.`,
    params: { uri },
    path: ["paths", uri],
  };
}

function createPathParameterMissingDefinitionError(uri: string, paramName: string, methods: string[]): SemanticError {
  const missingStr = methods.map((str) => `'${str}'`).join(", ");
  return {
    code: SemanticErrorCodes.PathParameterMissingDefinition,
    message: `Path parameter '${paramName}' referenced in path '${uri}' needs to be defined in every operation at either the path or operation level. (Missing in ${missingStr})`,
    params: { paramName, uri, methods },
    path: ["paths", uri],
  };
}
