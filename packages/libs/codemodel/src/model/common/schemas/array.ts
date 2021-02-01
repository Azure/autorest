import { Schema, ValueSchema } from "../schema";
import { SchemaType } from "../schema-type";
import { DeepPartial } from "@azure-tools/codegen";

/** a Schema that represents and array of values */
export interface ArraySchema<ElementType extends Schema = Schema> extends ValueSchema {
  /** the schema type  */
  type: SchemaType.Array;

  /** elementType of the array */
  elementType: ElementType;

  /** maximum number of elements in the array */
  maxItems?: number;

  /** minimum number of elements in the array */
  minItems?: number;

  /** if the elements in the array should be unique */
  uniqueItems?: boolean;

  /** if elements in the array should be nullable */
  nullableItems?: boolean;
}
export class ArraySchema<ElementType extends Schema = Schema> extends Schema implements ArraySchema<ElementType> {
  constructor(
    name: string,
    description: string,
    elementType: ElementType,
    objectInitializer?: DeepPartial<ArraySchema<ElementType>>,
  ) {
    super(name, description, SchemaType.Array);
    this.elementType = elementType;

    this.apply(objectInitializer);
  }
}

/** a schema that represents a ByteArray value */
export interface ByteArraySchema extends ValueSchema {
  /** the schema type  */
  type: SchemaType.ByteArray;

  /** date-time format  */
  format: "base64url" | "byte";
}

export class ByteArraySchema extends Schema implements ByteArraySchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<ByteArraySchema>) {
    super(name, description, SchemaType.ByteArray);
    this.apply(objectInitializer);
  }
}
