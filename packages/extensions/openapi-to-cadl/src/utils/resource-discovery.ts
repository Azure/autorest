import { readFileSync } from "fs";
import { dirname, join } from "path";
import { ObjectSchema, Operation } from "@autorest/codemodel";
import { getSession } from "../autorest-session";
import { CadlObject, TspArmResource } from "../interfaces";
export interface _ArmResourceOperation {
  Path: string;
  Method: string;
  OperationID: string;
  IsLongRunning: boolean;
  Description?: string;
  PagingMetadata: _ArmPagingMetadata | null;
}

export interface _ArmPagingMetadata {
  Method: string;
  NextPageMethod?: string;
  ItemName: string;
  NextLinkName: string;
}

export interface ArmResource {
  Name: string;
  Operations: _ArmResourceOperation[];
  Parents: string[];
  SwaggerModelName: string;
  ResourceType: string;
  ResourceKey: string;
  ResourceKeySegment: string;
  IsTrackedResource: boolean;
  IsTenantResource: boolean;
  IsSubscriptionResource: boolean;
  IsManagementGroupResource: boolean;
  IsExtensionResource: boolean;
  IsSingletonResource: boolean;
}

let armResourceCache: Record<string, ArmResource> | undefined;

export function getResourceOperations(resource: ArmResource): Operation[] {
  const operations: Operation[] = [];
  const codeModel = getSession().model;

  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      for (const operationMetadata of resource.Operations) {
        if (operation.operationId === operationMetadata.OperationID) {
          operations.push(operation);
        }
      }
      if (resource.IsSingletonResource) {
        // for singleton resource, c# will drop the list operation but we need to get it back
        
      }
    }
  }

  return operations;
}

export function getArmResourcesMetadata(): Record<string, ArmResource> {
  if (armResourceCache) {
    return armResourceCache;
  }
  const session = getSession();
  const configPath: string = session.configuration.configFileFolderUri;
  const configFiles: string[] = session.configuration.configurationFiles;
  const inputPath: string | undefined = (session.configuration.inputFileUris ?? [])[0];
  // const inputFiles: string[] = session.configuration["input-file"] ?? [];

  const localConfigFolder = dirname(configFiles.find((c) => c.startsWith(configPath)) ?? "").replace("file:", "").replace(/^\/+/g, "");
  let localInputFolder: string | undefined;

  if (inputPath && inputPath.startsWith("file:")) {
    localInputFolder = dirname(inputPath).replace("file:", "").replace(/^\/+/g, "");
  }

  const resourcesPath = localInputFolder ?? localConfigFolder;

  try {
    const content = readFileSync(join(resourcesPath, "resources.json"), "utf-8");
    const { Resources }: { Resources: Record<string, ArmResource> } = JSON.parse(content);
    armResourceCache = Resources;

    return armResourceCache;
  } catch (e) {
    throw new Error(`Failed to load resources.json from ${resourcesPath} \n ${e}`);
  }
}

export interface ArmResourceSchema extends ObjectSchema {
  resourceMetadata: ArmResource;
}

export function tagSchemaAsResource(schema: ObjectSchema): void {
  const resourcesMetadata = getArmResourcesMetadata();

  for (const resourceName in resourcesMetadata) {
    if (resourceName.toLowerCase() === schema.language.default.name.toLowerCase()) {
      (schema as ArmResourceSchema).resourceMetadata = resourcesMetadata[resourceName];
      return;
    }
  }
}

export function isResourceSchema(schema: ObjectSchema): schema is ArmResourceSchema {
  return Boolean((schema as ArmResourceSchema).resourceMetadata);
}

export function isResourceUpdateSchema(schema: ObjectSchema): boolean {
  const resourcesMetadata = getArmResourcesMetadata();
  for (const [key, resource] of Object.entries(resourcesMetadata)) {
    if (`${resource.Name}Update` === schema.language.default.name) {
      return true;
    }

    if (`${resource.Name}UpdateProperties` === schema.language.default.name) {
      return true;
    }
  }

  return false;
}

export function isTspArmResource(schema: CadlObject): schema is TspArmResource {
  return Boolean((schema as TspArmResource).resourceKind);
}
