import { CodeModel, ObjectSchema, Operation, StringSchema } from "@autorest/codemodel";
import { upperFirst } from "lodash";
import { ArmCodeModel } from "main";
import pluralize, { singular } from "pluralize";
import { ArmResourceKind, ArmResourceObjectSchema, CadlDecorator, TypespecArmResource } from "../interfaces";
import { isResponseSchema } from "../utils/schemas";

const _resourceKinds = ["ProxyResource", "TrackedResource"];
export const ArmResourcesCache = new Map<ObjectSchema, TypespecArmResource>();
export let ArmResourcesCacheByName: Map<string, TypespecArmResource> | undefined;
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

function isArmObjectSchema(schema: ObjectSchema): schema is ArmResourceObjectSchema {
  return Boolean((schema as ArmResourceObjectSchema).resourceInformation);
}

function getModelName(codeModel: ArmCodeModel, resoureName: string) {
  return codeModel.armResources?.find((r) => r.Name === resoureName)?.ModelName;
}

export function calculateArmResources(codeModel: CodeModel) {
  if (ArmResourcesCache.size) {
    return ArmResourcesCache;
  }
  for (const schema of codeModel.schemas?.objects ?? []) {
    if (isArmObjectSchema(schema)) {
      const resourceOperation = findResourceFirstOperation(codeModel, schema);
      const resourceInformation = schema.resourceInformation;

      if (!resourceInformation) {
        throw new Error(`model ${schema.language.default.name} is a resource but doesn't contain resource information`);
      }

      const path = resourceInformation.Operations.find((o) => o.Method === "GET");
      const key = findResourceKey(resourceOperation);
      const resourceDecorators: CadlDecorator[] = [];

      if (resourceInformation.Parents.length) {
        const parent = getModelName(codeModel, resourceInformation.Parents[0]);
        parent &&
          resourceDecorators.push({
            name: "parentResource",
            arguments: [{ value: parent, options: { unwrap: true } }],
          });
      }

      const resourceName = schema.language.default.name;

      const operations = findResourceOperations(codeModel, resourceName);

      const res: TypespecArmResource = {
        kind: "object",
        metadata: key,
        operations,
        doc: schema.language.default.description,
        propertiesModelName: getPropertiesModelName(schema),
        resourceKind: getResourceKind(schema),
        name: resourceName,
        schema,
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
      };

      ArmResourcesCache.set(schema, res);
      const parent = extractResourceParent(path?.Path ?? "");
      if (parent) {
        res.resourceParent = parent;
      }
    }
  }
  return ArmResourcesCache;
}

function getArmResourcesCacheByName() {
  if (ArmResourcesCacheByName) {
    return ArmResourcesCacheByName;
  }

  ArmResourcesCacheByName = new Map<string, TypespecArmResource>();

  for (const resource of ArmResourcesCache.values()) {
    ArmResourcesCacheByName.set(resource.name, resource);
  }

  return ArmResourcesCacheByName;
}

function extractResourceParent(url: string): TypespecArmResource | undefined {
  // Split the URL by slashes
  const parts = url.split("/").filter((p) => p); // filter removes empty strings

  // Find the index of the "providers" keyword
  const providerIndex = parts.indexOf("providers");
  if (providerIndex === -1) {
    return undefined; // "providers" keyword not found, return null
  }

  // Extract resources from URL
  let resources: string[] = [];
  for (let i = providerIndex + 2; i < parts.length; i += 2) {
    resources.push(parts[i]);
  }

  resources = resources.reverse();
  resources.shift();
  resources = resources.reverse();

  // Build the hierarchy from the resources
  let parent: TypespecArmResource | undefined;
  const _cache = getArmResourcesCacheByName();
  for (const resource of resources) {
    const resourceName = upperFirst(singular(resource));
    parent = _cache.get(resourceName);
    if (parent) {
      return parent;
    }
  }

  return undefined;
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

function getResourceKind(schema: ArmResourceObjectSchema): ArmResourceKind {
  if (!schema.resourceInformation) {
    throw new Error(`Unable to determine resource kind for schema ${schema.language.default.name}`);
  }

  if (schema.resourceInformation.IsTrackedResource) {
    return "TrackedResource";
  }

  if (schema.resourceInformation.IsResource) {
    return "ProxyResource";
  }

  if (schema.resourceInformation.IsExtensionResource) {
    return "ExtensionResource";
  }
  throw new Error(`Unable to determine resource kind for schema ${schema.language.default.name}`);
}

function isResourceModel(schema: ObjectSchema): schema is ArmResourceSchema {
  return Boolean(schema.parents?.immediate.some((p) => _resourceKinds.includes(p.language.default.name)));
}
