import { CodeModel, HttpMethod, ObjectSchema, Operation, Parameter, Response, SchemaResponse } from "@autorest/codemodel";
import _ from "lodash";
import pluralize from "pluralize";
import { getSession } from "../autorest-session";
import { generateParameters } from "../generate/generate-operations";
import {
  ArmResourceKind,
  CadlDecorator,
  CadlObjectProperty,
  CadlParameter,
  MSIType,
  TspArmResource,
  TspArmResourceOperation,
} from "../interfaces";
import { getHttpMethod } from "../utils/operations";
import {
  ArmResource,
  ArmResourceSchema,
  _ArmResourceOperation,
  getArmResourcesMetadata,
  getResourceOperations,
  getSingletonResouceListOperation,
  isResourceSchema,
} from "../utils/resource-discovery";
import { isResponseSchema } from "../utils/schemas";
import { transformParameter } from "./transform-operations";

const resourceParameters = ["subscriptionId", "resourceGroupName", "resourceName"];

export function transformTspArmResource(codeModel: CodeModel, schema: ArmResourceSchema): TspArmResource {
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

  decorateKeyProperty(parameter, schema);

  const resourceParent = getParentResourceSchema(codeModel, schema);

  const prop: CadlObjectProperty = { ...parameter, kind: "property" };

  const resourceModelDecorators: CadlDecorator[] = [];

  if (schema.resourceMetadata.Parents && schema.resourceMetadata.Parents.length > 0) {
    if (schema.resourceMetadata.Parents[0] !== "ResourceGroupResource") {
      resourceModelDecorators.push({
        name: "parentResource",
        arguments: [{ value: schema.resourceMetadata.Parents[0], options: { unwrap: true } }],
      });
    }
  }

  if (schema.resourceMetadata.IsSingletonResource) {
    resourceModelDecorators.push({
      name: "singleton",
      arguments: [schema.resourceMetadata.ResourceKey],
    });
  }

  const propertiesProperty = schema.properties?.find((p) => p.language.default.name === "properties");

  if (!propertiesProperty) {
    throw new Error(`Failed to find properties property for ${schema.language.default.name}`);
  }

  let msiType: MSIType | undefined;
  if (schema.properties?.find((p) => p.schema.language.default.name === "ManagedServiceIdentity")) {
    msiType = "ManagedServiceIdentity";
  } else if (schema.properties?.find((p) => p.schema.language.default.name === "SystemAssignedServiceIdentity")) {
    msiType = "ManagedSystemAssignedIdentity";
  }

  const propertiesModelName = propertiesProperty.schema.language.default.name;
  return {
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties: [prop],
    name: schema.resourceMetadata.Name,
    parents: [],
    resourceParent,
    propertiesModelName,
    doc: schema.language.default.description,
    decorators: resourceModelDecorators,
    operations: getTspOperations(schema),
    msiType,
  };
}

function getTspOperations(armSchema: ArmResourceSchema): TspArmResourceOperation[] {
  const resourceMetadata = armSchema.resourceMetadata;
  const operations = getResourceOperations(resourceMetadata);
  const tspOperations: TspArmResourceOperation[] = [];

  // every resource should have a get operation
  // TODO: TBaseParameters
  const operation = resourceMetadata.GetOperations[0];
  tspOperations.push({
    doc: resourceMetadata.GetOperations[0].Description, // TODO: resource have duplicated CRUD operations
    kind: "ArmResourceRead",
    name: getOperationName(operation.OperationID),
    templateParameters: [resourceMetadata.Name],
  });

  // create operation
  if (resourceMetadata.CreateOperations.length) {
    // TODO: CreateOrUpdate / CreateOrReplace
    // TODO: TBaseParameters
    const operation = resourceMetadata.CreateOperations[0];
    tspOperations.push({
      doc: operation.Description,
      kind: operation.IsLongRunning ? "ArmResourceCreateOrUpdateAsync" : "ArmResourceCreateOrUpdateSync",
      name: getOperationName(operation.OperationID),
      templateParameters: [resourceMetadata.Name],
    });
  }

  // patch update operation could either be patch for resource/tag or custom patch
  if (resourceMetadata.UpdateOperations.length) {
    // TODO: TBaseParameters
    const operation = resourceMetadata.UpdateOperations[0];
    if (!resourceMetadata.CreateOperations.length || resourceMetadata.CreateOperations[0].OperationID !== operation.OperationID) {
      const swaggerOperation = operations[resourceMetadata.UpdateOperations[0].OperationID]
      const bodyParam = swaggerOperation!.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
      const propertiesProperty = (bodyParam?.schema as ObjectSchema).properties?.find((p) => p.language.default.name === "properties");
      const tagsProperty = (bodyParam?.schema as ObjectSchema).properties?.find((p) => p.language.default.name === "tags");
      const fixMe: string[] = [];
      if (!bodyParam || (!propertiesProperty && !tagsProperty)) {
        fixMe.push(
          "// FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property",
        );
      }
      let kind, templateBody;
      if (propertiesProperty) {
        kind = operation.IsLongRunning ? "ArmResourcePatchAsync" : "ArmResourcePatchSync";
        templateBody = propertiesProperty.schema.language.default.name;
      } else if (tagsProperty) {
        kind = operation.IsLongRunning ? "ArmTagsPatchAsync" : "ArmTagsPatchSync";
      } else if (bodyParam) {
        kind = operation.IsLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync";
        templateBody = bodyParam.schema.language.default.name;
      } else {
        kind = operation.IsLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync";
        templateBody = "{}";
      }
      tspOperations.push({
        fixMe,
        doc: operation.Description,
        kind: kind as any,
        name: getOperationName(operation.OperationID),
        templateParameters: templateBody ? [resourceMetadata.Name, templateBody] : [resourceMetadata.Name],
      });
    }
  }

  // delete operation
  if (resourceMetadata.DeleteOperations.length) {
    // TODO: TBaseParameters
    const operation = resourceMetadata.DeleteOperations[0];
    const swaggerOperation = operations[resourceMetadata.DeleteOperations[0].OperationID]
    const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];

    tspOperations.push({
      doc: operation.Description,
      kind: operation.IsLongRunning ? (okResponse ? "ArmResourceDeleteAsync" : "ArmResourceDeleteWithoutOkAsync") : "ArmResourceDeleteSync",
      name: getOperationName(operation.OperationID),
      templateParameters: [resourceMetadata.Name],
    });
  }

  // list by parent operation
  if (resourceMetadata.ListOperations.length) {
    // TODO: TParentName, TParentFriendlyName
    const operation = resourceMetadata.ListOperations[0];
    const swaggerOperation = operations[resourceMetadata.ListOperations[0].OperationID]
    const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
    const templateParameters = [resourceMetadata.Name];
    const baseParameters = swaggerOperation ? getOperationParameters(swaggerOperation, resourceMetadata) : "";
    if (baseParameters) {
      templateParameters.push(baseParameters);
    }
    tspOperations.push({
      doc: operation.Description,
      kind: "ArmResourceListByParent",
      name: getOperationName(operation.OperationID),
      templateParameters: templateParameters,
      resultSchemaName: getSchemaResponseSchemaName(okResponse),
    });
  }

  // operation under subscription
  if (resourceMetadata.OperationsFromSubscriptionExtension.length) {
    for (const operation of resourceMetadata.OperationsFromSubscriptionExtension) {
      // TODO: handle other kinds of operations
      if (operation.PagingMetadata) {
        const swaggerOperation = operations[operation.OperationID]
        const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
        // either list in location or list in subscription
        if (operation.Path.includes("/locations/")) {
          tspOperations.push({
            doc: operation.Description,
            kind: "ArmResourceListAtScope",
            name: getOperationName(operation.OperationID),
            templateParameters: [resourceMetadata.Name, `LocationScope<${resourceMetadata.Name}>`],
            resultSchemaName: getSchemaResponseSchemaName(okResponse),
          });
        } else {
          tspOperations.push({
            doc: operation.Description,
            kind: "ArmListBySubscription",
            name: getOperationName(operation.OperationID),
            templateParameters: [resourceMetadata.Name],
            resultSchemaName: getSchemaResponseSchemaName(okResponse),
          });
        }
      }
    }
  }

  // TODO: handle operations under resource group / management group / tenant

  // other operations
  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      // TODO: handle other kinds of methods
      if (operation.Method === "POST") {
        const swaggerOperation = operations[operation.OperationID]
        let baseParameters = swaggerOperation ? getOperationParameters(swaggerOperation, resourceMetadata) : "";
        const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
        const noContentResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("204"))?.[0];
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
        if (noContentResponse) {
          kind = operation.IsLongRunning ? "ArmResourceActionNoResponseContentAsync" : "ArmResourceActionNoContentSync";
        } else {
          kind = operation.IsLongRunning ? "ArmResourceActionAsync" : "ArmResourceActionSync";
        }
        tspOperations.push({
          fixMe,
          doc: operation.Description,
          kind: kind as any,
          name: getOperationName(operation.OperationID),
          templateParameters: okResponse ? [resourceMetadata.Name, baseParameters, operationResponseName ?? "{}"] : [resourceMetadata.Name, baseParameters],
        });
      }
    }
  }

  if (resourceMetadata.IsSingletonResource) {
    const swaggerOperation = getSingletonResouceListOperation(resourceMetadata);
    if (swaggerOperation) {
      const okResponse = swaggerOperation?.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
      tspOperations.push({
        doc: swaggerOperation.language.default.description,
        kind: "ArmResourceListByParent",
        name: `listBy${resourceMetadata.Parents[0].replace(/Resource$/, "")}`,
        templateParameters: [resourceMetadata.Name],
        resultSchemaName: getSchemaResponseSchemaName(okResponse),
      });
    }
  }

  return tspOperations;
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
        !isParentIdPrameter(parameter, resource)
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

function isParentIdPrameter(parameter: Parameter, resource: ArmResource): boolean {
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

  return isParentIdPrameter(parameter, parent);
}

function getKeyParameter(codeModel: CodeModel, resourceMetadata: ArmResource): Parameter {
  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (operation.operationId === resourceMetadata.GetOperations[0].OperationID) {
        for (const parameter of operation.parameters!) {
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

function getParentResourceSchema(codeModel: CodeModel, schema: ArmResourceSchema): TspArmResource | undefined {
  const resourceParent = schema.resourceMetadata.Parents?.[0];

  if (!resourceParent) {
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

function decorateKeyProperty(property: CadlParameter, schema: ArmResourceSchema): void {
  if (!property.decorators) {
    property.decorators = [];
  }

  property.decorators.push(
    {
      name: "key",
      arguments: [schema.resourceMetadata.ResourceKey],
    },
    {
      name: "segment",
      arguments: [schema.resourceMetadata.ResourceKeySegment],
    },
  );

  // By convention the property itself needs to be called "name"
  property.name = "name";
}

function getResourceKind(schema: ArmResourceSchema): ArmResourceKind {
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
