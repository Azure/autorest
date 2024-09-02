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

export function getResourceType(path: string): string {
  const index = path.lastIndexOf(ProvidersSegment);
  if (index < 0 || path.substring(index + ProvidersSegment.length).includes("/") === false) {
    const pathToLower = path.toLowerCase();
    if (pathToLower.startsWith(ResourceGroupScopePrefix.toLowerCase())) return "Microsoft.Resources/resourceGroups";
    if (pathToLower.startsWith(SubscriptionScopePrefix.toLowerCase())) return "Microsoft.Resources/subscriptions";
    if (pathToLower.startsWith(TenantScopePrefix.toLowerCase())) return "Microsoft.Resources/tenants";
    throw `Path ${path} doesn't have resouce type`;
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
  return segments[segments.length - 1].replace(/^\{(.+)\}$/, "$1");
}

export function getResourceKeySegment(path: string): string {
  const segments = path.split("/");
  return segments[segments.length - 2];
}

export function getScopePath(path: string): string {
  const pathToLower = path.toLowerCase();

  const index = pathToLower.lastIndexOf(ProvidersSegment);
  if (index === 0 && pathToLower.startsWith(ManagementGroupScopePrefix.toLowerCase())) return ManagementGroupPath;
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

export function isSingleton(path: string): boolean {
  const segments = path.split("/");
  const lastSegment = segments[segments.length - 1];
  const pattern = /^\{\w+\}$/;
  return lastSegment.match(pattern) === null;
}

export function pathIncludes(path1: string, path2: string): boolean {
  const lowerPath1 = path1.toLowerCase();
  const lowerPath2 = path2.toLowerCase();
  // TO-DO: escape the variable case
  return lowerPath1.includes(lowerPath2);
}
