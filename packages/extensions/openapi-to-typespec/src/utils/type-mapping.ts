import { isObjectSchema, Response } from "@autorest/codemodel";
import { isArraySchema, isResponseSchema, isStringSchema, isUriSchema } from "./schemas";

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

export function isResourceListResult(schema: Response): boolean {
  if (!isResponseSchema(schema)) return false;

  if (!schema.schema.language.default.name.endsWith("ListResult")) return false;
  if (!isObjectSchema(schema.schema)) return false;

  const valueSchema = schema.schema.properties?.find((p) => p.language.default.name === "value");
  if (valueSchema === undefined) return false;
  if (!isArraySchema(valueSchema.schema)) return false;

  const elementSchema = valueSchema.schema.elementType;
  if (!isObjectSchema(elementSchema)) return false;
  if (elementSchema.properties?.find((p) => p.language.default.name === "id") === undefined) return false;
  if (elementSchema.properties?.find((p) => p.language.default.name === "name") === undefined) return false;
  if (elementSchema.properties?.find((p) => p.language.default.name === "type") === undefined) return false;
  if (elementSchema.properties?.find((p) => p.language.default.name === "systemData") === undefined) return false;

  const nextLinkSchema = schema.schema.properties?.find((p) => p.language.default.name === "nextLink");
  if (nextLinkSchema === undefined) return false;
  if (!isStringSchema(nextLinkSchema.schema) && !isUriSchema(nextLinkSchema.schema)) return false;

  addToSkipList(schema.schema.language.default.name);
  return true;
}

const skipSet = new Set<string>();
function addToSkipList(name: string) {
  skipSet.add(name);
}
export function getSkipList(): Set<string> {
  return skipSet;
}
