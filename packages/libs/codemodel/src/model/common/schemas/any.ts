import { DeepPartial } from "@azure-tools/codegen";
import { Schema } from "../schema";
import { SchemaType } from "../schema-type";

export interface AnySchema extends Schema {}

export class AnySchema extends Schema implements AnySchema {
  constructor(description: string, objectInitializer?: DeepPartial<AnySchema>) {
    super("any", description, SchemaType.Any);
    this.apply(objectInitializer);
  }
}

export interface AnyObjectSchema extends Schema {
  type: SchemaType.AnyObject;
}

export class AnyObjectSchema extends Schema implements AnyObjectSchema {
  constructor(description: string, objectInitializer?: DeepPartial<AnyObjectSchema>) {
    super("AnyObject", description, SchemaType.AnyObject);
    this.apply(objectInitializer);
  }
}
