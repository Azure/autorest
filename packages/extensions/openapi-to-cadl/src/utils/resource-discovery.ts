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
  for (const operationMetadata of resource.Operations) {
    for (const operationGroup of codeModel.operationGroups) {
      for (const operation of operationGroup.operations) {
        if (operation.operationId === operationMetadata.OperationID) {
          operations.push(operation);
        }
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
  const localConfigFolder = dirname(configFiles.find((c) => c.startsWith(configPath)) ?? "").replace("file://", "");

  try {
    const { Resources }: { Resources: Record<string, ArmResource> } = require(join(
      localConfigFolder,
      "resources.json",
    ));
    armResourceCache = Resources;

    return armResourceCache;
  } catch (e) {
    throw new Error(`Failed to load resources.json from ${localConfigFolder} \n ${e}`);
  }
}

export interface ArmResourceSchema extends ObjectSchema {
  resourceMetadata: ArmResource;
}

export function tagSchemaAsResource(schema: ObjectSchema): void {
  const resourcesMetadata = getArmResourcesMetadata();
  const resourceMetadata = resourcesMetadata[schema.language.default.name];

  if (!resourceMetadata) {
    return;
  }

  (schema as ArmResourceSchema).resourceMetadata = resourceMetadata;
}

export function isResourceSchema(schema: ObjectSchema): schema is ArmResourceSchema {
  return Boolean((schema as ArmResourceSchema).resourceMetadata);
}

export function isTspArmResource(schema: CadlObject): schema is TspArmResource {
  return Boolean((schema as TspArmResource).resourceKind);
}
