import { Schema } from "../schema";
import { DeepPartial } from "@azure-tools/codegen";
import { SchemaType } from "../schema-type";

export interface BinarySchema extends Schema {}

export class BinarySchema extends Schema implements BinarySchema {
  constructor(description: string, objectInitializer?: DeepPartial<BinarySchema>) {
    super("binary", description, SchemaType.Binary);
    this.apply(objectInitializer);
  }
}
