import {
  ArraySchema,
  CodeModel,
  ObjectSchema,
  Operation,
  OperationGroup,
  Parameter,
  ParameterLocation,
  Protocols,
  Request,
  Response,
  Schema,
  SchemaResponse,
} from "@autorest/codemodel";
import { Case } from "change-case-all";
import _ from "lodash";
import { OperationWithResourceOperationFlag } from "utils/resource-discovery";
import { getSession } from "../autorest-session";
import { getDataTypes } from "../data-types";
import {
  TypespecOperation,
  TypespecOperationGroup,
  TypespecParameter,
  TypespecParameterLocation,
  Extension,
  TspArmProviderActionOperation,
} from "../interfaces";
import { transformDataType } from "../model";
import { getOptions } from "../options";
import { createOperationIdDecorator, getOperationClientDecorators, getPropertyDecorators } from "../utils/decorators";
import { getLogger } from "../utils/logger";
import { getLanguageMetadata } from "../utils/metadata";
import { isArraySchema, isConstantSchema, isResponseSchema } from "../utils/schemas";
import { isResourceListResult } from "../utils/type-mapping";
import { getDefaultValue } from "../utils/values";
import { getSuppresssionWithCode } from "../utils/suppressions";

export function transformOperationGroup(
  { language, operations }: OperationGroup,
  codeModel: CodeModel,
): TypespecOperationGroup {
  const name = language.default.name ? `${language.default.name}Operations` : "";
  const doc = language.default.description;
  const ops = operations.reduce<(TypespecOperation | TspArmProviderActionOperation)[]>((acc, op) => {
    acc = [...acc, ...transformOperation(op, codeModel, name)];
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

function transformResponse(response: Response): [string, string] {
  const statusCode = response.protocol.http?.statusCodes[0] as string;
  const codeModel = getSession().model;
  const dataTypes = getDataTypes(codeModel);
  if (!isResponseSchema(response)) {
    return [statusCode, "void"];
  }

  if (isResourceListResult(response)) {
    const valueSchema = ((response as SchemaResponse).schema as ObjectSchema).properties?.find(
      (p) => p.language.default.name === "value",
    );
    const responseName = dataTypes.get((valueSchema!.schema as ArraySchema).elementType)?.name;
    return [statusCode, `ResourceListResult<${responseName ?? "void"}>`];
  }

  const schema = response.schema;
  if (isArraySchema(schema)) {
    const itemName = dataTypes.get(schema.elementType)?.name;
    return [statusCode, `${itemName}[]`];
  }

  const responseName = dataTypes.get(schema)?.name;

  if (!responseName) {
    return [statusCode, "void"];
  }

  if (schema.language.default.paging?.isPageable && schema.language.default.resource) {
    return [statusCode, `Azure.Core.ResourceList<${responseName}>`];
  }

  return [statusCode, responseName];
}

function transformResponses(responses: Response[] = []): [string, string][] {
  return responses.map((r) => transformResponse(r));
}

function transformOperation(
  operation: Operation,
  codeModel: CodeModel,
  groupName: string,
): (TypespecOperation | TspArmProviderActionOperation)[] {
  const { isArm } = getOptions();
  if (isArm) {
    if (
      (operation as OperationWithResourceOperationFlag).isResourceOperation ||
      transformRoute(operation.requests?.[0].protocol)?.match(/^\/providers\/[^/]+\/operations$/)
    ) {
      return [];
    }
  }
  return (operation.requests ?? []).map((r) => transformRequest(r, operation, codeModel, groupName));
}

export function transformRequest(
  _request: Request,
  operation: Operation,
  codeModel: CodeModel,
  groupName: string | undefined = undefined,
): TypespecOperation | TspArmProviderActionOperation {
  const { isFullCompatible, isArm } = getOptions();
  const { language, responses, requests } = operation;
  const name = _.lowerFirst(language.default.name);
  const doc = language.default.description;
  const summary = language.default.summary;
  const { paging } = getLanguageMetadata(operation.language);
  const transformedResponses = transformResponses([...(responses ?? [])]);
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
  let decorators = undefined;
  if (
    groupName &&
    operation.operationId &&
    operation.operationId !== `${Case.pascal(groupName)}_${Case.pascal(name)}`
  ) {
    const decorator = createOperationIdDecorator(operation.operationId!);
    if (isFullCompatible) {
      decorator.suppressionCode = "@azure-tools/typespec-azure-core/no-openapi";
      decorator.suppressionMessage = "non-standard operations";
    }
    decorators = [decorator];
  }

  if (isArm) {
    const route = transformRoute(requests?.[0].protocol);
    if (route.startsWith("/subscriptions/{subscriptionId}/providers/") || route.startsWith("/providers/")) {
      const action = getActionForPrviderTemplate(route);
      if (action !== undefined) {
        const isLongRunning = operation.extensions?.["x-ms-long-running-operation"] ?? false;
        return {
          kind: isLongRunning ? "ArmProviderActionAsync" : "ArmProviderActionSync",
          doc,
          summary,
          name,
          verb: transformVerb(requests?.[0].protocol),
          action: action === name ? undefined : action,
          scope: route.startsWith("/providers/") ? "TenantActionScope" : "SubscriptionActionScope",
          responses: transformedResponses.map((r) => r[1]),
          parameters: parameters
            .filter((p) => p.location !== "body")
            .map((p) => {
              if (p.location === "path") {
                const segment = getSegmentForPathParameter(route, p.name);
                if (p.decorators === undefined) p.decorators = [];
                p.decorators.push({
                  name: "segment",
                  arguments: [segment],
                });
              }
              return p;
            }),
          request: parameters.find((p) => p.location === "body"),
          decorators,
        };
      }
    }
  }

  return {
    name,
    doc,
    summary,
    parameters,
    clientDecorators: getOperationClientDecorators(operation),
    verb: transformVerb(requests?.[0].protocol),
    route: transformRoute(requests?.[0].protocol),
    responses: transformedResponses,
    extensions: [],
    resource,
    decorators,
  };
}

function getActionForPrviderTemplate(route: string): string | undefined {
  const segments = route.split("/");
  const lastVariableIndex = segments.findLastIndex((s) => s.match(/^\{\w+\}$/) !== null);
  const lastProviderIndex = segments.findLastIndex((s) => s === "providers");
  if (lastVariableIndex > lastProviderIndex + 1 && lastVariableIndex !== segments.length - 1) {
    return segments.slice(lastVariableIndex + 1).join("/");
  }
  if (lastVariableIndex < lastProviderIndex && lastProviderIndex + 1 < segments.length - 1) {
    return segments.slice(lastProviderIndex + 2).join("/");
  }
  return undefined;
}

function getSegmentForPathParameter(route: string, parameter: string): string {
  const segments = route.split("/");
  const variableIndex = segments.findIndex((s) => s === `{${parameter}}`);
  if (variableIndex < 1) throw `Cannot find parameter ${parameter} in route ${route}`;
  return segments[variableIndex - 1];
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

export function transformParameter(parameter: Parameter, codeModel: CodeModel): TypespecParameter {
  const { isFullCompatible } = getOptions();
  // Body parameter doesn't have a serializedName, in that case we get the name
  const name = parameter.language.default.name;
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
    decorators: getPropertyDecorators(parameter),
    serializedName: parameter.language.default.serializedName ?? parameter.language.default.name,
    defaultValue: getDefaultValue(visited.name, parameter.schema),
    suppressions:
      !doc && isFullCompatible
        ? [getSuppresssionWithCode("@azure-tools/typespec-azure-core/documentation-required")]
        : undefined,
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

function transformParameterLocation(parameter: Parameter): TypespecParameterLocation {
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
