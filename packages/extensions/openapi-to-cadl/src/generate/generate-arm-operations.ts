import { ObjectSchema, Operation, isObjectSchema } from "@autorest/codemodel";
import { lowerFirst } from "lodash";
import { plural } from "pluralize";
import { getSession } from "../autorest-session";
import { CadlOperation, TypespecArmResource } from "../interfaces";
import { transformOperation } from "../transforms/transform-operations";
import { getArmResourceNames } from "../transforms/transform-resources";
import { generateDocs } from "../utils/docs";
import { isArraySchema, isResponseSchema } from "../utils/schemas";
import { generateParameters } from "./generate-operations";

export function generateArmOperations(resource: TypespecArmResource) {
  const definitions: string[] = [];
  const codeModel = getSession().model;

  const resourceOperationsKind = getResourceOperationsKind(resource);
  definitions.push("@armResourceOperations");
  definitions.push(
    `interface ${plural(resource.name)} extends Azure.ResourceManager.${
      resourceOperationsKind.name
    }<${resourceOperationsKind.parameters.join()}>{`,
  );

  for (const operation of resource.operations) {
    const typespecOperations = transformOperation(operation, codeModel).flatMap((p) => p);
    for (const op of typespecOperations) {
      definitions.push("@autoRoute");
      definitions.push(generateDocs(op));
      definitions.push(`@armResourceAction(${resource.name})`);
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

const defaultResourceParameters = ["resourcegroupname", "subscriptionid", "apiversion"];

function getParentKeys(resource: TypespecArmResource): string[] {
  if (!resource.resourceParent) {
    return [];
  }

  return [resource.resourceParent.metadata.name, ...getParentKeys(resource.resourceParent)];
}

function getOperationParameters(resource: TypespecArmResource, operation: CadlOperation) {
  const params = [`...ResourceInstanceParameters<${resource.name}>`];
  const parentsKeys = getParentKeys(resource);
  params.push(
    generateParameters(
      operation.parameters
        .filter((p) => !parentsKeys.includes(p.name))
        .filter(
          (p) =>
            p.name !== resource.metadata.name &&
            p.implementation === "Method" &&
            p.name.toLowerCase() !== `${resource.name}Name`.toLowerCase() &&
            !defaultResourceParameters.includes(p.name.toLowerCase()),
        ),
    ),
  );

  return params.join(", ");
}

function getResponseType(operation: CadlOperation, rawOperation: Operation) {
  const responseTypes = operation.responses.join(" |");
  if (operation.extensions.includes("Pageable")) {
    if (!isResultResourceList(rawOperation)) {
      return `Page<${responseTypes}>`;
    }

    const responses = rawOperation.responses ?? [];
    if (responses.length && isResponseSchema(responses[0])) {
      const schema = responses[0].schema as ObjectSchema;
      const valuesProperty = schema.properties?.find((p) => p.serializedName === "value");
      if (!valuesProperty) {
        throw new Error(`Unable to determine response type for operation ${operation.name}`);
      }
      if (!isArraySchema(valuesProperty.schema)) {
        throw new Error(`Unable to determine response type for operation ${operation.name}`);
      }
      const elementType = valuesProperty.schema.elementType.language.default.name;
      return `ResourceListResult<${elementType}>`;
    }

    throw new Error(`Unable to determine response type for operation ${operation.name}`);
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

interface ResourceOperationsKind {
  name: "ProxyResourceOperations" | "TrackedResourceOperations";
  parameters: string[];
}

function getResourceOperationsKind(resource: TypespecArmResource): ResourceOperationsKind {
  switch (resource.resourceKind) {
    case "ProxyResource":
    case "ExtensionResource":
    case "SingletonResource":
      return { name: "ProxyResourceOperations", parameters: [resource.name] };
    case "TrackedResource":
      return { name: "TrackedResourceOperations", parameters: [resource.name, resource.propertiesModelName] };
    default:
      throw new Error(`Generating operations for ${resource.resourceKind} is not yet supported`);
  }
}
