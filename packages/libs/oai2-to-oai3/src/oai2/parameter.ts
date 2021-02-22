import { OpenAPI2Definition } from "./definition";
import { OpenAPI2HeaderDefinition } from "./header";

export type OpenAPI2Parameter =
  | OpenAPI2BodyParameter
  | OpenAPI2HeaderParameter
  | OpenApi2FormDataParameter
  | OpenApi2QueryParameter
  | OpenApi2PathParameter;

export interface OpenAPI2BodyParameter {
  name: string;
  in: "body";
  type?: undefined;
  schema: OpenAPI2Definition;
  description?: string;
  required?: boolean;
  allowEmptyValue?: boolean;
  example?: unknown;
}

export interface OpenAPI2HeaderParameter extends OpenAPI2HeaderDefinition {
  name: string;
  in: "header";
  required?: boolean;
}

export interface OpenApi2FormDataParameter {
  name: string;
  in: "formData";
  type: "string" | "number" | "integer" | "boolean" | "array" | "file";
  schema?: OpenAPI2Definition;
  allowEmptyValue?: boolean;
  description?: string;
  required?: boolean;
  format?: string;
  example?: unknown;
  enum?: string[];
  allOf?: OpenAPI2Definition[];
  default?: unknown;
  items?: PrimitiveItems;
}

export interface OpenApi2QueryParameter {
  name: string;
  in: "query";
  type: "string" | "number" | "integer" | "boolean" | "array";
  allowEmptyValue?: boolean;
  description?: string;
  required?: boolean;
  format?: string;
  enum?: string[];
}

export interface OpenApi2PathParameter {
  name: string;
  in: "path";
  type: "string" | "number" | "integer" | "boolean" | "array";
  allowEmptyValue?: boolean;
  description?: string;
  required?: boolean;
  format?: string;
  enum?: string[];
}

export interface PrimitiveItems {
  type: "string" | "number" | "integer" | "boolean" | "array" | "file";
  format?: string;
  items?: PrimitiveItems;
  default?: unknown;
}
