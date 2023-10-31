import { CodeModel, ObjectSchema, Operation, Parameter, Response, SchemaResponse } from "@autorest/codemodel";
import _ from "lodash";
import pluralize from "pluralize";
import { getSession } from "../autorest-session";
import { generateParameter } from "../generate/generate-parameter";
import {
  ArmResourceKind,
  CadlDecorator,
  CadlObjectProperty,
  CadlOperation,
  CadlParameter,
  TspArmResource,
  TspArmResourceOperation,
  isFirstLevelResource,
} from "../interfaces";
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

  // TODO: deal with a resource with multiple parents
  if (schema.resourceMetadata.Parents.length > 1) {
    fixMe.push(
      `// FIXME: ${schema.resourceMetadata.Name} has more than one parent, currently converter will only use the first one`,
    );
  }

  addGeneratedResourceObjectIfNotExits(schema.language.default.name, schema.resourceMetadata.Name);

  let propertiesModelName = schema.properties?.find((p) => p.serializedName === "properties")?.schema.language.default
    .name;

  // TODO: deal with resources that has no properties property
  if (!propertiesModelName) {
    fixMe.push(`// FIXME: ${schema.resourceMetadata.Name} has no properties property`);
    propertiesModelName = "{}";
  }

  const operations = getTspOperations(schema, propertiesModelName);

  return {
    resourceGroupName: pluralize(schema.resourceMetadata.Name),
    fixMe,
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties: [buildKeyProperty(schema), ...getOtherProperties(schema)],
    name: schema.resourceMetadata.Name,
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

function getOtherProperties(schema: ArmResourceSchema): CadlObjectProperty[] {
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
    "etag",
    "plan",
    "kind",
    "managedBy",
  ];
  const otherProperties: CadlObjectProperty[] = [];
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
      templateParameters: baseParameters ? [resourceMetadata.Name, baseParameters] : [resourceMetadata.Name],
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
        parameters: [
          `...ResourceInstanceParameters<${resourceMetadata.Name}, BaseParameters<${resourceMetadata.Name}>>`,
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
        templateParameters: baseParameters ? [resourceMetadata.Name, baseParameters] : [resourceMetadata.Name],
      },
    ];
  }
  return [];
}

function convertResourceUpdateOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
  resourcePropertiesModelName: string,
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
      const propertiesProperty = (bodyParam?.schema as ObjectSchema).properties?.find(
        (p) => p.serializedName === "properties",
      );
      const tagsProperty = (bodyParam?.schema as ObjectSchema).properties?.find((p) => p.serializedName === "tags");
      const fixMe: string[] = [];
      if (!bodyParam || (!propertiesProperty && !tagsProperty)) {
        fixMe.push(
          "// FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property",
        );
      }
      let kind;
      const templateParameters = [resourceMetadata.Name];
      if (propertiesProperty) {
        kind = isLongRunning ? "ArmResourcePatchAsync" : "ArmResourcePatchSync";
        // TODO: if update properties are different from resource properties, we need to use a different model
        templateParameters.push(resourcePropertiesModelName);
        addGeneratedResourceObjectIfNotExits(
          bodyParam?.schema.language.default.name ?? "",
          `ResourceUpdateModel<${resourceMetadata.Name}>`,
        );
        if (propertiesProperty.schema.language.default.name !== resourcePropertiesModelName) {
          addGeneratedResourceObjectIfNotExits(
            propertiesProperty.schema.language.default.name,
            `ResourceUpdateModelProperties<${resourceMetadata.Name}, ${resourcePropertiesModelName}>`,
          );
        }
      } else if (tagsProperty) {
        kind = isLongRunning ? "ArmTagsPatchAsync" : "ArmTagsPatchSync";
        // TODO: if update properties are different from tag properties, we need to use a different model
        addGeneratedResourceObjectIfNotExits(
          bodyParam?.schema.language.default.name ?? "",
          `TagsUpdateModel<${resourceMetadata.Name}>`,
        );
      } else if (bodyParam) {
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
        templateParameters: baseParameters ? [resourceMetadata.Name, baseParameters] : [resourceMetadata.Name],
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
    const templateParameters = [resourceMetadata.Name];
    const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
    if (baseParameters) {
      templateParameters.push(baseParameters);
    }

    addGeneratedResourceObjectIfNotExits(
      getSchemaResponseSchemaName(okResponse) ?? "",
      `ResourceListResult<${resourceMetadata.Name}>`,
    );

    converted.push({
      doc: operation.Description,
      kind: "ArmResourceListByParent",
      name: getOperationName(operation.OperationID),
      templateParameters: templateParameters,
    });
  }

  // operation under subscription
  if (resourceMetadata.OperationsFromSubscriptionExtension.length) {
    for (const operation of resourceMetadata.OperationsFromSubscriptionExtension) {
      // TODO: handle other kinds of operations
      if (operation.PagingMetadata) {
        const swaggerOperation = operations[operation.OperationID];
        const okResponse = swaggerOperation?.responses?.filter((o) =>
          o.protocol.http?.statusCodes.includes("200"),
        )?.[0];
        const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);

        addGeneratedResourceObjectIfNotExits(
          getSchemaResponseSchemaName(okResponse) ?? "",
          `ResourceListResult<${resourceMetadata.Name}>`,
        );
        // either list in location or list in subscription
        if (operation.Path.includes("/locations/")) {
          const templateParameters = [resourceMetadata.Name, `LocationScope<${resourceMetadata.Name}>`];
          if (baseParameters) {
            templateParameters.push(baseParameters);
          }
          converted.push({
            doc: operation.Description,
            kind: "ArmResourceListAtScope",
            name: getOperationName(operation.OperationID),
            templateParameters,
          });
        } else {
          converted.push({
            doc: operation.Description,
            kind: "ArmListBySubscription",
            name: getOperationName(operation.OperationID),
            templateParameters: [resourceMetadata.Name],
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
        `ResourceListResult<${resourceMetadata.Name}>`,
      );
      converted.push({
        doc: swaggerOperation.language.default.description,
        kind: "ArmResourceListByParent",
        name: `listBy${resourceMetadata.Parents[0].replace(/Resource$/, "")}`,
        templateParameters: baseParameters ? [resourceMetadata.Name, baseParameters] : [resourceMetadata.Name],
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
        const okResponse = swaggerOperation?.responses?.filter((o) =>
          o.protocol.http?.statusCodes.includes("200"),
        )?.[0];
        // TODO: deal with non-schema response for action
        let operationResponseName;
        if (okResponse && isResponseSchema(okResponse)) {
          if (!okResponse.schema.language.default.name.includes("·")) {
            operationResponseName = okResponse.schema.language.default.name;
          }
        }

        // TODO: deal with request without body
        const request = buildOperationBodyRequest(swaggerOperation, resourceMetadata) ?? "{}";
        const baseParameters = buildOperationBaseParameters(swaggerOperation, resourceMetadata);
        let kind;
        if (!okResponse) {
          // TODO: Sync operation should have a 204 response
          kind = isLongRunning ? "ArmResourceActionNoResponseContentAsync" : "ArmResourceActionNoContentSync";
        } else {
          kind = isLongRunning ? "ArmResourceActionAsync" : "ArmResourceActionSync";
        }
        const templateParameters = [resourceMetadata.Name, request];
        if (okResponse) {
          templateParameters.push(operationResponseName ?? "{}");
        }
        if (baseParameters) {
          templateParameters.push(baseParameters);
        }
        converted.push({
          doc: operation.Description,
          kind: kind as any,
          name: getOperationName(operation.OperationID),
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
): CadlOperation[] {
  const converted: CadlOperation[] = [];

  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      if (operation.Method === "GET") {
        const swaggerOperation = operations[operation.OperationID];
        if (swaggerOperation.requests && swaggerOperation.requests[0]) {
          converted.push(transformRequest(swaggerOperation.requests[0], swaggerOperation, getSession().model));
        }
      }
    }
  }

  return converted;
}

function getTspOperations(
  armSchema: ArmResourceSchema,
  resourcePropertiesModelName: string,
): [TspArmResourceOperation[], CadlOperation[]] {
  const resourceMetadata = armSchema.resourceMetadata;
  const operations = getResourceOperations(resourceMetadata);
  const tspOperations: TspArmResourceOperation[] = [];
  const normalOperations: CadlOperation[] = [];

  // TODO: handle operations under resource group / management group / tenant

  // read operation
  tspOperations.push(...convertResourceReadOperation(resourceMetadata, operations));

  // exist operation
  tspOperations.push(...convertResourceExistsOperation(resourceMetadata));

  // create operation
  tspOperations.push(...convertResourceCreateOrUpdateOperation(resourceMetadata, operations));

  // patch update operation could either be patch for resource/tag or custom patch
  tspOperations.push(...convertResourceUpdateOperation(resourceMetadata, operations, resourcePropertiesModelName));

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
  const parameters: CadlParameter[] = [];
  const resourceBasicParameters = [];
  resource.GetOperations[0].Path.split("/").forEach((p) => {
    if (p.match(/^{.+}$/)) {
      resourceBasicParameters.push(p.replace("{", "").replace("}", ""));
    }
  });
  resourceBasicParameters.push("api-version");
  resourceBasicParameters.push("$host");
  if (operation.parameters) {
    for (const parameter of operation.parameters) {
      if (!resourceBasicParameters.includes(parameter.language.default.serializedName)) {
        parameters.push(transformParameter(parameter, codeModel));
      }
    }
  }

  if (parameters.length) {
    const params: string[] = [];
    for (const parameter of parameters) {
      params.push(generateParameter(parameter));
    }
    return `{
    ...BaseParameters<${resource.Name}>,
    ${params.join("\n")}
    }`;
  }
}

function getKeyParameter(resourceMetadata: ArmResource): Parameter | undefined {
  for (const operationGroup of getSession().model.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (operation.operationId === resourceMetadata.GetOperations[0].OperationID) {
        for (const parameter of operation.parameters ?? []) {
          if (parameter.language.default.name === resourceMetadata.ResourceKey) {
            return parameter;
          }
        }
      }
    }
  }
}

function generateSingletonKeyParameter(): CadlParameter {
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

function buildKeyProperty(schema: ArmResourceSchema): CadlObjectProperty {
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
      arguments: [schema.resourceMetadata.ResourceKey],
    },
    {
      name: "segment",
      arguments: [schema.resourceMetadata.ResourceKeySegment],
    },
  );

  // by convention the property itself needs to be called "name"
  parameter.name = "name";

  return { ...parameter, kind: "property" };
}

function buildResourceDecorators(schema: ArmResourceSchema): CadlDecorator[] {
  const resourceModelDecorators: CadlDecorator[] = [];

  for (const parent of schema.resourceMetadata.Parents) {
    if (!isFirstLevelResource(parent)) {
      resourceModelDecorators.push({
        name: "parentResource",
        arguments: [{ value: parent, options: { unwrap: true } }],
      });
    }
  }

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
