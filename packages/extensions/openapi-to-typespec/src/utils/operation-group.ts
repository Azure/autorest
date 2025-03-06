import pluralize from "pluralize";
import { getSession } from "../autorest-session";
import { getOptions } from "../options";
import { ArmResource } from "./resource-discovery";

const operationGroupNameCache: Map<ArmResource, string> = new Map<ArmResource, string>();
export function getTSPOperationGroupName(resourceMetadata: ArmResource): string {
  if (operationGroupNameCache.has(resourceMetadata)) return operationGroupNameCache.get(resourceMetadata)!;

  // Try pluralizing the resource name first
  let operationGroupName = pluralize(resourceMetadata.SwaggerModelName);
  if (operationGroupName !== resourceMetadata.SwaggerModelName && !isExistingOperationGroupName(operationGroupName)) {
    operationGroupNameCache.set(resourceMetadata, operationGroupName);
  } else {
    // Try operationId then
    operationGroupName = resourceMetadata.GetOperation!.OperationID.split("_")[0];
    if (operationGroupName !== resourceMetadata.SwaggerModelName && !isExistingOperationGroupName(operationGroupName)) {
      operationGroupNameCache.set(resourceMetadata, operationGroupName);
    } else {
      operationGroupName = `${resourceMetadata.SwaggerModelName}OperationGroup`;
      operationGroupNameCache.set(resourceMetadata, operationGroupName);
    }
  }
  return operationGroupName;
}

function isExistingOperationGroupName(operationGroupName: string): boolean {
  const codeModel = getSession().model;
  return (
    codeModel.schemas.objects?.find((o) => o.language.default.name === operationGroupName) !== undefined ||
    Array.from(operationGroupNameCache.values()).find((v) => v === operationGroupName) !== undefined
  );
}

export function getTSPNonResourceOperationGroupName(name: string): string {
  const operationGroupName = `${name}OperationGroup`;
  if (!isExistingOperationGroupName(operationGroupName)) {
    return operationGroupName;
  }

  // Arm resource operation group name cannot be ended with "Operations"
  return getOptions().isArm ? `${name}NonResourceOperationGroup` : `${name}Operations`;
}
