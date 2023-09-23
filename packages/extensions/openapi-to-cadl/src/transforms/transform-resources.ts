import { CodeModel, HttpRequest, ObjectSchema, Operation, StringSchema } from "@autorest/codemodel";
import { upperFirst } from "lodash";
import { singular } from "pluralize";
import { getSession } from "../autorest-session";
import { ArmResourceHierarchy, CadlDecorator, TypespecArmResource } from "../interfaces";
import { isResponseSchema } from "../utils/schemas";

const _resourceKinds = ["ProxyResource", "TrackedResource"];
export const ArmResourcesCache = new Map<ObjectSchema, TypespecArmResource>();
export interface ArmResourceSchema extends ObjectSchema {
  armResource?: TypespecArmResource;
}

// export function getResources(codeModel: CodeModel) {
//   const resources: TypespecArmResource[] = [];
//   for (const schema of codeModel.schemas?.objects ?? []) {
//     if (isResourceModel(schema)) {
//       const resourceOperation = findResourceOperation(codeModel, schema);
//       const path = getOperationPath(resourceOperation);
//       const key = findResourceKey(resourceOperation);
//       schema.armResource = {
//         kind: "object",
//         resourceKind: getResourceKind(schema),
//         name: schema.language.default.name,
//         schema,
//         path,
//         properties: [],
//         parents: [],
//       };
//     }
//   }
// }

function getPropertiesModelName(schema: ObjectSchema) {
  const property = schema.properties?.find((p) => p.serializedName === "properties");
  if (!property) {
    throw new Error(`Expected resource ${schema.language.default.name} to have a properties property`);
  }

  return property.schema.language.default.name;
}

export function calculateArmResources(codeModel: CodeModel) {
  if (ArmResourcesCache.size) {
    return ArmResourcesCache;
  }
  for (const schema of codeModel.schemas?.objects ?? []) {
    if (isResourceModel(schema)) {
      const resourceOperation = findResourceOperation(codeModel, schema);
      const path = getOperationPath(resourceOperation);
      const key = findResourceKey(resourceOperation);

      const hierarchy = extractResourceHierarchy(path);

      const resourceDecorators: CadlDecorator[] = [];

      if (hierarchy?.parent) {
        resourceDecorators.push({ name: "parentResource", arguments: [hierarchy.parent.name] });
      }

      ArmResourcesCache.set(schema, {
        kind: "object",
        propertiesModelName: getPropertiesModelName(schema),
        resourceKind: getResourceKind(schema),
        name: schema.language.default.name,
        schema,
        path,
        decorators: resourceDecorators,
        properties: [
          {
            kind: "property",
            isOptional: false,
            doc: key.doc,
            name: "name",
            type: "string",
            decorators: [
              { name: "key", arguments: [key.name] },
              ...(key.pattern ? [{ name: "pattern", arguments: [escapeRegex(key.pattern)] }] : []),
              { name: key.location },
            ],
          },
        ],
        parents: [],
      });
    }
  }

  return ArmResourcesCache;
}

function extractResourceHierarchy(url: string): ArmResourceHierarchy | undefined {
  // Split the URL by slashes
  const parts = url.split("/").filter((p) => p); // filter removes empty strings

  // Find the index of the "providers" keyword
  const providerIndex = parts.indexOf("providers");
  if (providerIndex === -1) {
    return undefined; // "providers" keyword not found, return null
  }

  // Extract resources from URL
  const resources: string[] = [];
  for (let i = providerIndex + 2; i < parts.length; i += 2) {
    resources.push(parts[i]);
  }

  // Build the hierarchy from the resources
  let hierarchy: ArmResourceHierarchy | undefined;
  for (const resource of resources) {
    hierarchy = {
      name: upperFirst(singular(resource)),
      parent: hierarchy,
    };
  }

  return hierarchy || undefined;
}

function escapeRegex(str: string) {
  return str.replace(/\\/g, "\\\\");
  // return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); // $& means the whole matched string
}

// export function getArmResource(schema: ObjectSchema): TypespecArmResource | undefined {
//   const session = getSession();
//   const codeModel = session.model;
//   if (!isResourceModel(schema)) {
//     return undefined;
//   }
//   const resourceOperation = findResourceOperation(codeModel, schema);
//   const path = getOperationPath(resourceOperation);
//   const key = findResourceKey(resourceOperation);
//   return { kind: getResourceKind(schema), name: schema.language.default.name, schema, path };
// }

function findResourceKey(operation: Operation) {
  const path = getOperationPath(operation);
  const segments = path.split("/").filter((s) => s !== "");
  const resourceIdSegment = segments[segments.length - 1];
  const segmentName = segments[segments.length - 2];
  const keyName = resourceIdSegment.replace(/{|}/g, "");
  const parameter = operation.parameters?.find((p) => p.language.default.name === keyName);

  const stringSchema = parameter?.schema as StringSchema;
  return {
    name: keyName,
    doc: parameter?.language.default.description ?? "",
    location: parameter?.protocol?.http?.in ?? "path",
    pattern: stringSchema.pattern ?? "",
    segmentName,
  };
}

function findResourceOperation(codeModel: CodeModel, schema: ObjectSchema): Operation {
  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      for (const response of operation.responses ?? []) {
        if (isResponseSchema(response)) {
          if (response.schema === schema) {
            return operation;
          }
        }
      }
    }
  }
  throw new Error(`Unable to determine path for resource ${schema.language.default.name}`);
}

function getOperationPath(operation: Operation): string {
  for (const request of operation.requests ?? []) {
    if (request.protocol.http?.path) {
      return request.protocol.http.path;
    }
  }

  throw new Error(`Unable to determine path for operation ${operation.language.default.name}`);
}

function isResourceResponse(request: HttpRequest, schema: ObjectSchema) {
  for (const response of request.responses ?? []) {
    if (isResourceResponse(response, schema)) {
      return true;
    }
  }
}

function getResourceKind(schema: ObjectSchema) {
  for (const parent of schema.parents?.immediate ?? []) {
    switch (parent.language.default.name) {
      case "ProxyResource":
        return "ProxyResource";
      case "TrackedResource":
        return "TrackedResource";
      default:
        continue;
    }
  }

  throw new Error(`Unable to determine resource kind for schema ${schema.language.default.name}`);
}

function isResourceModel(schema: ObjectSchema): schema is ArmResourceSchema {
  return Boolean(schema.parents?.immediate.some((p) => _resourceKinds.includes(p.language.default.name)));
}
