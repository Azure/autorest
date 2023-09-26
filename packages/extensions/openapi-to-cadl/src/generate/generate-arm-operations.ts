import { Operation, Schema, SchemaResponse, isObjectSchema } from "@autorest/codemodel";
import { lowerFirst } from "lodash";
import { plural } from "pluralize";
import { getSession } from "../autorest-session";
import { CadlObject, CadlObjectProperty, CadlOperation, TypespecArmResource } from "../interfaces";
import { transformOperation } from "../transforms/transform-operations";
import { ArmResourcesCache, getArmResourceNames } from "../transforms/transform-resources";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";
import { isArraySchema, isResponseSchema } from "../utils/schemas";

export function generateArmOperations(resource: TypespecArmResource) {
  const definitions: string[] = [];
  const codeModel = getSession().model;

  const resourceOperationsKind = getResourceOperationsKind(resource);
  definitions.push("@armResourceOperations");
  definitions.push(
    `interface ${plural(resource.name)} extends Azure.ResourceManager.${resourceOperationsKind}<${resource.name}, ${
      resource.propertiesModelName
    }>{`,
  );

  for (const operation of resource.operations) {
    const typespecOperations = transformOperation(operation, codeModel).flatMap((p) => p);
    for (const op of typespecOperations) {
      definitions.push("@autoroute");
      definitions.push(generateDocs(op));
      definitions.push(`@armResourceLocation(${resource.name})`);
      definitions.push(`@${op.verb}`);
      definitions.push(
        `${lowerFirst(op.name)}(${getOperationParameters(resource, op)}): ArmResponse<${getResponseType(
          op,
          operation,
        )}> | ErrorResponse;`,
      );
    }
  }
  definitions.push("}");

  return definitions;
}

function getOperationParameters(resource: TypespecArmResource, operation: CadlOperation) {
  const params = [`...ResourceInstanceParameters<${resource.name}>`];

  if (operation.extensions.includes("Pageable")) {
    params.push(`...ListQueryParameters`);
  }

  return params.join(", ");
}

function getResponseType(operation: CadlOperation, rawOperation: Operation) {
  const responseTypes = operation.responses.join(" |");
  if (operation.extensions.includes("Pageable")) {
    const armResourceNames = getArmResourceNames();

    if (!isResultResourceList(rawOperation)) {
      return `Page<${responseTypes}>`;
    }

    return `ResourceListResult<${operation.responses[0]}>`;
  }

  return responseTypes;
}

function isResultResourceList(operation: Operation) {
  if (!operation.responses) {
    return false;
  }

  if (!operation.responses[0]) {
    return false;
  }

  const response = operation.responses[0];

  if (!isResponseSchema(response)) {
    return false;
  }

  if (!isObjectSchema(response.schema)) {
    return false;
  }

  const values = response.schema.properties?.find((p) => p.serializedName === "value");

  if (!values) {
    return false;
  }

  if (!isArraySchema(values.schema)) {
    return false;
  }

  const resultName = values.schema.elementType.language.default.name;
  const resources = getArmResourceNames();

  return resources.has(resultName);
}

function getResourceOperationsKind(resource: TypespecArmResource) {
  switch (resource.resourceKind) {
    case "ProxyResource":
      return "ProxyResourceOperations";
    case "TrackedResource":
      return "TrackedResourceOperations";
    default:
      throw new Error(`Generating operations for ${resource.resourceKind} is not yet supported`);
  }
}
