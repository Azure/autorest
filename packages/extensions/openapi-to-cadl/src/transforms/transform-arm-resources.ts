import {
  CodeModel,
  HttpMethod,
  ObjectSchema,
  Operation,
  Parameter,
  Response,
  SchemaResponse,
} from "@autorest/codemodel";
import _ from "lodash";
import { getSession } from "../autorest-session";
import { generateParameters } from "../generate/generate-operations";
import {
  ArmResourceKind,
  CadlDecorator,
  CadlObjectProperty,
  CadlOperation,
  CadlParameter,
  MSIType,
  TspArmResource,
  TspArmResourceOperation,
  isFirstLevelResource,
} from "../interfaces";
import { getHttpMethod } from "../utils/operations";
import {
  ArmResource,
  ArmResourceSchema,
  OperationWithResourceOperationFlag,
  _ArmResourceOperation,
  getArmResourcesMetadata,
  getResourceOperations,
  getSingletonResouceListOperation,
  isResourceSchema,
} from "../utils/resource-discovery";
import { isResponseSchema } from "../utils/schemas";
import { transformParameter, transformRequest } from "./transform-operations";

const resourceParameters = ["subscriptionId", "resourceGroupName", "resourceName"];

const generatedResourceObjects: Map<string, string> = new Map<string, string>();

export function isGeneratedResourceObject(name: string): boolean {
  return generatedResourceObjects.has(name);
}

export function replaceGeneratedResourceObject(name: string): string {
  return generatedResourceObjects.get(name) ?? name;
}

export function transformTspArmResource(codeModel: CodeModel, schema: ArmResourceSchema): TspArmResource {
  const fixMe: string[] = [];

  // TODO: deal with a resource with multiple parents
  if (schema.resourceMetadata.Parents.length > 1) {
    fixMe.push(`// FIXME: ${schema.resourceMetadata.Name} has more than one parent, currently converter will only use the first one`)
  }

  let propertiesModelName = schema.properties?.find((p) => p.language.default.name === "properties")?.schema.language.default.name;

  // TODO: deal with resources that has no properties property
  if (!propertiesModelName) {
    fixMe.push(`// FIXME: ${schema.resourceMetadata.Name} has no properties property`);
    propertiesModelName = "{}";
  }

  let msiType: MSIType | undefined;
  if (schema.properties?.find((p) => p.schema.language.default.name === "ManagedServiceIdentity")) {
    msiType = "Azure.ResourceManager.ManagedServiceIdentity";
  } else if (schema.properties?.find((p) => p.schema.language.default.name === "SystemAssignedServiceIdentity")) {
    msiType = "Azure.ResourceManager.ManagedSystemAssignedIdentity";
  }

  const operations = getTspOperations(codeModel, schema, propertiesModelName);

  return {
    fixMe,
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties: [buildKeyProperty(codeModel, schema)],
    name: schema.resourceMetadata.Name,
    parents: [],
    resourceParent: getParentResource(codeModel, schema),
    propertiesModelName,
    doc: schema.language.default.description,
    decorators: buildResourceDecorators(schema),
    resourceOperations: operations[0],
    normalOperations: operations[1],
    msiType,
  };
}

function convertResourceReadOperation(resourceMetadata: ArmResource): TspArmResourceOperation[] {
  // every resource should have a get operation
  // TODO: TBaseParameters
  const operation = resourceMetadata.GetOperations[0];
  generatedResourceObjects.set(resourceMetadata.Name, resourceMetadata.Name);
  return [{
    doc: resourceMetadata.GetOperations[0].Description, // TODO: resource have duplicated CRUD operations
    kind: "ArmResourceRead",
    name: getOperationName(operation.OperationID),
    templateParameters: [resourceMetadata.Name],
  }];
}

function convertResourceCreateOrUpdateOperation(resourceMetadata: ArmResource): TspArmResourceOperation[] {
  // TODO: TBaseParameters
  if (resourceMetadata.CreateOperations.length) {
    const operation = resourceMetadata.CreateOperations[0];
    return [{
      doc: operation.Description,
      kind: operation.IsLongRunning ? "ArmResourceCreateOrUpdateAsync" : "ArmResourceCreateOrReplaceSync",
      name: getOperationName(operation.OperationID),
      templateParameters: [resourceMetadata.Name],
    }];
  }
  return [];
}

function convertResourceUpdateOperation(resourceMetadata: ArmResource, operations: Record<string, Operation>, resourcePropertiesModelName: string): TspArmResourceOperation[] {
  // TODO: TBaseParameters
  if (resourceMetadata.UpdateOperations.length) {
    const operation = resourceMetadata.UpdateOperations[0];
    if (
      !resourceMetadata.CreateOperations.length ||
      resourceMetadata.CreateOperations[0].OperationID !== operation.OperationID
    ) {
      const swaggerOperation = operations[resourceMetadata.UpdateOperations[0].OperationID];
      const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
      const propertiesProperty = (bodyParam?.schema as ObjectSchema).properties?.find(
        (p) => p.language.default.name === "properties",
      );
      const tagsProperty = (bodyParam?.schema as ObjectSchema).properties?.find(
        (p) => p.language.default.name === "tags",
      );
      const fixMe: string[] = [];
      if (!bodyParam || (!propertiesProperty && !tagsProperty)) {
        fixMe.push(
          "// FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property",
        );
      }
      let kind, templateBody;
      if (propertiesProperty) {
        kind = operation.IsLongRunning ? "ArmResourcePatchAsync" : "ArmResourcePatchSync";
        // TODO: if update properties are different from resource properties, we need to use a different model
        templateBody = resourcePropertiesModelName;
        generatedResourceObjects.set(bodyParam?.schema.language.default.name ?? "", `ResourceUpdateModel<${resourceMetadata.Name}>`);
        if (propertiesProperty.schema.language.default.name !== resourcePropertiesModelName) {
          generatedResourceObjects.set(propertiesProperty.schema.language.default.name, `ResourceUpdateModelProperties<${resourceMetadata.Name}, ${resourcePropertiesModelName}>`);
        }
      } else if (tagsProperty) {
        kind = operation.IsLongRunning ? "ArmTagsPatchAsync" : "ArmTagsPatchSync";
        generatedResourceObjects.set(bodyParam?.schema.language.default.name ?? "", `TagsUpdateModel<${resourceMetadata.Name}>`);
      } else if (bodyParam) {
        kind = operation.IsLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync";
        templateBody = bodyParam.schema.language.default.name;
      } else {
        kind = operation.IsLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync";
        templateBody = "{}";
      }
      return [{
        fixMe,
        doc: operation.Description,
        kind: kind as any,
        name: getOperationName(operation.OperationID),
        templateParameters: templateBody ? [resourceMetadata.Name, templateBody] : [resourceMetadata.Name],
      }];
    }
  }
  return [];
}

function convertResourceDeleteOperation(resourceMetadata: ArmResource, operations: Record<string, Operation>): TspArmResourceOperation[] {
  if (resourceMetadata.DeleteOperations.length) {
    // TODO: TBaseParameters
    const operation = resourceMetadata.DeleteOperations[0];
    const swaggerOperation = operations[resourceMetadata.DeleteOperations[0].OperationID];
    const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];

    return [{
      doc: operation.Description,
      kind: operation.IsLongRunning
        ? okResponse
          ? "ArmResourceDeleteAsync"
          : "ArmResourceDeleteWithoutOkAsync"
        : "ArmResourceDeleteSync",
      name: getOperationName(operation.OperationID),
      templateParameters: [resourceMetadata.Name],
    }];
  }
  return [];
}

function convertResourceListOperations(resourceMetadata: ArmResource, operations: Record<string, Operation>): TspArmResourceOperation[] {
  const converted: TspArmResourceOperation[] = [];

  // list by parent operation
  if (resourceMetadata.ListOperations.length) {
    // TODO: TParentName, TParentFriendlyName
    const operation = resourceMetadata.ListOperations[0];
    const swaggerOperation = operations[resourceMetadata.ListOperations[0].OperationID];
    const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
    const templateParameters = [resourceMetadata.Name];
    const baseParameters = swaggerOperation ? getOperationParameters(swaggerOperation, resourceMetadata) : "";
    if (baseParameters) {
      templateParameters.push(baseParameters);
    }

    generatedResourceObjects.set(getSchemaResponseSchemaName(okResponse) ?? "", `ResourceListResult<${resourceMetadata.Name}>`);

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

        generatedResourceObjects.set(getSchemaResponseSchemaName(okResponse) ?? "", `ResourceListResult<${resourceMetadata.Name}>`);
        // either list in location or list in subscription
        if (operation.Path.includes("/locations/")) {
          converted.push({
            doc: operation.Description,
            kind: "ArmResourceListAtScope",
            name: getOperationName(operation.OperationID),
            templateParameters: [resourceMetadata.Name, `LocationScope<${resourceMetadata.Name}>`],
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

      generatedResourceObjects.set(getSchemaResponseSchemaName(okResponse) ?? "", `ResourceListResult<${resourceMetadata.Name}>`);
      converted.push({
        doc: swaggerOperation.language.default.description,
        kind: "ArmResourceListByParent",
        name: `listBy${resourceMetadata.Parents[0].replace(/Resource$/, "")}`,
        templateParameters: [resourceMetadata.Name],
      });
      (swaggerOperation as OperationWithResourceOperationFlag).isResourceOperation = true;
    }
  }

  return converted;
}

function convertResourceActionOperations(resourceMetadata: ArmResource, operations: Record<string, Operation>): TspArmResourceOperation[] {
  const converted: TspArmResourceOperation[] = [];

  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      if (operation.Method === "POST") {
        const swaggerOperation = operations[operation.OperationID];
        let baseParameters = swaggerOperation ? getOperationParameters(swaggerOperation, resourceMetadata) : "";
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

        const fixMe: string[] = [];
        if (!baseParameters) {
          fixMe.push(
            "// FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter",
          );
          baseParameters = "{}";
        }
        let kind;
        if (!okResponse) {
          // TODO: Sync operation should have a 204 response
          kind = operation.IsLongRunning ? "ArmResourceActionNoResponseContentAsync" : "ArmResourceActionNoContentSync";
        } else {
          kind = operation.IsLongRunning ? "ArmResourceActionAsync" : "ArmResourceActionSync";
        }
        converted.push({
          fixMe,
          doc: operation.Description,
          kind: kind as any,
          name: getOperationName(operation.OperationID),
          templateParameters: okResponse
            ? [resourceMetadata.Name, baseParameters, operationResponseName ?? "{}"]
            : [resourceMetadata.Name, baseParameters],
        });
      }
    }
  }

  return converted;
}

function convertResourceOtherGetOperations(resourceMetadata: ArmResource, operations: Record<string, Operation>, codeModel: CodeModel): CadlOperation[] {
  const converted: CadlOperation[] = [];

  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      if (operation.Method === "GET") {
        const swaggerOperation = operations[operation.OperationID];
        if (swaggerOperation.requests && swaggerOperation.requests[0]) {
          converted.push(transformRequest(swaggerOperation.requests[0], swaggerOperation, codeModel));
        }
      }
    }
  }

  return converted;
}

function getTspOperations(codeModel: CodeModel, armSchema: ArmResourceSchema, resourcePropertiesModelName: string): [TspArmResourceOperation[], CadlOperation[]] {
  const resourceMetadata = armSchema.resourceMetadata;
  const operations = getResourceOperations(resourceMetadata);
  const tspOperations: TspArmResourceOperation[] = [];
  const normalOperations: CadlOperation[] = [];

  // TODO: handle operations under resource group / management group / tenant

  // read operation
  tspOperations.push(...convertResourceReadOperation(resourceMetadata));

  // create operation
  tspOperations.push(...convertResourceCreateOrUpdateOperation(resourceMetadata));

  // patch update operation could either be patch for resource/tag or custom patch
  tspOperations.push(...convertResourceUpdateOperation(resourceMetadata, operations, resourcePropertiesModelName));

  // delete operation
  tspOperations.push(...convertResourceDeleteOperation(resourceMetadata, operations));

  // list operation
  tspOperations.push(...convertResourceListOperations(resourceMetadata, operations));

  // action operation
  tspOperations.push(...convertResourceActionOperations(resourceMetadata, operations));

  // other get operations
  normalOperations.push(...convertResourceOtherGetOperations(resourceMetadata, operations, codeModel));


  return [tspOperations, normalOperations];
}

function getOperationName(name: string): string {
  return _.lowerFirst(_.last(name.split("_")));
}

function getOperationParameters(operation: Operation, resource: ArmResource): string {
  const codeModel = getSession().model;
  const parameters: CadlParameter[] = [];
  if (operation.parameters) {
    for (const parameter of operation.parameters) {
      if (
        !resourceParameters.includes(parameter.language.default.name) &&
        !parameter.origin?.startsWith("modelerfour:synthesized") &&
        !isParentIdParameter(parameter, resource)
      ) {
        parameters.push(transformParameter(parameter, codeModel));
      }
    }
  }

  if (getHttpMethod(codeModel, operation) === HttpMethod.Post) {
    const bodyParam: Parameter | undefined = operation.requests?.[0].parameters?.find(
      (p) => p.protocol.http?.in === "body",
    );
    if (bodyParam) {
      const transformed = transformParameter(bodyParam, codeModel);
      parameters.push(transformed);
    }
  }

  return generateParameters(parameters);
}

function isParentIdParameter(parameter: Parameter, resource: ArmResource): boolean {
  if (!resource.IsSingletonResource) {
    const codeModel = getSession().model;
    const selfKey = getKeyParameter(codeModel, resource);

    if (selfKey.language.default.name === parameter.language.default.name) {
      return true;
    }
  }

  const parent = getArmResourcesMetadata()[resource.Parents[0]];

  if (!parent) {
    return false;
  }

  return isParentIdParameter(parameter, parent);
}

function getKeyParameter(codeModel: CodeModel, resourceMetadata: ArmResource): Parameter {
  for (const operationGroup of codeModel.operationGroups) {
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

  throw new Error(`Failed to find key parameter for ${resourceMetadata.Name}`);
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

function getParentResource(codeModel: CodeModel, schema: ArmResourceSchema): TspArmResource | undefined {
  const resourceParent = schema.resourceMetadata.Parents?.[0];

  if (!resourceParent || isFirstLevelResource(resourceParent)) {
    return undefined;
  }

  for (const objectSchema of codeModel.schemas.objects ?? []) {
    if (!isResourceSchema(objectSchema)) {
      continue;
    }

    if (objectSchema.resourceMetadata.Name === resourceParent) {
      return transformTspArmResource(codeModel, objectSchema);
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

function buildKeyProperty(codeModel: CodeModel, schema: ArmResourceSchema): CadlObjectProperty {
  let parameter;
  if (!schema.resourceMetadata.IsSingletonResource) {
    const keyProperty = getKeyParameter(codeModel, schema.resourceMetadata);
    if (!keyProperty) {
      throw new Error(
        `Failed to find key property ${schema.resourceMetadata.ResourceKey} for ${schema.language.default.name}`,
      );
    }
    parameter = transformParameter(keyProperty, codeModel);
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

  return { ...parameter, kind: "property" }
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
      arguments: [schema.resourceMetadata.ResourceKey],
    });
  }

  if (schema.resourceMetadata.IsTenantResource) {
    resourceModelDecorators.push({
      name: "tenantResource",
    });
  }

  if (schema.resourceMetadata.IsSubscriptionResource) {
    resourceModelDecorators.push({
      name: "subscriptionResource",
    });
  }

  if (schema.resourceMetadata.GetOperations[0].Path.includes("/locations/")) {
    resourceModelDecorators.push({
      name: "locationResource",
    });
  }

  return resourceModelDecorators;
}

