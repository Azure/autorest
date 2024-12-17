import { isObjectSchema, Operation, Response } from "@autorest/codemodel";
import { isArraySchema, isResponseSchema, isStringSchema, isUriSchema } from "./schemas";
import { TypespecTemplateModel } from "../interfaces";
import { isResource } from "../resource/resource-equivalent";

export function getFullyQualifiedName(type: string, namespace: string | undefined = undefined): string {
  switch (type) {
    case "ManagedServiceIdentity":
    case "TenantBaseParameters":
    case "BaseParameters":
    case "SubscriptionBaseParameters":
    case "ExtensionBaseParameters":
    case "LocationBaseParameters":
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
  if (!isResource(elementSchema)) return false;

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

export interface NamesOfResponseTemplate {
  _200Name?: string;
  _200NameNoBody?: string;
  _201Name?: string;
  _201NameNoBody?: string;
  _202Name?: string;
  _202NameNoBody?: string;
  _204Name?: string;
}

export function getTemplateResponses(
  operation: Operation,
  namesOfResponseTemplate: NamesOfResponseTemplate,
): TypespecTemplateModel[] {
  const responses: TypespecTemplateModel[] = [];

  const _200Response = operation.responses?.find((r) => r.protocol.http?.statusCodes[0] === "200");
  if (_200Response) {
    if (isResponseSchema(_200Response) && namesOfResponseTemplate._200Name) {
      responses.push({
        kind: "template",
        name: namesOfResponseTemplate._200Name,
        arguments: [{ kind: "object", name: _200Response.schema.language.default.name }],
      });
    } else if (!isResponseSchema(_200Response) && namesOfResponseTemplate._200NameNoBody) {
      responses.push({ kind: "template", name: namesOfResponseTemplate._200NameNoBody });
    }
  }

  const _201Response = operation.responses?.find((r) => r.protocol.http?.statusCodes[0] === "201");
  if (_201Response) {
    if (isResponseSchema(_201Response) && namesOfResponseTemplate._201Name) {
      responses.push({
        kind: "template",
        name: namesOfResponseTemplate._201Name,
        arguments: [{ kind: "object", name: _201Response.schema.language.default.name }],
      });
    } else if (!isResponseSchema(_201Response) && namesOfResponseTemplate._201NameNoBody) {
      responses.push({ kind: "template", name: namesOfResponseTemplate._201NameNoBody });
    }
  }

  const _202Response = operation.responses?.find((r) => r.protocol.http?.statusCodes[0] === "202");
  if (_202Response) {
    if (isResponseSchema(_202Response) && namesOfResponseTemplate._202Name) {
      responses.push({
        kind: "template",
        name: namesOfResponseTemplate._202Name,
        additionalProperties: [
          {
            kind: "parameter",
            name: "body",
            isOptional: false,
            type: _202Response.schema.language.default.name,
            location: "body",
            serializedName: "body",
            decorators: [{ name: "bodyRoot" }],
          },
        ],
      });
    } else if (!isResponseSchema(_202Response) && namesOfResponseTemplate._202NameNoBody) {
      responses.push({ kind: "template", name: namesOfResponseTemplate._202NameNoBody });
    }
  }

  const _204Response = operation.responses?.find((r) => r.protocol.http?.statusCodes[0] === "204");
  if (_204Response && namesOfResponseTemplate._204Name) {
    responses.push({ kind: "template", name: namesOfResponseTemplate._204Name });
  }

  return responses;
}
