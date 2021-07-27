import { OpenAPI2Definition } from "./definition";
import { OpenAPI2HeaderDefinition } from "./header";

export type OpenAPI2Parameter =
  | OpenAPI2BodyParameter
  | OpenAPI2HeaderParameter
  | OpenAPI2FormDataParameter
  | OpenAPI2QueryParameter
  | OpenAPI2PathParameter;

export interface OpenAPI2ParameterBase {
  "x-ms-client-name"?: string;
  "x-ms-parameter-location"?: string;
}

export interface OpenAPI2BodyParameter extends OpenAPI2ParameterBase {
  name: string;
  in: "body";
  schema: OpenAPI2Definition;
  description?: string;
  required?: boolean;
  allowEmptyValue?: boolean;
  example?: unknown;

  "x-ms-client-flatten"?: boolean;
}

export interface OpenAPI2HeaderParameter extends OpenAPI2HeaderDefinition, OpenAPI2ParameterBase {
  name: string;
  in: "header";
  required?: boolean;
}

export interface OpenAPI2FormDataParameter extends OpenAPI2ParameterBase {
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

  "x-ms-client-flatten"?: boolean;
}

export interface OpenAPI2QueryParameter extends OpenAPI2ParameterBase {
  name: string;
  in: "query";
  type: "string" | "number" | "integer" | "boolean" | "array";
  allowEmptyValue?: boolean;
  description?: string;
  required?: boolean;
  format?: string;
  enum?: string[];
}

export interface OpenAPI2PathParameter extends OpenAPI2ParameterBase {
  name: string;
  in: "path";
  type: "string" | "number" | "integer" | "boolean" | "array";
  allowEmptyValue?: boolean;
  description?: string;
  required?: boolean;
  format?: string;
  enum?: string[];
}

export interface PrimitiveItems extends OpenAPI2ParameterBase {
  type: "string" | "number" | "integer" | "boolean" | "array" | "file";
  format?: string;
  items?: PrimitiveItems;
  default?: unknown;
}
