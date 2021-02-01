export interface OpenAPI2Definition {
  [key: string]: unknown;

  additionalProperties?: OpenAPI2Definition | OpenAPI2Reference | boolean;
  allOf?: OpenAPI2Definition[];
  description?: string;
  enum?: string[];
  format?: string;
  items?: OpenAPI2Definition | OpenAPI2Reference;
  oneOf?: (OpenAPI2Definition | OpenAPI2Reference)[];
  properties?: { [index: string]: OpenAPI2Definition | OpenAPI2Reference };
  required?: string[];
  title?: string;
  type?: OpenAPI2Type; // allow this to be optional to cover cases when this is missing
}

export interface OpenAPI2Reference {
  $ref: string;
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
