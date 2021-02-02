import { KnownMediaType } from "@azure-tools/codegen";

export enum SchemaContext {
  /** Schema is used as an input to an operation. */
  Input = "input",

  /** Schema is used as an output from an operation. */
  Output = "output",

  /** Schema is used as an exception from an operation. */
  Exception = "exception",
}

export interface SchemaUsage {
  /** contexts in which the schema is used */
  usage?: SchemaContext[];

  /** Known media types in which this schema can be serialized */
  serializationFormats?: KnownMediaType[];
}
