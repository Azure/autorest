import { CodeModel, HttpMethod, Operation, Parameter } from "@autorest/codemodel";
import { lowerFirst } from "lodash";
import pluralize from "pluralize";
import { getSession } from "../autorest-session";
import { generateParameters } from "../generate/generate-operations";
import {
  ArmResourceKind,
  CadlDecorator,
  CadlObjectProperty,
  CadlParameter,
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
  isResourceSchema,
} from "../utils/resource-discovery";
import { isResponseSchema } from "../utils/schemas";
import { transformParameter } from "./transform-operations";

const resourceParameters = ["subscriptionId", "resourceGroupName", "resourceName"];

export function transformTspArmResource(codeModel: CodeModel, schema: ArmResourceSchema): TspArmResource {
  const keyProperty = getKeyParameter(codeModel, schema.resourceMetadata);
  if (!keyProperty) {
    throw new Error(
      `Failed to find key property ${schema.resourceMetadata.ResourceKey} for ${schema.language.default.name}`,
    );
  }

  const parameter = transformParameter(keyProperty, codeModel);
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

  return {
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties: [prop],
    name: schema.resourceMetadata.Name,
    parents: [],
    resourceParent,
    propertiesModelName: `${schema.resourceMetadata.SwaggerModelName}Properties`,
    doc: schema.language.default.description,
    decorators: resourceModelDecorators,
    operations: getTspOperations(schema),
  };
}

function getTspOperations(armSchema: ArmResourceSchema): TspArmResourceOperation[] {
  const resourceMetadata = armSchema.resourceMetadata;
  const operations = getResourceOperations(resourceMetadata);
  const tspOperations: TspArmResourceOperation[] = [];
  for (const operation of resourceMetadata.Operations) {
    const rawOperation = operations.find((o) => o.operationId === operation.OperationID);
    const baseParameters = rawOperation ? getOperationParameters(rawOperation, armSchema.resourceMetadata) : "";

    const operationResponse = rawOperation?.responses?.[0];
    let operationResponseName: string = resourceMetadata.Name;
    if (operationResponse && isResponseSchema(operationResponse)) {
      operationResponseName = operationResponse.schema.language.default.name;
    }
    const operationIdPrefix = pluralize(resourceMetadata.Name);
    if (operation.OperationID === `${operationIdPrefix}_Get`) {
      tspOperations.push({
        doc: operation.Description,
        kind: "ArmResourceRead",
        name: "get",
        templateParameters: [resourceMetadata.Name],
      });
      continue;
    }

    if (operation.OperationID === `${operationIdPrefix}_ListByResourceGroup`) {
      tspOperations.push({
        doc: operation.Description,
        kind: "ArmResourceListByParent",
        name: "listByResourceGroup",
        templateParameters: [resourceMetadata.Name],
      });
      continue;
    }

    if (
      resourceMetadata.Parents.length &&
      operation.OperationID === `${operationIdPrefix}_ListBy${resourceMetadata.Parents[0]}`
    ) {
      const templateParameters = [resourceMetadata.Name];
      if (baseParameters) {
        templateParameters.push(`{${baseParameters}}`);
      }
      tspOperations.push({
        doc: operation.Description,
        kind: "ArmResourceListByParent",
        name: `listBy${resourceMetadata.Parents[0]}`,
        templateParameters,
      });
      continue;
    }

    if (operation.OperationID === `${operationIdPrefix}_CreateOrUpdate`) {
      tspOperations.push({
        doc: operation.Description,
        kind: operation.IsLongRunning ? "ArmResourceCreateOrUpdateAsync" : "ArmResourceCreateOrUpdateSync",
        name: "createOrUpdate",
        templateParameters: [resourceMetadata.Name],
      });
      continue;
    }

    if (operation.OperationID === `${operationIdPrefix}_Update`) {
      tspOperations.push({
        doc: operation.Description,
        kind: operation.IsLongRunning ? "ArmResourcePatchAsync" : "ArmResourcePatchSync",
        name: "update",
        templateParameters: [resourceMetadata.Name, `${resourceMetadata.Name}Properties`],
      });
      continue;
    }

    if (operation.OperationID === `${operationIdPrefix}_Delete`) {
      tspOperations.push({
        doc: operation.Description,
        kind: operation.IsLongRunning ? "ArmResourceDeleteAsync" : "ArmResourceDeleteSync",
        name: "delete",
        templateParameters: [resourceMetadata.Name],
      });
      continue;
    }

    if (operation.OperationID === `${operationIdPrefix}_ListBySubscription`) {
      tspOperations.push({
        doc: operation.Description,
        kind: "ArmListBySubscription",
        name: "listBySubscription",
        templateParameters: [resourceMetadata.Name],
      });
      continue;
    }

    const operationName = operation.OperationID.replace(`${operationIdPrefix}_`, "");
    const fixMe: string[] = [];

    if (!baseParameters) {
      fixMe.push(
        "// FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter",
      );
    }
    tspOperations.push({
      fixMe,
      doc: operation.Description,
      kind: operation.IsLongRunning ? "ArmResourceActionAsync" : "ArmResourceActionSync",
      name: lowerFirst(operationName),
      templateParameters: [resourceMetadata.Name, `{${baseParameters}}`, operationResponseName],
    });
    continue;
  }

  return tspOperations;
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
  const codeModel = getSession().model;
  const selfKey = getKeyParameter(codeModel, resource);

  if (selfKey.language.default.name === parameter.language.default.name) {
    return true;
  }

  const parent = getArmResourcesMetadata()[resource.Parents[0]];

  if (!parent) {
    return false;
  }

  return isParentIdPrameter(parameter, parent);
}

function getKeyParameter(codeModel: CodeModel, resourceMetadata: ArmResource): Parameter {
  const getOperation = resourceMetadata.Operations.find((o) => o.Method === "GET");
  if (!getOperation) {
    throw new Error(`Failed to find GET operation for ${resourceMetadata.Name}`);
  }

  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (!operation.parameters) {
        throw new Error(`Failed to find parameters for ${operation.operationId}`);
      }

      for (const parameter of operation.parameters) {
        if (parameter.language.default.name === resourceMetadata.ResourceKey) {
          return parameter;
        }
      }
    }
  }

  throw new Error(`Failed to find operation for ${getOperation.OperationID}`);
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
