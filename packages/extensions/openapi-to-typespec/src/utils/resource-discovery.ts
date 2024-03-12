import { readFileSync } from "fs";
import { join } from "path";
import { CodeModel, ObjectSchema, Operation, SchemaResponse } from "@autorest/codemodel";
import { getArmCommonTypeVersion, getSession } from "../autorest-session";
import { TypespecObject, TspArmResource, TypespecEnum } from "../interfaces";
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

export interface Metadata {
  Resources: Record<string, ArmResource>;
  RenameMapping: Record<string, string>;
  OverrideOperationName: Record<string, string>;
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

let metadataCache: Metadata | undefined;

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

  if (resource.IsSingletonResource) {
    let predictSingletonResourcePath: string | undefined;
    if (resource.IsSingletonResource) {
      predictSingletonResourcePath = resource.GetOperations[0].Path.split("/").slice(0, -1).join("/");
    }

    for (const operationGroup of codeModel.operationGroups) {
      for (const operation of operationGroup.operations) {
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

export function getResourceExistOperation(resource: ArmResource): Operation | undefined {
  const codeModel = getSession().model;
  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (
        operation.requests?.length &&
        operation.requests[0].protocol?.http?.path === resource.GetOperations[0].Path &&
        operation.requests[0].protocol.http?.method === "head"
      ) {
        return operation;
      }
    }
  }
}

export function getArmResourcesMetadata(): Metadata {
  if (metadataCache) {
    return metadataCache;
  }
  const session = getSession();
  const outputFolder: string = session.configuration["output-folder"] ?? "";

  try {
    const content = readFileSync(join(outputFolder, "resources.json"), "utf-8");
    const metadata: Metadata = JSON.parse(content);
    metadataCache = metadata;

    return metadataCache;
  } catch (e) {
    throw new Error(`Failed to load resources.json from ${outputFolder} \n ${e}`);
  }
}

export interface ArmResourceSchema extends ObjectSchema {
  resourceMetadata: ArmResource;
}

export function tagSchemaAsResource(schema: ObjectSchema): void {
  const metadata = getArmResourcesMetadata();
  const resourcesMetadata = metadata.Resources;

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
  "ResourceProvisioningState",
  "OperationListResult",
  "Origin",
  "OperationDisplay",
  "OperationStatusResult",
  "ErrorDetail",
  "ErrorAdditionalInfo",
  "SystemData",
  "Operation",
  "ErrorResponse",
];

const _ArmCoreCustomTypes = [
  "TrackedResource",
  "ProxyResource",
  "ExtensionResource",
  "ManagedServiceIdentity",
  "ManagedIdentityProperties",
  "UserAssignedIdentity",
  "ManagedSystemAssignedIdentity",
  "ManagedSystemIdentityProperties",
  "EntityTag",
  "ResourcePlan",
  "ResourceSku",
];

export function filterArmModels(codeModel: CodeModel, objects: TypespecObject[]): TypespecObject[] {
  const filtered = [..._ArmCoreTypes];
  if (getArmCommonTypeVersion()) {
    filtered.push(..._ArmCoreCustomTypes);
  }
  for (const operationGroup of codeModel.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (operation.requests?.[0].protocol?.http?.path.match(/^\/providers\/[^/]+\/operations$/)) {
        const okResponse = operation.responses?.filter((o) => o.protocol.http?.statusCodes.includes("200"))?.[0];
        const objectName = (okResponse as SchemaResponse)?.schema?.language.default.name;
        if (objectName) {
          filtered.push(objectName);
        }
      }
    }
  }
  return objects.filter((o) => !filtered.includes(o.name) && !isGeneratedResourceObject(o.name));
}

const _ArmCoreEnums = [
  "CreatedByType",
  "Origin",
  "ActionType",
  "CheckNameAvailabilityRequest",
  "CheckNameAvailabilityReason",
];

const _ArmCoreCustomEnums = ["ManagedIdentityType", "ManagedSystemIdentityType", "SkuTier"];

export function filterArmEnums(enums: TypespecEnum[]): TypespecEnum[] {
  const filtered = [..._ArmCoreEnums];
  if (getArmCommonTypeVersion()) {
    filtered.push(..._ArmCoreCustomEnums);
  }
  return enums.filter((e) => !filtered.includes(e.name));
}

export function isTspArmResource(schema: TypespecObject): schema is TspArmResource {
  return Boolean((schema as TspArmResource).resourceKind);
}
