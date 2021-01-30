import { SchemaType } from "../schema-type";
import { Schema, PrimitiveSchema } from "../schema";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

/** a schema that represents a boolean value */
export interface BooleanSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.Boolean;
}

export class BooleanSchema extends PrimitiveSchema implements BooleanSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<BooleanSchema>) {
    super(name, description, SchemaType.Boolean);
    this.apply(objectInitializer);
  }
}

/** a schema that represents a Char value */
export interface CharSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.Char;
}

export class CharSchema extends PrimitiveSchema implements CharSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<CharSchema>) {
    super(name, description, SchemaType.Char);
    this.apply(objectInitializer);
  }
}
