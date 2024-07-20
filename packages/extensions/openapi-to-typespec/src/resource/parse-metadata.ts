import { CodeModel, Operation } from "@autorest/codemodel";
import { getLogger } from "utils/logger";
import { Metadata } from "utils/resource-discovery";
import { OperationSet } from "./operation-set";

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

    
}

function getNormalizeHttpPath(operation: Operation): string {
    if (operation.requests?.length !== 1) {
        logger().error(`No request or more than 1 requests in operation ${operation.operationId}`);
    }

    const path = operation.requests![0].protocol.http?.path;
    return (path?.length === 1 ? path : path?.replace(/\/$/, '')) ?? logger().error(`Invalid http path ${path} for operation ${operation.operationId}`);
}
