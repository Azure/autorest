import { PathReference } from "../common";
import { OpenAPI2Definition } from "./definition";

export interface OpenAPI2HeaderDefinition {
  type: "string" | "number" | "integer" | "boolean" | "array";
  schema: PathReference & OpenAPI2Definition;
  items: any;
  collectionFormat: "csv" | "ssv" | "tsv" | "pipes" | "multi";
  description?: string;
  format?: string;
}
