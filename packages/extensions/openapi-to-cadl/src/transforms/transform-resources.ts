import { CodeModel, ObjectSchema, Operation, StringSchema } from "@autorest/codemodel";
import { upperFirst } from "lodash";
import pluralize, { singular } from "pluralize";
import { ArmResourceHierarchy, CadlDecorator, TypespecArmResource } from "../interfaces";
import { isResponseSchema } from "../utils/schemas";
import { transformOperation } from "./transform-operations";

const _resourceKinds = ["ProxyResource", "TrackedResource"];
export const ArmResourcesCache = new Map<ObjectSchema, TypespecArmResource>();
let _armResourcesnameCache: Set<string> | undefined;
export interface ArmResourceSchema extends ObjectSchema {
  armResource?: TypespecArmResource;
}

export function getArmResourceNames(): Set<string> {
  if (_armResourcesnameCache) {
    return _armResourcesnameCache;
  }

  _armResourcesnameCache = new Set<string>();
  for (const resource of ArmResourcesCache.values()) {
    _armResourcesnameCache.add(resource.name);
  }

  return _armResourcesnameCache;
}

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
      const resourceOperation = findResourceFirstOperation(codeModel, schema);

      const path = getOperationPath(resourceOperation);
      const key = findResourceKey(resourceOperation);

      const hierarchy = extractResourceHierarchy(path);

      const resourceDecorators: CadlDecorator[] = [];

      if (hierarchy?.parent) {
        resourceDecorators.push({ name: "parentResource", arguments: [hierarchy.parent.name] });
      }

      const resourceName = schema.language.default.name;

      const operations = findResourceOperations(codeModel, resourceName);

      ArmResourcesCache.set(schema, {
        kind: "object",
        operations,
        doc: schema.language.default.description,
        propertiesModelName: getPropertiesModelName(schema),
        resourceKind: getResourceKind(schema),
        name: resourceName,
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
              ...(key.pattern ? [{ name: "pattern", arguments: [escapeRegex(key.pattern)] }] : []),
              { name: "key", arguments: [key.name] },
              { name: key.location },
              { name: "segment", arguments: [key.segmentName] },
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

function findResourceFirstOperation(codeModel: CodeModel, schema: ObjectSchema): Operation {
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

const _defaultVerbs = ["get", "put", "patch", "delete"];

function findResourceOperations(codeModel: CodeModel, resourceName: string): Operation[] {
  return codeModel.operationGroups
    .filter((o) => o.language.default.name === pluralize(resourceName))
    .flatMap((og) => og.operations.filter((op) => !_defaultVerbs.includes(op.requests?.[0].protocol?.http?.method)));
}

function getOperationPath(operation: Operation): string {
  for (const request of operation.requests ?? []) {
    if (request.protocol.http?.path) {
      return request.protocol.http.path;
    }
  }

  throw new Error(`Unable to determine path for operation ${operation.language.default.name}`);
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
