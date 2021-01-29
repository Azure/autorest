import { OpenAPI2Definition } from "./definition";
import { OpenAPI2Path } from "./paths";

export interface OpenAPI2Document {
  swagger: "2.0";
  produces?: string[];
  consumes?: string[];
  schemes?: string[];
  host?: string;
  basePath?: string;
  paths: { [path: string]: OpenAPI2Path };
  definitions: { [name: string]: OpenAPI2Definition };
}

export interface OpenAPI2DocumentInfo {
  title: string;
  description: string;
  version: string;
}
