import { Metadata } from "./metadata";
import { Schema } from "./schema";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

/** a response from a service.  */
export interface Response extends Metadata {}

export class Response extends Metadata implements Response {
  constructor(objectInitializer?: DeepPartial<Response>) {
    super();
    this.apply(objectInitializer);
  }
}

/** a response where the content should be treated as a binary instead of a value or object */
export interface BinaryResponse extends Response {
  /** indicates that this response is a binary stream  */
  binary: true;
}

export class BinaryResponse extends Response implements BinaryResponse {
  constructor(objectInitializer?: DeepPartial<BinaryResponse>) {
    super();
    this.binary = true;
    this.apply(objectInitializer);
  }
}

/** a response that should be deserialized into a result of type(schema) */
export interface SchemaResponse extends Response {
  /** the content returned by the service for a given operaiton */
  schema: Schema;

  /** indicates whether the response can be 'null' */
  nullable?: boolean;
}

export class SchemaResponse extends Response implements SchemaResponse {
  constructor(schema: Schema, objectInitializer?: DeepPartial<SchemaResponse>) {
    super();
    this.schema = schema;
    this.apply(objectInitializer);
  }
}
