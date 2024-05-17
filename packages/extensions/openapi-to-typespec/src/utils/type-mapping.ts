export function getFullyQualifiedName(type: string): string {
  switch (type) {
    case "ManagedServiceIdentity":
      return "Azure.ResourceManager.Foundations.ManagedServiceIdentity";
    default:
      return type;
  }
}
