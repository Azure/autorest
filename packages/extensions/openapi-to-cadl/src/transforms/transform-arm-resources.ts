import { CodeModel, Parameter } from "@autorest/codemodel";
import { ArmResourceKind, CadlDecorator, CadlObjectProperty, CadlParameter, TspArmResource } from "../interfaces";
import { ArmResourceSchema, isResourceSchema } from "../utils/resource-discovery";
import { transformParameter } from "./transform-operations";

export function transformTspArmResource(codeModel: CodeModel, schema: ArmResourceSchema): TspArmResource {
  const keyProperty = getKeyParameter(codeModel, schema);
  //schema.properties?.find((p) => p.serializedName === schema.resourceMetadata.ResourceKey);
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
    resourceModelDecorators.push({
      name: "parentResource",
      arguments: [{ value: schema.resourceMetadata.Parents[0], options: { unwrap: true } }],
    });
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
  };
}

function getKeyParameter(codeModel: CodeModel, schema: ArmResourceSchema): Parameter {
  const getOperation = schema.resourceMetadata.Operations.find((o) => o.Method === "GET");
  if (!getOperation) {
    throw new Error(`Failed to find GET operation for ${schema.language.default.name}`);
  }

  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (!operation.parameters) {
        throw new Error(`Failed to find parameters for ${operation.operationId}`);
      }

      for (const parameter of operation.parameters) {
        if (parameter.language.default.name === schema.resourceMetadata.ResourceKey) {
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
}

function getResourceKind(schema: ArmResourceSchema): ArmResourceKind {
  if (schema.resourceMetadata.IsTrackedResource) {
    return "TrackedResource";
  }

  if (
    schema.resourceMetadata.ResourceOperationsMetadata.HasCreateOrUpdateOperation &&
    schema.resourceMetadata.ResourceOperationsMetadata.HasDeleteOperation &&
    schema.resourceMetadata.ResourceOperationsMetadata.HasUpdateOperation
  ) {
    return "ProxyResource";
  }

  return "MinProxyResource";
}
