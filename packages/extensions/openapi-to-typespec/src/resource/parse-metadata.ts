import { CodeModel, HttpMethod, Operation } from "@autorest/codemodel";
import { getLogger } from "../utils/logger";
import { _ArmPagingMetadata, _ArmResourceOperation, ArmResource, Metadata } from "../utils/resource-discovery";
import { findOperation, getParentOfLifeCycleOperation, getParentOfResourceCollectionOperation, getResourceDataSchema, getResourceType, OperationSet } from "./operation-set";
import { lastWordToSingular } from "../utils/strings";

const logger = () => getLogger("parse-metadata");

export function parseMetadata(codeModel: CodeModel): Metadata {
    const operationSets: {[path: string]: OperationSet} = {};
    const operations = codeModel.operationGroups.flatMap(og => og.operations);
    for (const operation of operations) {
        const path = getNormalizeHttpPath(operation);
        if (path in operationSets) {
            operationSets[path].Operations.push(operation);
        }
        else {
            operationSets[path] = {RequestPath: path, Operations: [operation]};
        }
    }

    const operationSetsByResourceDataSchemaName: {[name: string]: OperationSet[]} = {};
    for (const key in operationSets) {
        const operationSet = operationSets[key];
        let resourceSchemaName = getResourceDataSchema(operationSet);
        if (resourceSchemaName !== undefined) {
            // resourceSchemaName = lastWordToSingular(resourceSchemaName);

            if (resourceSchemaName in operationSetsByResourceDataSchemaName) {
                operationSetsByResourceDataSchemaName[resourceSchemaName].push(operationSet);
            }
            else {
                operationSetsByResourceDataSchemaName[resourceSchemaName] = [operationSet];
            }
        }
    }

    const childOperationsByRequestPath: {[path: string]: Operation[]} = {};
    for (const key in operationSets) {
        const operationSet = operationSets[key];
        if (getResourceDataSchema(operationSet)) continue;

        for (const operation of operationSet.Operations) {
            // Check if this operation is a collection operation
            let parentPath = getParentOfResourceCollectionOperation(operation, key, Object.values(operationSetsByResourceDataSchemaName).flat());
            // Otherwise we find a request path that is the longest parent of this, and belongs to a resource
            if (parentPath === undefined) {
                parentPath = getParentOfLifeCycleOperation(key, Object.values(operationSetsByResourceDataSchemaName).flat());
            }

            if (parentPath !== undefined) {
                if (parentPath in childOperationsByRequestPath) {
                    childOperationsByRequestPath[parentPath].push(operation);
                }
                else {
                    childOperationsByRequestPath[parentPath] = [operation];
                }
            }
        }
    }

    const resources: {[name: string]: ArmResource} = {};
    for (const resourceSchemaName in operationSetsByResourceDataSchemaName) {
        const operationSets = operationSetsByResourceDataSchemaName[resourceSchemaName];
        if (operationSets.length > 1) {
            throw `SchemaName: ${resourceSchemaName} has more than one operation set`;
        }
        resources[resourceSchemaName] = buildResource(resourceSchemaName, operationSets[0], childOperationsByRequestPath);

    }

    return {
        Resources: resources,
        RenameMapping: {},
        OverrideOperationName: {}
    };
}

// TO-DO: handle expanded resource
function buildResource(resourceSchemaName: string, set: OperationSet, childOperationsByRequestPath: {[path: string]: Operation[]}): ArmResource {
    const getOperation = buildLifeCycleOperation(set, HttpMethod.Get, "Get");
    const createOperation = buildLifeCycleOperation(set, HttpMethod.Put, "CreateOrUpdate");
    const updateOperation = buildLifeCycleOperation(set, HttpMethod.Patch, "Update") ?? buildLifeCycleOperation(set, HttpMethod.Put, "Update");
    const deleteOperation = buildLifeCycleOperation(set, HttpMethod.Delete, "Delete");
    const listOperation = buildListOperation(set.RequestPath, childOperationsByRequestPath);
    const otherOperation = buildOtherOperation(set.RequestPath, childOperationsByRequestPath);
    return {
        Name: lastWordToSingular(resourceSchemaName),
        GetOperations: getOperation? [getOperation] : [],
        CreateOperations: createOperation ? [createOperation] : [],
        UpdateOperations: updateOperation ? [updateOperation] : [],
        DeleteOperations: deleteOperation ? [deleteOperation] : [],
        ListOperations: listOperation ? [listOperation] : [],
        OperationsFromResourceGroupExtension: [],
        OperationsFromSubscriptionExtension: [],
        OperationsFromManagementGroupExtension: [],
        OperationsFromTenantExtension: [],
        OtherOperations: otherOperation,
        Parents: [""],
        SwaggerModelName: resourceSchemaName,
        ResourceType: getResourceType(set.RequestPath),
        ResourceKey: "",
        ResourceKeySegment: "",
        IsTrackedResource: false,
        IsTenantResource: false,
        IsSubscriptionResource: false,
        IsManagementGroupResource: false,
        IsExtensionResource: false,
        IsSingletonResource: false,
    };
}

function buildResourceOperationFromOperation(operation: Operation, operationName: string): _ArmResourceOperation {
    let pagingMetadata: _ArmPagingMetadata | null = null;
    if (operationName === "GetAll") {
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
            NextPageMethod: undefined // We are not using it
        };
    }

    return {
        Name: operationName,
        Path: operation.requests![0].protocol.http?.path,
        Method: operation.requests![0].protocol.http?.method,
        OperationID: operation.operationId ?? "",
        IsLongRunning: operation.extensions?.["x-ms-parameter-grouping"] === true,
        Description: operation.language.default.description,
        PagingMetadata: pagingMetadata
    };
}

function buildOtherOperation(requestPath: string, childOperationsByRequestPath: {[path: string]: Operation[]}): _ArmResourceOperation[] {
    const operations = childOperationsByRequestPath[requestPath]?.filter(o => o.requests![0].protocol.http?.method === HttpMethod.Post);
    return operations ? operations.map(o => buildResourceOperationFromOperation(o, o.language.default.name)) : [];
}

function buildListOperation(requestPath: string, childOperationsByRequestPath: {[path: string]: Operation[]}):_ArmResourceOperation | undefined {
    const operation = childOperationsByRequestPath[requestPath]?.find(o => o.requests![0].protocol.http?.method === HttpMethod.Get);
    return operation ? buildResourceOperationFromOperation(operation, "GetAll") : undefined;
}

function buildLifeCycleOperation(set: OperationSet, method: HttpMethod, operationName: string): _ArmResourceOperation | undefined {
    const operation = findOperation(set, method);
    return operation ? buildResourceOperationFromOperation(operation, operationName) : undefined;
}

function getNormalizeHttpPath(operation: Operation): string {
    if (operation.requests?.length !== 1) {
        logger().error(`No request or more than 1 requests in operation ${operation.operationId}`);
    }

    const path = operation.requests![0].protocol.http?.path;
    return (path?.length === 1 ? path : path?.replace(/\/$/, '')) ?? logger().error(`Invalid http path ${path} for operation ${operation.operationId}`);
}