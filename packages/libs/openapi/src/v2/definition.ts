import { PathReference } from "../common";

export interface OpenAPI2Definition {
  [key: string]: unknown;

  additionalProperties?: OpenAPI2Definition | PathReference | boolean;
  allOf?: OpenAPI2Definition[];
  description?: string;
  enum?: string[];
  format?: string;
  items?: OpenAPI2Definition | PathReference;
  oneOf?: (OpenAPI2Definition | PathReference)[];
  properties?: { [index: string]: OpenAPI2Definition | PathReference };
  required?: string[];
  title?: string;
  type?: OpenAPI2Type; // allow this to be optional to cover cases when this is missing
}

export type OpenAPI2Type =
  | "array"
  | "boolean"
  | "byte"
  | "date"
  | "dateTime"
  | "double"
  | "float"
  | "integer"
  | "long"
  | "number"
  | "object"
  | "string";
