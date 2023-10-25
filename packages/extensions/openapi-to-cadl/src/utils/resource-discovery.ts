import { readFileSync } from "fs";
import { join } from "path";
import { ObjectSchema, Operation } from "@autorest/codemodel";
import { getSession } from "../autorest-session";
import { CadlObject, TspArmResource } from "../interfaces";
import { isGeneratedResourceObject } from "../transforms/transform-arm-resources";
export interface _ArmResourceOperation {
  Name: string;
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
  GetOperations: _ArmResourceOperation[];
  CreateOperations: _ArmResourceOperation[];
  UpdateOperations: _ArmResourceOperation[];
  DeleteOperations: _ArmResourceOperation[];
  ListOperations: _ArmResourceOperation[];
  OperationsFromResourceGroupExtension: _ArmResourceOperation[];
  OperationsFromSubscriptionExtension: _ArmResourceOperation[];
  OperationsFromManagementGroupExtension: _ArmResourceOperation[];
  OperationsFromTenantExtension: _ArmResourceOperation[];
  OtherOperations: _ArmResourceOperation[];
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

export interface OperationWithResourceOperationFlag extends Operation {
  isResourceOperation?: boolean;
}

export function getResourceOperations(resource: ArmResource): Record<string, Operation> {
  const operations: Record<string, Operation> = {};
  const codeModel = getSession().model;

  const allOperations = resource.GetOperations.concat(resource.CreateOperations)
    .concat(resource.UpdateOperations)
    .concat(resource.DeleteOperations)
    .concat(resource.ListOperations)
    .concat(resource.OperationsFromResourceGroupExtension)
    .concat(resource.OperationsFromSubscriptionExtension)
    .concat(resource.OperationsFromManagementGroupExtension)
    .concat(resource.OperationsFromTenantExtension)
    .concat(resource.OtherOperations);
  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      for (const operationMetadata of allOperations) {
        if (operation.operationId === operationMetadata.OperationID) {
          operations[operation.operationId] = operation;
          (operation as OperationWithResourceOperationFlag).isResourceOperation = true;
        }
      }
    }
  }

  return operations;
}

export function getSingletonResouceListOperation(resource: ArmResource): Operation | undefined {
  const codeModel = getSession().model;

  let predictSingletonResourcePath: string | undefined;
  if (resource.IsSingletonResource) {
    predictSingletonResourcePath = resource.GetOperations[0].Path.split("/").slice(0, -1).join("/");
  }

  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (resource.IsSingletonResource) {
        // for singleton resource, c# will drop the list operation but we need to get it back
        if (
          operation.requests?.length &&
          operation.requests[0].protocol?.http?.path === predictSingletonResourcePath &&
          operation.requests[0].protocol.http?.method === "get"
        ) {
          return operation;
        }
      }
    }
  }
}

export function getArmResourcesMetadata(): Record<string, ArmResource> {
  if (armResourceCache) {
    return armResourceCache;
  }
  const session = getSession();
  const outputFolder: string = session.configuration["output-folder"] ?? "";

  try {
    const content = readFileSync(join(outputFolder, "resources.json"), "utf-8");
    const { Resources }: { Resources: Record<string, ArmResource> } = JSON.parse(content);
    armResourceCache = Resources;

    return armResourceCache;
  } catch (e) {
    throw new Error(`Failed to load resources.json from ${outputFolder} \n ${e}`);
  }
}

export interface ArmResourceSchema extends ObjectSchema {
  resourceMetadata: ArmResource;
}

export function tagSchemaAsResource(schema: ObjectSchema): void {
  const resourcesMetadata = getArmResourcesMetadata();

  for (const resourceName in resourcesMetadata) {
    if (resourcesMetadata[resourceName].SwaggerModelName.toLowerCase() === schema.language.default.name.toLowerCase()) {
      (schema as ArmResourceSchema).resourceMetadata = resourcesMetadata[resourceName];
      return;
    }
  }
}

export function isResourceSchema(schema: ObjectSchema): schema is ArmResourceSchema {
  return Boolean((schema as ArmResourceSchema).resourceMetadata);
}

const _ArmCoreTypes = [
  "Resource",
  "ProxyResource",
  "TrackedResource",
  "ErrorAdditionalInfo",
  "ErrorDetail",
  "ErrorResponse",
  "Operation",
  "OperationListResult",
  "OperationDisplay",
  "Origin",
  "SystemData",
  "Origin",
];

export function filterResourceRelatedObjects(objects: CadlObject[]): CadlObject[] {
  return objects.filter((o) => !_ArmCoreTypes.includes(o.name) && !isGeneratedResourceObject(o.name));
}

export function isTspArmResource(schema: CadlObject): schema is TspArmResource {
  return Boolean((schema as TspArmResource).resourceKind);
}
