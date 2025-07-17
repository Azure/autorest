import {
  CodeModel,
  Operation,
  OperationGroup,
  Parameter,
  ParameterLocation,
  Protocols,
  Request,
  Response,
  Schema,
} from "@autorest/codemodel";
import _, { capitalize } from "lodash";
import { OperationWithResourceOperationFlag } from "utils/resource-discovery";
import { getDataTypes } from "../data-types";
import {
  TypespecOperation,
  TypespecOperationGroup,
  TypespecParameter,
  TypespecParameterLocation,
  Extension,
  TspArmProviderActionOperation,
  TypespecDecorator,
  TypespecTemplateModel,
} from "../interfaces";
import { transformDataType } from "../model";
import { getOptions } from "../options";
import { getOperationClientDecorators, getPropertyDecorators } from "../utils/decorators";
import { getLogger } from "../utils/logger";
import { getLanguageMetadata } from "../utils/metadata";
import { generateAdditionalProperties, generateTemplateModel } from "../utils/model-generation";
import {
  getSwaggerOperationGroupName,
  getSwaggerOperationName,
  getTSPNonResourceOperationGroupName,
} from "../utils/operation-group";
import { transformSchemaResponse } from "../utils/response";
import { isConstantSchema, isResponseSchema } from "../utils/schemas";
import { getSuppressionWithCode, SuppressionCode } from "../utils/suppressions";
import { getDefaultValue } from "../utils/values";

export function transformOperationGroup(
  { language, operations }: OperationGroup,
  codeModel: CodeModel,
): TypespecOperationGroup {
  const name = language.default.name ? getTSPNonResourceOperationGroupName(language.default.name) : "";
  const doc = language.default.description;
  const ops = operations.reduce<(TypespecOperation | TspArmProviderActionOperation)[]>((acc, op) => {
    acc = [...acc, ...transformOperation(op, codeModel, name)];
    return acc;
  }, []);
  const { isArm, isFullCompatible } = getOptions();
  const suppressions =
    isArm && isFullCompatible
      ? [getSuppressionWithCode(SuppressionCode.ArmResourceInterfaceRequiresDecorator)]
      : undefined;
  return {
    name,
    doc,
    operations: ops,
    suppressions,
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
  if (!isResponseSchema(response)) {
    return [statusCode, "void"];
  }

  const transformedResponse = transformSchemaResponse(response);
  const responseName =
    transformedResponse.kind === "template"
      ? generateTemplateModel(transformedResponse as TypespecTemplateModel)
      : `${transformedResponse.name}${
          transformedResponse.additionalProperties
            ? `& {${generateAdditionalProperties(transformedResponse.additionalProperties)}}`
            : ""
        }`;
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
    if ((operation as OperationWithResourceOperationFlag).isResourceOperation || isListOperation(operation)) {
      return [];
    }
  }
  return (operation.requests ?? []).map((r) => transformRequest(r, operation, codeModel, groupName));
}

export function isListOperation(operation: Operation): boolean {
  return transformRoute(operation.requests?.[0].protocol)?.match(/^\/providers\/[^/]+\/operations$/);
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
  const transformedResponses = transformResponses(responses ?? []);
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
  const decorators: TypespecDecorator[] = [];
  const clientDecorators: TypespecDecorator[] = [];

  const swaggerOperationGroupName = getSwaggerOperationGroupName(operation.operationId ?? "");
  if (swaggerOperationGroupName !== capitalize(groupName ?? "")) {
    clientDecorators.push({
      name: "clientLocation",
      module: "@azure-tools/typespec-client-generator-core",
      namespace: "Azure.ClientGenerator.Core",
      arguments: [swaggerOperationGroupName],
    });
  }

  const swaggerOperationName = getSwaggerOperationName(operation.operationId ?? "");
  if (swaggerOperationName !== capitalize(name)) {
    clientDecorators.push({
      name: "clientName",
      module: "@azure-tools/typespec-client-generator-core",
      namespace: "Azure.ClientGenerator.Core",
      arguments: [swaggerOperationName],
    });
  }

  if (`${capitalize(swaggerOperationGroupName)}_${capitalize(swaggerOperationName)}` !== operation.operationId && isFullCompatible) {
    decorators.push({
      name: "operationId",
      arguments: [operation.operationId!],
      module: "@typespec/openapi",
      namespace: "TypeSpec.OpenAPI",
      suppressionCode: "@azure-tools/typespec-azure-core/no-openapi",
      suppressionMessage: "non-standard operations",
    });
  }

  if (isArm) {
    const route = transformRoute(requests?.[0].protocol);
    if (route.startsWith("/subscriptions/{subscriptionId}/providers/") || route.startsWith("/providers/")) {
      const action = getActionForPrviderTemplate(route);
      if (action !== undefined) {
        const isLongRunning = operation.extensions?.["x-ms-long-running-operation"] ?? false;
        decorators.push({
          name: "autoRoute",
          module: "@typespec/rest",
          namespace: "TypeSpec.Rest",
        });

        const verb = transformVerb(requests?.[0].protocol);

        // For Async, there should be a 202 response without body and might be a 200 response with body
        // For Sync, there might be a 200 response with body
        const response = transformedResponses.find((r) => r[0] === "200")?.[1] ?? undefined;
        const finalStateVia =
          operation.extensions?.["x-ms-long-running-operation-options"]?.["final-state-via"] ?? "location";
        const lroHeaders =
          isLongRunning && finalStateVia === "azure-async-operation" ? "Azure-AsyncOperation" : undefined;
        const suppressions =
          isFullCompatible && lroHeaders ? [getSuppressionWithCode(SuppressionCode.LroLocationHeader)] : undefined;
        return {
          kind: isLongRunning ? "ArmProviderActionAsync" : "ArmProviderActionSync",
          doc,
          summary,
          name,
          verb: verb === "post" ? undefined : verb,
          action: action === name ? undefined : action,
          scope: route.startsWith("/providers/") ? undefined : "SubscriptionActionScope",
          response,
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
          lroHeaders,
          suppressions,
          examples: operation.extensions?.["x-ms-examples"],
          operationId: operation.operationId,
          clientDecorators,
        };
      }
    }
  }

  return {
    name,
    doc,
    summary,
    parameters,
    clientDecorators: clientDecorators.concat(getOperationClientDecorators(operation)),
    verb: transformVerb(requests?.[0].protocol),
    route: transformRoute(requests?.[0].protocol),
    responses: transformedResponses,
    extensions: [],
    resource,
    decorators,
    examples: operation.extensions?.["x-ms-examples"],
    operationId: operation.operationId,
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

  if (parameter.origin === "modelerfour:synthesized/accept") {
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
    suppressions: !doc && isFullCompatible ? [getSuppressionWithCode(SuppressionCode.DocumentRequired)] : undefined,
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
