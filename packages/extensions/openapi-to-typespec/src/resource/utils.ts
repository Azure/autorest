import { isConstantSchema } from "../utils/schemas";
import {
  ManagementGroupPath,
  ManagementGroupScopePrefix,
  ProvidersSegment,
  ResourceGroupPath,
  ResourceGroupScopePrefix,
  SubscriptionPath,
  SubscriptionScopePrefix,
  TenantPath,
  TenantScopePrefix,
} from "./constants";
import { OperationSet } from "./operation-set";

export function getResourceType(path: string): string {
  const index = path.lastIndexOf(ProvidersSegment);
  if (index < 0 || path.substring(index + ProvidersSegment.length).includes("/") === false) {
    const pathToLower = path.toLowerCase();
    if (pathToLower.startsWith(ResourceGroupScopePrefix.toLowerCase())) return "Microsoft.Resources/resourceGroups";
    if (pathToLower.startsWith(SubscriptionScopePrefix.toLowerCase())) return "Microsoft.Resources/subscriptions";
    if (pathToLower.startsWith(TenantScopePrefix.toLowerCase())) return "Microsoft.Resources/tenants";
    throw `Path ${path} doesn't have resource type`;
  }

  return path
    .substring(index + ProvidersSegment.length)
    .split("/")
    .reduce((result, current, index) => {
      if (index === 0 || index % 2 === 1) return result === "" ? current : `${result}/${current}`;
      else return result;
    }, "");
}

export function getResourceKey(path: string): string {
  const segments = path.split("/");
  return segments[segments.length - 1].replace(/^\{(\w+)\}$/, "$1");
}

export function getResourceKeySegment(path: string): string {
  const segments = path.split("/");
  return segments[segments.length - 2];
}

export function getScopePath(path: string): string {
  const pathToLower = path.toLowerCase();

  const index = pathToLower.lastIndexOf(ProvidersSegment);
  if (pathToLower.startsWith(ManagementGroupScopePrefix.toLowerCase())) return ManagementGroupPath;
  if (index >= 0) return path.slice(0, index);
  if (pathToLower.startsWith(ResourceGroupScopePrefix.toLowerCase())) return ResourceGroupPath;
  if (pathToLower.startsWith(SubscriptionScopePrefix.toLowerCase())) return SubscriptionPath;
  if (pathToLower.startsWith(TenantScopePrefix.toLowerCase())) return TenantPath;

  return path;
}

export function isScopedSegment(path: string): boolean {
  const pattern = /^\/?\{\w+\}\/?$/;
  return path.match(pattern) !== null;
}

export function isScopedPath(path: string): boolean {
  return isScopedSegment(getScopePath(path));
}

export function isSingleton(set: OperationSet): boolean {
  const lastSegment = getLastSegment(set.RequestPath);
  if (lastSegment.match(/^\{\w+\}$/) === null) return true;

  const resourceKey = lastSegment.replace(/^\{(\w+)\}$/, "$1");
  const resourceKeyParameter = set.Operations[0].parameters?.find((p) => p.language.default.name === resourceKey|| p.language.default.serializedName === resourceKey);
  if (resourceKeyParameter === undefined) throw `Cannot find parameter ${resourceKey} in operation ${set.Operations[0].operationId}`;
  return isConstantSchema(resourceKeyParameter?.schema);
}

export function pathIncludes(path1: string, path2: string): boolean {
  const lowerPath1 = path1.toLowerCase();
  const lowerPath2 = path2.toLowerCase();
  // TO-DO: escape the variable case
  return lowerPath1.includes(lowerPath2);
}

function getLastSegment(path: string): string {
  const segments = path.split("/");
  return segments[segments.length - 1];
}
