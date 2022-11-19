import {
  CodeModel,
  Operation,
  OperationGroup,
  Parameter,
  ParameterLocation,
  Protocols,
  Request,
  Schema,
  SchemaResponse,
} from "@autorest/codemodel";
import { getDataTypes } from "../data-types";
import { CadlOperation, CadlOperationGroup, CadlParameter, CadlParameterLocation, Extension } from "../interfaces";
import { transformDataType } from "../model";
import { getLogger } from "../utils/logger";
import { getLanguageMetadata } from "../utils/metadata";
import { isConstantSchema } from "../utils/schemas";

export function transformOperationGroup(
  { language, operations }: OperationGroup,
  codeModel: CodeModel,
): CadlOperationGroup {
  const name = language.default.name ? `${language.default.name}Operations` : "";
  const doc = language.default.description;
  const ops = operations.reduce<CadlOperation[]>((acc, op) => {
    acc = [...acc, ...transformOperation(op, codeModel)];
    return acc;
  }, []);
  return {
    name,
    doc,
    operations: ops,
  };
}

function transformRoute(protocol?: Protocols) {
  return protocol?.http?.path;
}

function transformVerb(protocol?: Protocols) {
  return protocol?.http?.method;
}

function transformResponses(responses: SchemaResponse[] = [], codeModel: CodeModel) {
  const dataTypes = getDataTypes(codeModel);
  return responses.map(({ schema }) => {
    const responseName = dataTypes.get(schema)?.name;

    if (!responseName) {
      return "void";
    }

    if (schema.language.default.paging?.isPageable && schema.language.default.resource) {
      return `Azure.Core.ResourceList<${responseName}>`;
    }

    return responseName;
  });
}

export function transformOperation(operation: Operation, codeModel: CodeModel): CadlOperation[] {
  return (operation.requests ?? []).map((r) => transformRequest(r, operation, codeModel));
}

function transformRequest(_request: Request, operation: Operation, codeModel: CodeModel): CadlOperation {
  const { language, responses, requests } = operation;
  const name = language.default.name;
  const doc = language.default.description;
  const summary = language.default.summary;
  const { paging } = getLanguageMetadata(operation.language);
  const transformedResponses = transformResponses([...(responses ?? [])] as SchemaResponse[], codeModel);
  const visitedParameter: Set<Parameter> = new Set();
  let parameters = (operation.parameters ?? [])
    .filter((p) => filterOperationParameters(p, visitedParameter))
    .map((v) => transformParameter(v, codeModel));

  parameters = [
    ...parameters,
    ...getRequestParameters(operation)
      .filter((p) => filterOperationParameters(p, visitedParameter))
      .map((v) => transformParameter(v, codeModel)),
  ];

  const extensions: Extension[] = [];

  if (paging) {
    extensions.push("Pageable");
  }

  const resource = operation.language.default.resource;

  return {
    name,
    doc,
    summary,
    parameters,
    verb: transformVerb(requests?.[0].protocol),
    route: transformRoute(requests?.[0].protocol),
    responses: [...new Set(transformedResponses)],
    extensions: [],
    resource,
  };
}

function constantValueEquals(schema: Schema, match: string) {
  if (isConstantSchema(schema)) {
    const value = schema.value.value;
    if (typeof value === "string") {
      return value.toLowerCase() === match.toLowerCase();
    }
  }

  return false;
}

function filterOperationParameters(parameter: Parameter, visitedParameters: Set<Parameter>): boolean {
  if (
    parameter.protocol.http?.in === ParameterLocation.Query &&
    parameter.language.default.serializedName === "api-version"
  ) {
    return false;
  }

  if (
    parameter.origin === "modelerfour:synthesized/accept" &&
    constantValueEquals(parameter.schema, "application/json")
  ) {
    return false;
  }

  if (visitedParameters.has(parameter)) {
    return false;
  }

  const shouldVisit = ["path", "body", "header", "query"].includes(parameter.protocol.http?.in);

  if (shouldVisit) {
    visitedParameters.add(parameter);
  }

  return shouldVisit;
}

export function transformParameter(parameter: Parameter, codeModel: CodeModel): CadlParameter {
  // Body parameter doesn't have a serializedName, in that case we get the name
  const name = parameter.language.default.serializedName ?? parameter.language.default.name;
  const doc = parameter.language.default.description;

  const dataTypes = getDataTypes(codeModel);
  const visited = dataTypes.get(parameter.schema) ?? transformDataType(parameter.schema, codeModel);

  return {
    kind: "parameter",
    doc,
    name,
    isOptional: parameter.required !== true,
    type: visited.name,
    location: transformParameterLocation(parameter),
  };
}

function getRequestParameters(operation: Operation): Parameter[] {
  const logger = getLogger("getRequestParameters");
  if (!operation.requests?.length) {
    return [];
  }

  if (operation.requests.length > 1) {
    const message = `Operation ${operation.language.default.name} has more than one request`;
    logger.info(message);
  }

  const parameters = operation.requests[0].parameters ?? [];
  const signatureParameters = operation.requests[0].signatureParameters ?? [];

  return [...parameters, ...signatureParameters];
}

function transformParameterLocation(parameter: Parameter): CadlParameterLocation {
  const location: ParameterLocation = parameter.protocol.http?.in;

  if (!location) {
    throw new Error(`Parameter ${parameter.language.default.name} has no location defined`);
  }

  switch (location) {
    case ParameterLocation.Path:
      return "path";
    case ParameterLocation.Query:
      return "query";
    case ParameterLocation.Header:
      return "header";
    case ParameterLocation.Body:
      return "body";
    default:
      throw new Error(`Unknown location ${location}`);
  }
}
