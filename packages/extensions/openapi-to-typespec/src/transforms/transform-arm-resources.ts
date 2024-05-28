import { Operation, Parameter, Response, SchemaResponse, SchemaType } from "@autorest/codemodel";
import _ from "lodash";
import pluralize, { singular } from "pluralize";
import { getArmCommonTypeVersion, getSession } from "../autorest-session";
import { generateParameter } from "../generate/generate-parameter";
import {
  ArmResourceKind,
  TypespecDecorator,
  TypespecObjectProperty,
  TypespecOperation,
  TypespecParameter,
  TspArmResource,
  TspArmResourceOperation,
  isFirstLevelResource,
} from "../interfaces";
import { getOptions, updateOptions } from "../options";
import { createCSharpNameDecorator } from "../pretransforms/rename-pretransform";
import { getOperationClientDecorators } from "../utils/decorators";
import { generateDocs, generateDocsContent } from "../utils/docs";
import {
  ArmResource,
  ArmResourceSchema,
  OperationWithResourceOperationFlag,
  _ArmResourceOperation,
  getResourceExistOperation as getResourceExistsOperation,
  getResourceOperations,
  getSingletonResouceListOperation,
  isResourceSchema,
} from "../utils/resource-discovery";
import { isResponseSchema } from "../utils/schemas";
import {
  getSuppressionsForArmResourceDeleteAsync,
  getSuppressionsForArmResourceDeleteSync,
} from "../utils/suppressions";
import { getFullyQualifiedName } from "../utils/type-mapping";
import { getTypespecType, transformObjectProperty } from "./transform-object";
import { transformParameter, transformRequest } from "./transform-operations";

const generatedResourceObjects: Map<string, string> = new Map<string, string>();

export function isGeneratedResourceObject(name: string): boolean {
  return generatedResourceObjects.has(name);
}

export function replaceGeneratedResourceObject(name: string): string {
  return generatedResourceObjects.get(name) ?? name;
}

function addGeneratedResourceObjectIfNotExits(name: string, mapping: string) {
  if (generatedResourceObjects.has(name)) {
    return;
  }
  generatedResourceObjects.set(name, mapping);
}

export function transformTspArmResource(schema: ArmResourceSchema): TspArmResource {
  const fixMe: string[] = [];

  if (!getSession().configuration["namespace"]) {
    const segments = schema.resourceMetadata.GetOperations[0].Path.split("/");
    for (let i = segments.length - 1; i >= 0; i--) {
      if (segments[i] === "providers") {
        getSession().configuration["namespace"] = segments[i + 1];
        updateOptions();
        break;
      }
    }
  }

  // TODO: deal with a resource with multiple parents
  if (schema.resourceMetadata.Parents.length > 1) {
    fixMe.push(
      `// FIXME: ${schema.resourceMetadata.SwaggerModelName} has more than one parent, currently converter will only use the first one`,
    );
  }

  addGeneratedResourceObjectIfNotExits(schema.language.default.name, schema.language.default.name);

  const propertiesModel = schema.properties?.find((p) => p.serializedName === "properties");
  const propertiesModelSchema = propertiesModel?.schema;
  let propertiesModelName = propertiesModelSchema?.language.default.name;
  let propertiesPropertyRequired = false;
  let propertiesPropertyVisibility = ["read", "create"];
  let propertiesPropertyDescription = "";

  if (propertiesModelSchema?.type === SchemaType.Dictionary) {
    propertiesModelName = "Record<unknown>";
  } else if (propertiesModelSchema?.type === SchemaType.Object) {
    propertiesPropertyRequired = propertiesModel?.required ?? false;
    propertiesPropertyVisibility = propertiesModel?.extensions?.["x-ms-mutability"] ?? [];
    propertiesPropertyDescription = propertiesModel?.language.default.description ?? "";
  }

  // TODO: deal with resources that has no properties property
  if (!propertiesModelName) {
    fixMe.push(`// FIXME: ${schema.resourceMetadata.SwaggerModelName} has no properties property`);
    propertiesModelName = "{}";
  }

  const operations = getTspOperations(schema);

  let baseModelName = undefined;
  if (!getArmCommonTypeVersion()) {
    const immediateParents = schema.parents?.immediate ?? [];

    baseModelName = immediateParents
      .filter((p) => p.language.default.name !== schema.language.default.name)
      .map((p) => p.language.default.name)[0];
  }

  const decorators = buildResourceDecorators(schema);
  if (!getArmCommonTypeVersion() && schema.resourceMetadata.IsExtensionResource) {
    decorators.push({ name: "extensionResource" });
  }

  const armResourceOperations = operations[0];
  const otherOperations = operations[1];

  const clientDecorators = buildResourceClientDecorators(schema, armResourceOperations, otherOperations);
  const keyProperty = buildKeyProperty(schema);
  const properties = [...getOtherProperties(schema, !getArmCommonTypeVersion())];
  let keyExpression, augmentDecorators;
  if (keyProperty.name === "name" && keyProperty.type === "string") {
    keyExpression = buildKeyExpression(schema, keyProperty);
    augmentDecorators = buildKeyAugmentDecorators(schema, keyProperty);
  } else {
    properties.unshift(keyProperty);
  }

  return {
    fixMe,
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties,
    keyExpression,
    name: schema.resourceMetadata.SwaggerModelName,
    parents: [],
    resourceParent: getParentResource(schema),
    propertiesModelName,
    propertiesPropertyRequired,
    propertiesPropertyVisibility,
    propertiesPropertyDescription,
    doc: schema.language.default.description,
    decorators,
    clientDecorators,
    augmentDecorators,
    resourceOperations: armResourceOperations,
    normalOperations: otherOperations,
    optionalStandardProperties: getArmCommonTypeVersion() ? getResourceOptionalStandardProperties(schema) : [],
    baseModelName,
    locationParent: getLocationParent(schema),
  };
}

function getOtherProperties(schema: ArmResourceSchema, noCommonTypes: boolean): TypespecObjectProperty[] {
  const knownProperties = ["properties", "name"];
  if (!noCommonTypes) {
    knownProperties.push(...["id", "type", "systemData", "location", "tags", "identity", "sku", "eTag", "plan"]);
  }
  const otherProperties: TypespecObjectProperty[] = [];
  for (const property of schema.properties ?? []) {
    if (!knownProperties.includes(property.serializedName)) {
      otherProperties.push(transformObjectProperty(property, getSession().model));
    }
  }
  return otherProperties;
}

function getResourceOptionalStandardProperties(schema: ArmResourceSchema): string[] {
  const optionalStandardProperties = [];

  const msi = schema.properties?.find((p) => p.serializedName === "identity");
  if (msi) {
    let msiType;
    if (msi.schema.language.default.name === "ManagedServiceIdentity") {
      msiType = "Azure.ResourceManager.ManagedServiceIdentityProperty";
    } else if (msi.schema.language.default.name === "SystemAssignedServiceIdentity") {
      msiType = "Azure.ResourceManager.ManagedSystemAssignedIdentityProperty";
    } else {
      // TODO: handle non-standard property
      msiType = "Azure.ResourceManager.ManagedServiceIdentityProperty";
    }
    optionalStandardProperties.push(msiType);
  }

  if (schema.properties?.find((p) => p.serializedName === "sku")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourceSkuProperty");
  }

  if (schema.properties?.find((p) => p.serializedName === "eTag")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.EntityTagProperty");
  }

  if (schema.properties?.find((p) => p.serializedName === "plan")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourcePlanProperty");
  }

  return optionalStandardProperties;
}

function convertResourceReadOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  // every resource should have a get operation
  const operation = resourceMetadata.GetOperations[0];
  const swaggerOperation = operations[operation.OperationID];
  const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
  return [
    {
      doc: resourceMetadata.GetOperations[0].Description, // TODO: resource have duplicated CRUD operations
      kind: "ArmResourceRead",
      name: getOperationName(operation.OperationID),
      operationId: operation.OperationID,
      clientDecorators: getOperationClientDecorators(swaggerOperation),
      templateParameters: baseParameters
        ? [resourceMetadata.SwaggerModelName, baseParameters]
        : [resourceMetadata.SwaggerModelName],
      examples: swaggerOperation.extensions?.["x-ms-examples"],
    },
  ];
}

function convertResourceExistsOperation(resourceMetadata: ArmResource): TspArmResourceOperation[] {
  const swaggerOperation = getResourceExistsOperation(resourceMetadata);
  if (swaggerOperation) {
    return [
      {
        doc: swaggerOperation.language.default.description,
        kind: "ArmResourceExists",
        name: swaggerOperation.operationId ? getOperationName(swaggerOperation.operationId) : "exists",
        clientDecorators: getOperationClientDecorators(swaggerOperation),
        operationId: swaggerOperation.operationId,
        parameters: [
          `...ResourceInstanceParameters<${resourceMetadata.SwaggerModelName}, BaseParameters<${resourceMetadata.SwaggerModelName}>>`,
        ],
        responses: ["OkResponse", "ErrorResponse"],
        decorators: [{ name: "head" }],
        examples: swaggerOperation.extensions?.["x-ms-examples"],
      },
    ];
  }
  return [];
}

function getTSPOperationGroupName(resourceName: string): string {
  const operationGroupName = pluralize(resourceName);
  if (operationGroupName === resourceName) {
    return `${operationGroupName}OperationGroup`;
  } else {
    return operationGroupName;
  }
}

function convertResourceCreateOrReplaceOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  if (resourceMetadata.CreateOperations.length) {
    const operation = resourceMetadata.CreateOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
    const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
    const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
    const templateParameters = [resourceMetadata.SwaggerModelName];
    if (baseParameters) {
      templateParameters.push(baseParameters);
    }
    const tspOperationGroupName = getTSPOperationGroupName(resourceMetadata.SwaggerModelName);
    const operationName = getOperationName(operation.OperationID);
    const customizations = getCustomizations(
      bodyParam,
      tspOperationGroupName,
      operationName,
      "resource",
      "Resource create parameters.",
    );
    return [
      {
        doc: operation.Description,
        kind: isLongRunning ? "ArmResourceCreateOrReplaceAsync" : "ArmResourceCreateOrReplaceSync",
        name: operationName,
        clientDecorators: getOperationClientDecorators(swaggerOperation),
        operationId: operation.OperationID,
        templateParameters: templateParameters,
        examples: swaggerOperation.extensions?.["x-ms-examples"],
        customizations,
      },
    ];
  }
  return [];
}

function getCustomizations(
  bodyParam: Parameter | undefined,
  tspOperationGroupName: string,
  operationName: string,
  templateName: string,
  templateDoc: string,
) {
  const { isFullCompatible } = getOptions();

  const augmentedDecorators = [];
  if (bodyParam) {
    if (bodyParam.language.default.name !== templateName && isFullCompatible) {
      augmentedDecorators.push(
        `@@encodedName(${tspOperationGroupName}.\`${operationName}\`::parameters.${templateName}, "application/json", "${bodyParam.language.default.name}");`,
      );
      augmentedDecorators.push(
        `@@extension(${tspOperationGroupName}.\`${operationName}\`::parameters.${templateName}, "x-ms-client-name", "${bodyParam.language.default.name}");`,
      );
    }
    if (bodyParam.language.default.description !== templateDoc) {
      augmentedDecorators.push(
        `@@doc(${tspOperationGroupName}.\`${operationName}\`::parameters.${templateName}, "${bodyParam.language.default.description}");`,
      );
    }
  }
  return augmentedDecorators;
}

function convertResourceUpdateOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  if (resourceMetadata.UpdateOperations.length) {
    const operation = resourceMetadata.UpdateOperations[0];
    if (
      !resourceMetadata.CreateOperations.length ||
      resourceMetadata.CreateOperations[0].OperationID !== operation.OperationID
    ) {
      const swaggerOperation = operations[operation.OperationID];
      const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
      const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
      const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
      const fixMe: string[] = [];
      if (!bodyParam) {
        fixMe.push(
          "// FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property",
        );
      }

      const tspOperationGroupName = getTSPOperationGroupName(resourceMetadata.SwaggerModelName);
      const operationName = getOperationName(operation.OperationID);
      const customizations = getCustomizations(
        bodyParam,
        tspOperationGroupName,
        operationName,
        "properties",
        "The resource properties to be updated.",
      );

      let kind;
      const templateParameters = [resourceMetadata.SwaggerModelName];
      if (bodyParam) {
        kind = isLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync";
        templateParameters.push(bodyParam.schema.language.default.name);
      } else {
        kind = isLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync";
        templateParameters.push("{}");
      }
      if (baseParameters) {
        templateParameters.push(baseParameters);
      }
      return [
        {
          fixMe,
          doc: operation.Description,
          kind: kind as any,
          name: getOperationName(operation.OperationID),
          clientDecorators: getOperationClientDecorators(swaggerOperation),
          operationId: operation.OperationID,
          templateParameters,
          examples: swaggerOperation.extensions?.["x-ms-examples"],
          customizations,
          // To resolve auto-generate update model with proper visibility
          decorators: [{ name: "parameterVisibility", arguments: [] }],
        },
      ];
    }
  }
  return [];
}

function convertResourceDeleteOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  if (resourceMetadata.DeleteOperations.length) {
    const operation = resourceMetadata.DeleteOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
    const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
    const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
    const templateParameters = [resourceMetadata.SwaggerModelName];
    const kind = isLongRunning
      ? okResponse
        ? "ArmResourceDeleteAsync"
        : "ArmResourceDeleteWithoutOkAsync"
      : "ArmResourceDeleteSync";
    const suppressions =
      kind === "ArmResourceDeleteAsync"
        ? getSuppressionsForArmResourceDeleteAsync()
        : kind === "ArmResourceDeleteSync"
          ? getSuppressionsForArmResourceDeleteSync()
          : undefined;
    if (baseParameters) {
      templateParameters.push(baseParameters);
    }
    return [
      {
        doc: operation.Description,
        kind: kind,
        name: getOperationName(operation.OperationID),
        clientDecorators: getOperationClientDecorators(swaggerOperation),
        operationId: operation.OperationID,
        templateParameters,
        examples: swaggerOperation.extensions?.["x-ms-examples"],
        suppressions: suppressions,
      },
    ];
  }
  return [];
}

function convertResourceListOperations(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const converted: TspArmResourceOperation[] = [];

  // list by parent operation
  if (resourceMetadata.ListOperations.length) {
    // TODO: TParentName, TParentFriendlyName
    const operation = resourceMetadata.ListOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
    const templateParameters = [resourceMetadata.SwaggerModelName];
    const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
    if (baseParameters) {
      templateParameters.push(baseParameters);
    }

    addGeneratedResourceObjectIfNotExits(
      getSchemaResponseSchemaName(okResponse) ?? "",
      `ResourceListResult<${resourceMetadata.SwaggerModelName}>`,
    );

    converted.push({
      doc: operation.Description,
      kind: "ArmResourceListByParent",
      name: getOperationName(operation.OperationID),
      clientDecorators: getOperationClientDecorators(swaggerOperation),
      operationId: operation.OperationID,
      templateParameters: templateParameters,
      examples: swaggerOperation.extensions?.["x-ms-examples"],
    });
  }

  // list operation under subscription
  if (resourceMetadata.OperationsFromSubscriptionExtension.length) {
    for (const operation of resourceMetadata.OperationsFromSubscriptionExtension) {
      if (operation.PagingMetadata) {
        const swaggerOperation = operations[operation.OperationID];
        const okResponse = swaggerOperation?.responses?.filter(
          (o) => o.protocol.http?.statusCodes.includes("200"),
        )?.[0];
        const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);

        addGeneratedResourceObjectIfNotExits(
          getSchemaResponseSchemaName(okResponse) ?? "",
          `ResourceListResult<${resourceMetadata.SwaggerModelName}>`,
        );
        // either list in location or list in subscription
        if (operation.Path.includes("/locations/")) {
          const templateParameters = [
            resourceMetadata.SwaggerModelName,
            `LocationScope<${resourceMetadata.SwaggerModelName}>`,
          ];
          if (baseParameters) {
            templateParameters.push(baseParameters);
          }
          converted.push({
            doc: operation.Description,
            kind: "ArmResourceListAtScope",
            name: getOperationName(operation.OperationID),
            clientDecorators: getOperationClientDecorators(swaggerOperation),
            operationId: operation.OperationID,
            templateParameters,
            examples: swaggerOperation.extensions?.["x-ms-examples"],
          });
        } else {
          converted.push({
            doc: operation.Description,
            kind: "ArmListBySubscription",
            name: getOperationName(operation.OperationID),
            clientDecorators: getOperationClientDecorators(swaggerOperation),
            operationId: operation.OperationID,
            templateParameters: [resourceMetadata.SwaggerModelName],
            examples: swaggerOperation.extensions?.["x-ms-examples"],
          });
        }
      }
    }
  }

  // add list operation for singleton resource if exists
  if (resourceMetadata.IsSingletonResource) {
    const swaggerOperation = getSingletonResouceListOperation(resourceMetadata);
    if (swaggerOperation) {
      const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
      const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);

      addGeneratedResourceObjectIfNotExits(
        getSchemaResponseSchemaName(okResponse) ?? "",
        `ResourceListResult<${resourceMetadata.SwaggerModelName}>`,
      );
      converted.push({
        doc: swaggerOperation.language.default.description,
        kind: "ArmResourceListByParent",
        name: swaggerOperation.operationId
          ? getOperationName(swaggerOperation.operationId)
          : `listBy${resourceMetadata.Parents[0].replace(/Resource$/, "")}`,
        clientDecorators: getOperationClientDecorators(swaggerOperation),
        operationId: swaggerOperation.operationId,
        templateParameters: baseParameters
          ? [resourceMetadata.SwaggerModelName, baseParameters]
          : [resourceMetadata.SwaggerModelName],
        examples: swaggerOperation.extensions?.["x-ms-examples"],
      });
      (swaggerOperation as OperationWithResourceOperationFlag).isResourceOperation = true;
    }
  }

  return converted;
}

function convertResourceActionOperations(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const converted: TspArmResourceOperation[] = [];

  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      if (operation.Method === "POST") {
        const swaggerOperation = operations[operation.OperationID];
        const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
        const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
        const okResponse = swaggerOperation?.responses?.filter(
          (o) => o.protocol.http?.statusCodes.includes("200"),
        )?.[0];
        // TODO: deal with non-schema response for action
        let operationResponseName;
        if (okResponse && isResponseSchema(okResponse)) {
          if (!okResponse.schema.language.default.name.includes("·")) {
            operationResponseName = okResponse.schema.language.default.name;
          }
        }

        const request = bodyParam ? getTypespecType(bodyParam.schema, getSession().model) : "void";
        const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
        let kind;
        if (!okResponse) {
          // TODO: Sync operation should have a 204 response
          kind = isLongRunning ? "ArmResourceActionNoResponseContentAsync" : "ArmResourceActionNoContentSync";
        } else {
          kind = isLongRunning ? "ArmResourceActionAsync" : "ArmResourceActionSync";
        }
        const templateParameters = [resourceMetadata.SwaggerModelName, request];
        if (okResponse) {
          templateParameters.push(operationResponseName ?? "void");
        }
        if (baseParameters) {
          templateParameters.push(baseParameters);
        }

        const tspOperationGroupName = getTSPOperationGroupName(resourceMetadata.SwaggerModelName);
        const operationName = getOperationName(operation.OperationID);
        const customizations = getCustomizations(
          bodyParam,
          tspOperationGroupName,
          operationName,
          "body",
          "The content of the action request",
        );
        converted.push({
          doc: operation.Description,
          kind: kind as any,
          name: operationName,
          clientDecorators: getOperationClientDecorators(swaggerOperation),
          operationId: operation.OperationID,
          templateParameters,
          examples: swaggerOperation.extensions?.["x-ms-examples"],
          customizations,
        });
      }
    }
  }

  return converted;
}

function convertCheckNameAvailabilityOperations(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const converted: TspArmResourceOperation[] = [];

  // check name availability operation under subscription
  if (resourceMetadata.OperationsFromSubscriptionExtension.length) {
    for (const operation of resourceMetadata.OperationsFromSubscriptionExtension) {
      if (operation.Path.includes("/checkNameAvailability")) {
        const swaggerOperation = operations[operation.OperationID];
        const response =
          (
            swaggerOperation?.responses?.filter(
              (o) => o.protocol.http?.statusCodes.includes("200"),
            )?.[0] as SchemaResponse
          ).schema?.language.default.name ?? "CheckNameAvailabilityResponse";
        const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
        const request = bodyParam ? bodyParam.schema.language.default.name : "CheckNameAvailabilityRequest";
        if (operation.Path.includes("/locations/")) {
          converted.push({
            doc: operation.Description,
            kind: "checkLocalNameAvailability",
            name: getOperationName(operation.OperationID),
            clientDecorators: getOperationClientDecorators(swaggerOperation),
            operationId: operation.OperationID,
            examples: swaggerOperation.extensions?.["x-ms-examples"],
            templateParameters: [request, response],
          });
        } else {
          converted.push({
            doc: operation.Description,
            kind: "checkGlobalNameAvailability",
            name: getOperationName(operation.OperationID),
            clientDecorators: getOperationClientDecorators(swaggerOperation),
            operationId: operation.OperationID,
            examples: swaggerOperation.extensions?.["x-ms-examples"],
            templateParameters: [request, response],
          });
        }
      }
    }
  }

  return converted;
}

function convertResourceOtherGetOperations(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TypespecOperation[] {
  const converted: TypespecOperation[] = [];

  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      if (operation.Method === "GET") {
        const swaggerOperation = operations[operation.OperationID];
        if (swaggerOperation.requests && swaggerOperation.requests[0]) {
          const op = transformRequest(swaggerOperation.requests[0], swaggerOperation, getSession().model);
          op.operationGroupName = getOperationGroupName(operation.OperationID);
          op.operationId = operation.OperationID;
          if (!op.fixMe) {
            op.fixMe = [];
          }
          op.fixMe.push(`// FIXME: ${operation.OperationID} could not be converted to a resource operation`);
          op.examples = swaggerOperation.extensions?.["x-ms-examples"];
          converted.push(op);
        }
      }
    }
  }

  return converted;
}

function getTspOperations(armSchema: ArmResourceSchema): [TspArmResourceOperation[], TypespecOperation[]] {
  const resourceMetadata = armSchema.resourceMetadata;
  const operations = getResourceOperations(resourceMetadata);
  const tspOperations: TspArmResourceOperation[] = [];
  const normalOperations: TypespecOperation[] = [];

  // TODO: handle operations under resource group / management group / tenant

  // read operation
  tspOperations.push(...convertResourceReadOperation(resourceMetadata, operations));

  // exist operation
  tspOperations.push(...convertResourceExistsOperation(resourceMetadata));

  // create operation
  tspOperations.push(...convertResourceCreateOrReplaceOperation(resourceMetadata, operations));

  // patch update operation could either be patch for resource/tag or custom patch
  tspOperations.push(...convertResourceUpdateOperation(resourceMetadata, operations));

  // delete operation
  tspOperations.push(...convertResourceDeleteOperation(resourceMetadata, operations));

  // list operation
  tspOperations.push(...convertResourceListOperations(resourceMetadata, operations));

  // action operation
  tspOperations.push(...convertResourceActionOperations(resourceMetadata, operations));

  // check name availability operation
  tspOperations.push(...convertCheckNameAvailabilityOperations(resourceMetadata, operations));

  // other get operations
  normalOperations.push(...convertResourceOtherGetOperations(resourceMetadata, operations));

  return [tspOperations, normalOperations];
}

function getOperationName(name: string): string {
  return _.lowerFirst(_.last(name.split("_")));
}

function getOperationGroupName(name: string | undefined): string {
  if (name && name.includes("_")) {
    return _.first(name.split("_"))!;
  } else {
    return "";
  }
}

function buildOperationBaseParameters(operation: Operation, resource: ArmResource): string | undefined {
  const codeModel = getSession().model;
  const otherParameters: TypespecParameter[] = [];
  const pathParameters = [];
  resource.GetOperations[0].Path.split("/").forEach((p) => {
    if (p.match(/^{.+}$/)) {
      pathParameters.push(p.replace("{", "").replace("}", ""));
    }
  });
  pathParameters.push("api-version");
  pathParameters.push("$host");
  if (operation.parameters) {
    for (const parameter of operation.parameters) {
      if (resource.IsSingletonResource && parameter.schema.type === SchemaType.Constant) {
        continue;
      }
      if (!pathParameters.includes(parameter.language.default.serializedName)) {
        otherParameters.push(transformParameter(parameter, codeModel));
      }
    }
  }

  let parameterTemplate = `${getFullyQualifiedName("BaseParameters")}<${resource.SwaggerModelName}>`;
  if (resource.IsExtensionResource) {
    parameterTemplate = `${getFullyQualifiedName("ExtensionBaseParameters")}`;
  } else if (resource.IsTenantResource) {
    parameterTemplate = `${getFullyQualifiedName("TenantBaseParameters")}`;
  } else if (resource.IsSubscriptionResource) {
    parameterTemplate = `${getFullyQualifiedName("SubscriptionBaseParameters")}`;
  }

  if (otherParameters.length) {
    const params: string[] = [];
    for (const parameter of otherParameters) {
      params.push(generateParameter(parameter));
    }
    return `{
    ...${parameterTemplate};
    ${params.join(";\n")}
    }`;
  }
}

function getKeyParameter(resourceMetadata: ArmResource): Parameter | undefined {
  for (const operationGroup of getSession().model.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (operation.operationId === resourceMetadata.GetOperations[0].OperationID) {
        for (const parameter of operation.parameters ?? []) {
          if (parameter.language.default.serializedName === resourceMetadata.ResourceKey) {
            return parameter;
          }
        }
      }
    }
  }
}

function generateSingletonKeyParameter(): TypespecParameter {
  return {
    kind: "parameter",
    name: "name",
    isOptional: false,
    type: "string",
    location: "path",
    serializedName: "name",
  };
}

function getParentResource(schema: ArmResourceSchema): TspArmResource | undefined {
  const resourceParent = schema.resourceMetadata.Parents?.[0];

  if (!resourceParent || isFirstLevelResource(resourceParent)) {
    return undefined;
  }

  for (const objectSchema of getSession().model.schemas.objects ?? []) {
    if (!isResourceSchema(objectSchema)) {
      continue;
    }

    if (objectSchema.resourceMetadata.Name === resourceParent) {
      return transformTspArmResource(objectSchema);
    }
  }
}

function getResourceKind(schema: ArmResourceSchema): ArmResourceKind {
  if (schema.resourceMetadata.IsExtensionResource) {
    return "ExtensionResource";
  }

  if (schema.resourceMetadata.IsTrackedResource) {
    return "TrackedResource";
  }

  return "ProxyResource";
}

function getSchemaResponseSchemaName(response: Response | undefined): string | undefined {
  if (!response || !(response as SchemaResponse).schema) {
    return undefined;
  }

  return (response as SchemaResponse).schema.language.default.name;
}

function buildKeyExpression(schema: ArmResourceSchema, keyProperty: TypespecObjectProperty): string {
  const namePattern = keyProperty.decorators?.find((d) => d.name === "pattern")?.arguments?.[0];
  const keyName = keyProperty.decorators?.find((d) => d.name === "key")?.arguments?.[0];
  const segmentName = keyProperty.decorators?.find((d) => d.name === "segment")?.arguments?.[0];
  return `...ResourceNameParameter<
    Resource = ${schema.resourceMetadata.SwaggerModelName}
    ${keyName ? `, KeyName = "${keyName}"` : ""}
    ${segmentName ? `, SegmentName = "${segmentName}"` : ""},
    NamePattern = ${namePattern ? `"${namePattern}"` : `""`}
  >`;
}

function buildKeyAugmentDecorators(
  schema: ArmResourceSchema,
  keyProperty: TypespecObjectProperty,
): TypespecDecorator[] | undefined {
  return keyProperty.decorators
    ?.filter((d) => !["pattern", "key", "segment", "path"].includes(d.name))
    .filter((d) => !(d.name === "visibility" && d.arguments?.[0] === "read"))
    .map((d) => {
      d.target = `${schema.resourceMetadata.SwaggerModelName}.name`;
      return d;
    })
    .concat({
      name: "doc",
      target: `${schema.resourceMetadata.SwaggerModelName}.name`,
      arguments: [generateDocsContent(keyProperty)],
    });
}

function buildKeyProperty(schema: ArmResourceSchema): TypespecObjectProperty {
  let parameter;
  if (!schema.resourceMetadata.IsSingletonResource) {
    const keyProperty = getKeyParameter(schema.resourceMetadata);
    if (!keyProperty) {
      throw new Error(
        `Failed to find key property ${schema.resourceMetadata.ResourceKey} for ${schema.language.default.name}`,
      );
    }
    parameter = transformParameter(keyProperty, getSession().model);
  } else {
    parameter = generateSingletonKeyParameter();
  }

  if (!parameter.decorators) {
    parameter.decorators = [];
  }

  parameter.decorators.push(
    {
      name: "key",
      arguments: [
        schema.resourceMetadata.IsSingletonResource
          ? singular(schema.resourceMetadata.ResourceKeySegment)
          : schema.resourceMetadata.ResourceKey,
      ],
    },
    {
      name: "segment",
      arguments: [schema.resourceMetadata.ResourceKeySegment],
    },
    {
      name: "visibility",
      arguments: ["read"],
    },
  );

  // remove @path decorator for key parameter
  // TODO: still under discussion with TSP team about this behavior, in order to keep generated swagger good, comment out for now
  // parameter.decorators = parameter.decorators.filter((d) => d.name !== "path");

  // by convention the property itself needs to be called "name"
  parameter.name = "name";

  return { ...parameter, kind: "property" };
}

function buildResourceDecorators(schema: ArmResourceSchema): TypespecDecorator[] {
  const resourceModelDecorators: TypespecDecorator[] = [];

  if (schema.resourceMetadata.IsSingletonResource) {
    resourceModelDecorators.push({
      name: "singleton",
      arguments: [getSingletonName(schema)],
    });
  }

  if (schema.resourceMetadata.IsTenantResource) {
    resourceModelDecorators.push({
      name: "tenantResource",
    });
  } else if (schema.resourceMetadata.IsSubscriptionResource) {
    resourceModelDecorators.push({
      name: "subscriptionResource",
    });
  }

  return resourceModelDecorators;
}

function buildResourceClientDecorators(
  schema: ArmResourceSchema,
  armResourceOperations: TspArmResourceOperation[],
  normalOperations: TypespecOperation[],
): TypespecDecorator[] {
  const clientDecorator: TypespecDecorator[] = [];
  if (schema.language.csharp?.name) {
    clientDecorator.push(createCSharpNameDecorator(schema));
  }

  return clientDecorator;
}

function getSingletonName(schema: ArmResourceSchema): string {
  const key = schema.resourceMetadata.ResourceKey;
  const pathLast = schema.resourceMetadata.GetOperations[0].Path.split("/").pop() ?? "";
  if (key !== pathLast) {
    if (pathLast?.includes("{")) {
      // this is from c# config, which need confirm with service
      return "default";
    } else {
      return pathLast;
    }
  }
  return key;
}

function getLocationParent(schema: ArmResourceSchema): string | undefined {
  if (schema.resourceMetadata.GetOperations[0].Path.includes("/locations/")) {
    if (schema.resourceMetadata.IsTenantResource) {
      return "TenantLocationResource";
    } else if (schema.resourceMetadata.IsSubscriptionResource) {
      return "SubscriptionLocationResource";
    } else if (schema.resourceMetadata.Parents?.[0] === "ResourceGroupResource") {
      return "ResourceGroupLocationResource";
    }
  }
}
