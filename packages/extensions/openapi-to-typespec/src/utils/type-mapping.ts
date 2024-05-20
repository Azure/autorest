export function getFullyQualifiedName(type: string, namespace: string | undefined = undefined): string {
  switch (type) {
    case "ManagedServiceIdentity":
    case "TenantBaseParameters":
    case "BaseParameters":
    case "SubscriptionBaseParameters":
    case "ExtensionBaseParameters":
      return `${namespace ?? "Azure.ResourceManager.Foundations"}.${type}`;
    default:
      return type;
  }
}
