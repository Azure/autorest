import { SchemaType } from "../schema-type";
import { Schema, ValueSchema } from "../schema";
import { Languages } from "../languages";
import { Extensions } from "../extensions";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

export interface FlagValue extends Extensions {
  /** per-language information for this value */
  language: Languages;

  value: number;
}

export class FlagValue extends Initializer implements FlagValue {
  constructor(name: string, description: string, value: number, objectInitializer?: DeepPartial<FlagValue>) {
    super();
    this.value = value;
    this.language.default = {
      name,
      description,
    };
    this.apply(objectInitializer);
  }
}

export interface FlagSchema extends ValueSchema {
  /** the possible choices for in the set */
  choices: Array<FlagValue>;
}

export class FlagSchema extends Schema implements FlagSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<FlagSchema>) {
    super(name, description, SchemaType.Flag);
    this.apply(objectInitializer);
  }
}
