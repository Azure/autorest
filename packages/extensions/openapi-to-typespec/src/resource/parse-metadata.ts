import { CodeModel, HttpMethod, Operation } from "@autorest/codemodel";
import { getLogger } from "utils/logger";
import { _ArmResourceOperation, ArmResource, Metadata } from "utils/resource-discovery";
import { findOperation, getResourceDataSchema, OperationSet } from "./operation-set";
import { lastWordToSingular } from "utils/strings";

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
            resourceSchemaName = lastWordToSingular(resourceSchemaName);

            if (resourceSchemaName in operationSetsByResourceDataSchemaName) {
                operationSetsByResourceDataSchemaName[resourceSchemaName].push(operationSet);
            }
            else {
                operationSetsByResourceDataSchemaName[resourceSchemaName] = [operationSet];
            }
        }
    }

    for (const resourceSchemaName in operationSetsByResourceDataSchemaName) {
        const operationSets = operationSetsByResourceDataSchemaName[resourceSchemaName];
        for (const operationSet of operationSets) {
            
        }
    }
}

// TO-DO: handle expanded resource
function buildResource(resourceSchemaName: string, set: OperationSet): ArmResource {
    const getOperation = buildOperation(set, HttpMethod.Get, "Get");
    const createOperation = buildOperation(set, HttpMethod.Put, "CreateOrUpdate");
    const updateOperation = buildOperation(set, HttpMethod.Patch, "Update") ?? buildOperation(set, HttpMethod.Put, "Update");
    const deleteOperation = buildOperation(set, HttpMethod.Delete, "Delete");
    
}

function buildOperation(set: OperationSet, method: HttpMethod, operationName: string): _ArmResourceOperation | undefined {
    const operation = findOperation(set, method);
    return operation === undefined ? undefined : {
        Name: operationName,
        Path: set.RequestPath,
        Method: method,
        OperationID: operation.operationId ?? "",
        IsLongRunning: operation.extensions?.["x-ms-parameter-grouping"] === true,
        Description: operation.language.default.description,
        PagingMetadata: {
            Method: operationName,
            ItemName: operation.language.default.paging.itemName,
            NextLinkName: operation.language.default.paging.nextLinkName,
            NextPageMethod: undefined // We are not using it
        }
    };
}

function getNormalizeHttpPath(operation: Operation): string {
    if (operation.requests?.length !== 1) {
        logger().error(`No request or more than 1 requests in operation ${operation.operationId}`);
    }

    const path = operation.requests![0].protocol.http?.path;
    return (path?.length === 1 ? path : path?.replace(/\/$/, '')) ?? logger().error(`Invalid http path ${path} for operation ${operation.operationId}`);
}
