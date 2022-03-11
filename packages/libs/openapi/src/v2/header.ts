import { OpenAPI2Definition, OpenAPI2Reference } from "./definition";

export interface OpenAPI2HeaderDefinition {
  type: "string" | "number" | "integer" | "boolean" | "array";
  schema: OpenAPI2Reference & OpenAPI2Definition;
  items: any;
  collectionFormat: "csv" | "ssv" | "tsv" | "pipes" | "multi";
  description?: string;
  format?: string;
}
