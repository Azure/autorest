import { SchemaType } from "../schema-type";
import { PrimitiveSchema, ValueSchema, Schema } from "../schema";
import { Languages } from "../languages";
import { Extensions } from "../extensions";
import { StringSchema } from "./string";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

/** a schema that represents a choice of several values (ie, an 'enum') */
export interface ChoiceSchema<ChoiceType extends PrimitiveSchema = StringSchema> extends ValueSchema {
  /** the schema type  */
  type: SchemaType.Choice;
  /** the primitive type for the choices */
  choiceType: ChoiceType;
  /** the possible choices for in the set */
  choices: Array<ChoiceValue>;
}

/** an individual choice in a ChoiceSchema */
export interface ChoiceValue extends Extensions {
  /** per-language information for this value */
  language: Languages;

  /** the actual value  */
  value: string | number | boolean;
}

export class ChoiceValue extends Initializer {
  constructor(
    name: string,
    description: string,
    value: string | number | boolean,
    objectInitializer?: DeepPartial<ChoiceValue>,
  ) {
    super();
    this.value = value;
    this.language = {
      default: {
        name,
        description,
      },
    };
    this.apply(objectInitializer);
  }
}

export class ChoiceSchema<ChoiceType extends PrimitiveSchema = StringSchema>
  extends Schema
  implements ChoiceSchema<ChoiceType> {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<ChoiceSchema<ChoiceType>>) {
    super(name, description, SchemaType.Choice);
    this.apply(objectInitializer);
  }
}

/** a schema that represents a choice of several values (ie, an 'enum') */
export interface SealedChoiceSchema<ChoiceType extends PrimitiveSchema = StringSchema> extends ValueSchema {
  /** the schema type  */
  type: SchemaType.SealedChoice;

  /** the primitive type for the choices */
  choiceType: ChoiceType;

  /** the possible choices for in the set */
  choices: Array<ChoiceValue>;
}

export class SealedChoiceSchema<ChoiceType extends PrimitiveSchema = StringSchema>
  extends Schema
  implements SealedChoiceSchema<ChoiceType> {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<ChoiceSchema<ChoiceType>>) {
    super(name, description, SchemaType.SealedChoice);
    this.apply(objectInitializer);
  }
}
