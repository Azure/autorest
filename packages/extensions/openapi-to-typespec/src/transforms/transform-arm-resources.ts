import {
  CodeModel,
  ObjectSchema,
  Operation,
  Parameter,
  Response,
  SchemaResponse,
  SchemaType,
} from "@autorest/codemodel";
import _ from "lodash";
import { singular } from "pluralize";
import { getSession } from "../autorest-session";
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
import { updateOptions } from "../options";
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
import { transformObjectProperty } from "./transform-object";
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

  const propertiesModelSchema = schema.properties?.find((p) => p.serializedName === "properties")?.schema;
  let propertiesModelName = propertiesModelSchema?.language.default.name;

  if (propertiesModelSchema?.type === SchemaType.Dictionary) {
    propertiesModelName = "Record<unknown>";
  }

  // TODO: deal with resources that has no properties property
  if (!propertiesModelName) {
    fixMe.push(`// FIXME: ${schema.resourceMetadata.SwaggerModelName} has no properties property`);
    propertiesModelName = "{}";
  }

  const operations = getTspOperations(schema);

  return {
    fixMe,
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties: [buildKeyProperty(schema), ...getOtherProperties(schema)],
    name: schema.resourceMetadata.SwaggerModelName,
    parents: [],
    resourceParent: getParentResource(schema),
    propertiesModelName,
    doc: schema.language.default.description,
    decorators: buildResourceDecorators(schema),
    resourceOperations: operations[0],
    normalOperations: operations[1],
    optionalStandardProperties: getResourceOptionalStandardProperties(schema),
  };
}

function getOtherProperties(schema: ArmResourceSchema): TypespecObjectProperty[] {
  const knownProperties = [
    "properties",
    "id",
    "name",
    "type",
    "systemData",
    "location",
    "tags",
    "identity",
    "sku",
    "eTag",
    "plan",
    "kind",
    "managedBy",
  ];
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
      msiType = "Azure.ResourceManager.ManagedServiceIdentity";
    } else if (msi.schema.language.default.name === "SystemAssignedServiceIdentity") {
      msiType = "Azure.ResourceManager.ManagedSystemAssignedIdentity";
    } else {
      // TODO: handle non-standard property
      msiType = "Azure.ResourceManager.ManagedServiceIdentity";
    }
    optionalStandardProperties.push(msiType);
  }

  if (schema.properties?.find((p) => p.serializedName === "sku")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourceSku");
  }

  if (schema.properties?.find((p) => p.serializedName === "eTag")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.EntityTag");
  }

  if (schema.properties?.find((p) => p.serializedName === "plan")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourcePlan");
  }

  if (schema.properties?.find((p) => p.serializedName === "kind")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourceKind");
  }

  if (schema.properties?.find((p) => p.serializedName === "managedBy")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ManagedBy");
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
      operationGroupName: getOperationGroupName(operation.OperationID),
      templateParameters: baseParameters
        ? [resourceMetadata.SwaggerModelName, baseParameters]
        : [resourceMetadata.SwaggerModelName],
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
        operationGroupName: getOperationGroupName(swaggerOperation.operationId),
        parameters: [
          `...ResourceInstanceParameters<${resourceMetadata.SwaggerModelName}, BaseParameters<${resourceMetadata.SwaggerModelName}>>`,
        ],
        responses: ["OkResponse", "ErrorResponse"],
        decorators: [{ name: "head" }],
      },
    ];
  }
  return [];
}

function convertResourceCreateOrUpdateOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  if (resourceMetadata.CreateOperations.length) {
    const operation = resourceMetadata.CreateOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
    const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
    return [
      {
        doc: operation.Description,
        kind: isLongRunning ? "ArmResourceCreateOrUpdateAsync" : "ArmResourceCreateOrReplaceSync",
        name: getOperationName(operation.OperationID),
        operationGroupName: getOperationGroupName(operation.OperationID),
        templateParameters: baseParameters
          ? [resourceMetadata.SwaggerModelName, baseParameters]
          : [resourceMetadata.SwaggerModelName],
      },
    ];
  }
  return [];
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
          operationGroupName: getOperationGroupName(operation.OperationID),
          templateParameters,
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

    return [
      {
        doc: operation.Description,
        kind: isLongRunning
          ? okResponse
            ? "ArmResourceDeleteAsync"
            : "ArmResourceDeleteWithoutOkAsync"
          : "ArmResourceDeleteSync",
        name: getOperationName(operation.OperationID),
        operationGroupName: getOperationGroupName(operation.OperationID),
        templateParameters: baseParameters
          ? [resourceMetadata.SwaggerModelName, baseParameters]
          : [resourceMetadata.SwaggerModelName],
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
      operationGroupName: getOperationGroupName(operation.OperationID),
      templateParameters: templateParameters,
    });
  }

  // operation under subscription
  if (resourceMetadata.OperationsFromSubscriptionExtension.length) {
    for (const operation of resourceMetadata.OperationsFromSubscriptionExtension) {
      // TODO: handle other kinds of operations
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
            operationGroupName: getOperationGroupName(operation.OperationID),
            templateParameters,
          });
        } else {
          converted.push({
            doc: operation.Description,
            kind: "ArmListBySubscription",
            name: getOperationName(operation.OperationID),
            operationGroupName: getOperationGroupName(operation.OperationID),
            templateParameters: [resourceMetadata.SwaggerModelName],
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
        operationGroupName: getOperationGroupName(swaggerOperation.operationId),
        templateParameters: baseParameters
          ? [resourceMetadata.SwaggerModelName, baseParameters]
          : [resourceMetadata.SwaggerModelName],
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

        const request = buildOperationBodyRequest(swaggerOperation, resourceMetadata) ?? "void";
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
        converted.push({
          doc: operation.Description,
          kind: kind as any,
          name: getOperationName(operation.OperationID),
          operationGroupName: getOperationGroupName(operation.OperationID),
          templateParameters,
        });
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
          if (!op.fixMe) {
            op.fixMe = [];
          }
          op.fixMe.push(`// FIXME: ${operation.OperationID} could not be converted to a resource operation`);
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
  tspOperations.push(...convertResourceCreateOrUpdateOperation(resourceMetadata, operations));

  // patch update operation could either be patch for resource/tag or custom patch
  tspOperations.push(...convertResourceUpdateOperation(resourceMetadata, operations));

  // delete operation
  tspOperations.push(...convertResourceDeleteOperation(resourceMetadata, operations));

  // list operation
  tspOperations.push(...convertResourceListOperations(resourceMetadata, operations));

  // action operation
  tspOperations.push(...convertResourceActionOperations(resourceMetadata, operations));

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

function buildOperationBodyRequest(operation: Operation, resource: ArmResource): string | undefined {
  const codeModel = getSession().model;
  const bodyParam: Parameter | undefined = operation.requests?.[0].parameters?.find(
    (p) => p.protocol.http?.in === "body",
  );
  if (bodyParam) {
    const transformed = transformParameter(bodyParam, codeModel);
    return transformed.type;
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
      if (!pathParameters.includes(parameter.language.default.serializedName)) {
        otherParameters.push(transformParameter(parameter, codeModel));
      }
    }
  }

  if (otherParameters.length) {
    const params: string[] = [];
    for (const parameter of otherParameters) {
      params.push(generateParameter(parameter));
    }
    return `{
    ...BaseParameters<${resource.SwaggerModelName}>,
    ${params.join("\n")}
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
      arguments: [schema.resourceMetadata.IsSingletonResource ? singular(schema.resourceMetadata.ResourceKeySegment) : schema.resourceMetadata.ResourceKey],
    },
    {
      name: "segment",
      arguments: [schema.resourceMetadata.ResourceKeySegment],
    },
  );

  // remove @path decorator for key parameter
  parameter.decorators = parameter.decorators.filter((d) => d.name !== "path");

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
    // TODO: need to change after TSP support location resource for other resource types
    if (schema.resourceMetadata.GetOperations[0].Path.includes("/locations/")) {
      resourceModelDecorators.push({
        name: "locationResource",
      });
    } else {
      resourceModelDecorators.push({
        name: "subscriptionResource",
      });
    }
  }

  return resourceModelDecorators;
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
