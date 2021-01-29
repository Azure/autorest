import { OpenAPI2Definition, OpenAPI2Reference } from "./definition";
import { OpenAPI2HeaderDefinition } from "./header";
import { OpenAPI2Parameter } from "./parameter";

/**
 * Custom http method verb for autorest.
 */
export type HttpMethodCustom = "x-trace";

export type HttpMethod = "get" | "post" | "patch" | "put" | "delete" | "options" | "head" | "trace";

export type OpenAPI2Path = {
  [method in HttpMethod]: OpenAPI2Path;
} & {
  parameters: any[];
};

export interface OpenAPI2Operation {
  operationId: string;
  description: string;
  responses: OpenAPI2OperationResponses;
  parameters?: OpenAPI2Parameter[];
  produces?: string[];
  consumes?: string[];
}

export type OpenAPI2OperationResponses = { [statusCode: string]: OpenAPI2OperationResponse };

export interface OpenAPI2OperationResponse {
  description: string;
  schema?: OpenAPI2Definition;
  examples?: { [exampleName: string]: unknown };
  headers?: { [headerName: string]: OpenAPI2ResponseHeader };
}

export type OpenAPI2ResponseHeader = OpenAPI2Reference & OpenAPI2HeaderDefinition;
