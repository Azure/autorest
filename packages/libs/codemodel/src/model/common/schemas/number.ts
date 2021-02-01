import { SchemaType } from "../schema-type";
import { Schema, ValueSchema, PrimitiveSchema } from "../schema";
import { Languages } from "../languages";
import { Extensions } from "../extensions";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

/** returns true if the given schema is a NumberSchema */
export function isNumberSchema(schema: Schema): schema is NumberSchema {
  return schema.type === SchemaType.Number || schema.type === SchemaType.Integer;
}

/** a Schema that represents a Number value */
export interface NumberSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.Number | SchemaType.Integer;

  /** precision (# of bits?) of the number */
  precision: number;

  /** if present, the number must be an exact multiple of this value */
  multipleOf?: number;

  /** if present, the value must be lower than or equal to this (unless exclusiveMaximum is true)  */
  maximum?: number;

  /** if present, the value must be lower than maximum   */
  exclusiveMaximum?: boolean;

  /** if present, the value must be highter than or equal to this (unless exclusiveMinimum is true)  */
  minimum?: number;

  /** if present, the value must be higher than minimum   */
  exclusiveMinimum?: boolean;
}

export class NumberSchema extends PrimitiveSchema implements NumberSchema {
  constructor(
    name: string,
    description: string,
    type: SchemaType.Number | SchemaType.Integer,
    precision: number,
    objectInitializer?: DeepPartial<NumberSchema>,
  ) {
    super(name, description, type);
    this.apply({ precision }, objectInitializer);
  }
}
