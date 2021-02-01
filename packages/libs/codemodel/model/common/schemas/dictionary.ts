import { SchemaType } from "../schema-type";
import { Schema, ComplexSchema } from "../schema";
import { DeepPartial } from "@azure-tools/codegen";

/** a schema that represents a key-value collection */
export interface DictionarySchema<ElementType extends Schema = Schema> extends ComplexSchema {
  /** the schema type  */
  type: SchemaType.Dictionary;

  /** the element type of the dictionary. (Keys are always strings) */
  elementType: ElementType;

  /** if elements in the dictionary should be nullable */
  nullableItems?: boolean;
}

export class DictionarySchema<ElementType extends Schema = Schema>
  extends Schema
  implements DictionarySchema<ElementType> {
  constructor(
    name: string,
    description: string,
    elementType: ElementType,
    objectInitializer?: DeepPartial<DictionarySchema<ElementType>>,
  ) {
    super(name, description, SchemaType.Dictionary);
    this.elementType = elementType;

    this.apply(objectInitializer);
  }
}
