import { CodeModel, HttpMethod, Operation } from "@autorest/codemodel";
import { getLogger } from "../utils/logger";
import { _ArmPagingMetadata, _ArmResourceOperation, ArmResource, Metadata } from "../utils/resource-discovery";
import { lastWordToSingular } from "../utils/strings";
import {
  getExtensionOperation,
  getOtherOperations,
  getParents,
  getResourceCollectionOperations,
  setParentOfExtensionOperation,
  setParentOfOtherOperation,
  setParentOfResourceCollectionOperation,
} from "./find-parent";
import { findOperation, getResourceDataSchema, OperationSet } from "./operation-set";
import { getPagingItemType, isTrackedResource } from "./resource-equivalent";
import { getResourceKey, getResourceKeySegment, getResourceType, isScopedPath, isSingleton } from "./utils";

const logger = () => getLogger("parse-metadata");

export function parseMetadata(codeModel: CodeModel): Metadata {
  const operationSets: { [path: string]: OperationSet } = {};
  const operations = codeModel.operationGroups.flatMap((og) => og.operations);
  for (const operation of operations) {
    const path = getNormalizeHttpPath(operation);
    if (path in operationSets) {
      operationSets[path].Operations.push(operation);
    } else {
      operationSets[path] = { RequestPath: path, Operations: [operation] };
    }
  }

  const operationSetsByResourceDataSchemaName: { [name: string]: OperationSet[] } = {};
  for (const key in operationSets) {
    const operationSet = operationSets[key];
    const resourceSchemaName = getResourceDataSchema(operationSet);
    if (resourceSchemaName !== undefined) {
      // resourceSchemaName = lastWordToSingular(resourceSchemaName);

      if (resourceSchemaName in operationSetsByResourceDataSchemaName) {
        operationSetsByResourceDataSchemaName[resourceSchemaName].push(operationSet);
      } else {
        operationSetsByResourceDataSchemaName[resourceSchemaName] = [operationSet];
      }
    }
  }

  for (const key in operationSets) {
    const operationSet = operationSets[key];
    if (getResourceDataSchema(operationSet)) continue;

    for (const operation of operationSet.Operations) {
      // Check if this operation is a collection operation
      if (
        setParentOfResourceCollectionOperation(
          operation,
          key,
          Object.values(operationSetsByResourceDataSchemaName).flat(),
        )
      )
        continue;

      // Otherwise we find a request path that is the longest parent of this, and belongs to a resource
      if (setParentOfOtherOperation(operation, key, Object.values(operationSetsByResourceDataSchemaName).flat()))
        continue;

      setParentOfExtensionOperation(operation, key, Object.values(operationSetsByResourceDataSchemaName).flat());
    }
  }

  const resources: { [name: string]: ArmResource } = {};
  for (const resourceSchemaName in operationSetsByResourceDataSchemaName) {
    const operationSets = operationSetsByResourceDataSchemaName[resourceSchemaName];
    if (operationSets.length > 1) {
      throw `We cannot support multi path with same model.\nResource schema name: ${resourceSchemaName}.\nPath:\n${operationSets
        .map((o) => o.RequestPath)
        .join("\n")}`;
    }
    resources[resourceSchemaName] = buildResource(
      resourceSchemaName,
      operationSets[0],
      Object.values(operationSetsByResourceDataSchemaName).flat(),
      codeModel,
    );
  }

  return {
    Resources: resources,
    RenameMapping: {},
    OverrideOperationName: {},
  };
}

// TO-DO: handle expanded resource
function buildResource(
  resourceSchemaName: string,
  set: OperationSet,
  operationSets: OperationSet[],
  codeModel: CodeModel,
): ArmResource {
  const getOperation = buildLifeCycleOperation(set, HttpMethod.Get, "Get");
  const createOperation = buildLifeCycleOperation(set, HttpMethod.Put, "CreateOrUpdate");
  const updateOperation =
    buildLifeCycleOperation(set, HttpMethod.Patch, "Update") ?? buildLifeCycleOperation(set, HttpMethod.Put, "Update");
  const deleteOperation = buildLifeCycleOperation(set, HttpMethod.Delete, "Delete");
  const listOperation = buildListOperation(set);
  const otherOperation = buildOtherOperation(set);

  const resourceSchema = codeModel.schemas.objects?.find((o) => o.language.default.name === resourceSchemaName);
  if (!resourceSchema) {
    logger().error(`Cannot find resource schema for name ${resourceSchemaName}`);
  }

  const parents = getParents(set.RequestPath, operationSets);
  const isTenantResource = parents.length > 0 && parents[0] === "TenantResource";
  const isSubscriptionResource = parents.length > 0 && parents[0] === "SubscriptionResource";
  const isManagementGroupResource = parents.length > 0 && parents[0] === "ManagementGroupResource";

  const operationsFromResourceGroupExtension = [];
  const operationsFromSubscriptionExtension = [];
  const operationsFromManagementGroupExtension = [];
  const operationsFromTenantExtension = [];

  for (const extension of getExtensionOperation(set)) {
    const extensionOperation = buildResourceOperationFromOperation(extension[0], "_");
    switch (extension[1]) {
      case "ResourceGroup":
        operationsFromResourceGroupExtension.push(extensionOperation);
        break;
      case "Subscription":
        operationsFromSubscriptionExtension.push(extensionOperation);
        break;
      case "ManagementGroup":
        operationsFromManagementGroupExtension.push(extensionOperation);
        break;
      case "Tenant":
        operationsFromTenantExtension.push(extensionOperation);
        break;
    }
  }

  return {
    Name: lastWordToSingular(resourceSchemaName),
    GetOperations: getOperation ? [getOperation] : [],
    CreateOperations: createOperation ? [createOperation] : [],
    UpdateOperations: updateOperation ? [updateOperation] : [],
    DeleteOperations: deleteOperation ? [deleteOperation] : [],
    ListOperations: listOperation ?? [],
    OperationsFromResourceGroupExtension: operationsFromResourceGroupExtension,
    OperationsFromSubscriptionExtension: operationsFromSubscriptionExtension,
    OperationsFromManagementGroupExtension: operationsFromManagementGroupExtension,
    OperationsFromTenantExtension: operationsFromTenantExtension,
    OtherOperations: otherOperation,
    Parents: parents,
    SwaggerModelName: resourceSchemaName,
    ResourceType: getResourceType(set.RequestPath),
    ResourceKey: getResourceKey(set.RequestPath),
    ResourceKeySegment: getResourceKeySegment(set.RequestPath),
    IsTrackedResource: isTrackedResource(resourceSchema!),
    IsTenantResource: isTenantResource,
    IsSubscriptionResource: isSubscriptionResource,
    IsManagementGroupResource: isManagementGroupResource,
    IsExtensionResource: isScopedPath(set.RequestPath),
    IsSingletonResource: isSingleton(set.RequestPath),
  };
}

function buildResourceOperationFromOperation(operation: Operation, operationName: string): _ArmResourceOperation {
  let pagingMetadata: _ArmPagingMetadata | null = null;
  if (operationName === "GetAll" || getPagingItemType(operation) !== undefined) {
    let itemName = "value";
    let nextLinkName = "nextLink";
    if (operation.extensions?.["x-ms-pageable"]?.itemName) {
      itemName = operation.extensions?.["x-ms-pageable"]?.itemName;
    }
    if (operation.extensions?.["x-ms-pageable"]?.nextLinkName) {
      nextLinkName = operation.extensions?.["x-ms-pageable"]?.nextLinkName;
    }

    pagingMetadata = {
      Method: operation.language.default.name,
      ItemName: itemName,
      NextLinkName: nextLinkName,
      NextPageMethod: undefined, // We are not using it
    };
  }

  const method = operation.requests![0].protocol.http?.method;
  return {
    Name: operationName,
    Path: operation.requests![0].protocol.http?.path,
    Method: method.toUpperCase(),
    OperationID: operation.operationId ?? "",
    IsLongRunning:
      operation.extensions?.["x-ms-long-running-operation"] === true ||
      method === HttpMethod.Put ||
      method === HttpMethod.Delete,
    PagingMetadata: pagingMetadata,
    Description: operation.language.default.description,
  };
}

function buildOtherOperation(set: OperationSet): _ArmResourceOperation[] {
  const operations = getOtherOperations(set);
  return operations.map((o) => buildResourceOperationFromOperation(o, o.language.default.name));
}

function buildListOperation(set: OperationSet): _ArmResourceOperation[] | undefined {
  const operation = getResourceCollectionOperations(set);
  return operation?.length ? operation.map((o) => buildResourceOperationFromOperation(o, "GetAll")) : undefined;
}

function buildLifeCycleOperation(
  set: OperationSet,
  method: HttpMethod,
  operationName: string,
): _ArmResourceOperation | undefined {
  const operation = findOperation(set, method);
  return operation ? buildResourceOperationFromOperation(operation, operationName) : undefined;
}

function getNormalizeHttpPath(operation: Operation): string {
  if (operation.requests?.length !== 1) {
    throw `No request or more than 1 requests in operation ${operation.operationId}`;
  }

  const path = operation.requests![0].protocol.http?.path;
  const normalizedPath = path?.length === 1 ? path : path?.replace(/\/$/, "");
  if (!normalizedPath) throw `Invalid http path ${path} for operation ${operation.operationId}`;
  return normalizedPath;
}
