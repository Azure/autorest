import { SchemaType } from "../schema-type";
import { PrimitiveSchema, ValueSchema, Schema } from "../schema";
import { Languages } from "../languages";
import { Extensions } from "../extensions";
import { StringSchema } from "./string";
import { Initializer, DeepPartial } from "@azure-tools/codegen";
import { Value } from "../value";

/** a schema that represents a value dependent on another */
export interface ConditionalSchema<ConditionalType extends PrimitiveSchema = StringSchema> extends ValueSchema {
  /** the schema type  */
  type: SchemaType.Conditional;

  /** the primitive type for the conditional */
  conditionalType: ConditionalType;

  /** the possible conditinal values */
  conditions: Array<ConditionalValue>;

  /** the source value that drives the target value (property or parameter) */
  sourceValue: Value;
}

/** an individual value in a ConditionalSchema */
export interface ConditionalValue extends Extensions {
  /** per-language information for this value */
  language: Languages;

  /** the actual value  */
  target: string | number | boolean;

  /** the actual value  */
  source: string | number | boolean;
}

export class ConditionalValue extends Initializer {
  constructor(
    name: string,
    description: string,
    source: string | number | boolean,
    target: string | number | boolean,
    objectInitializer?: DeepPartial<ConditionalValue>,
  ) {
    super();

    this.target = target;
    this.source = source;

    this.language = {
      default: {
        name,
        description,
      },
    };
    this.apply(objectInitializer);
  }
}

export class ConditionalSchema<ConditionalType extends PrimitiveSchema = StringSchema>
  extends Schema
  implements ConditionalSchema<ConditionalType> {
  constructor(
    name: string,
    description: string,
    sourceValue: Value,
    objectInitializer?: DeepPartial<ConditionalSchema<ConditionalType>>,
  ) {
    super(name, description, SchemaType.Conditional);
    this.sourceValue = sourceValue;
    this.apply(objectInitializer);
  }
}

/** a schema that represents a value dependent on another (not overridable) */
export interface SealedConditionalSchema<ConditionalType extends PrimitiveSchema = StringSchema> extends ValueSchema {
  /** the schema type  */
  type: SchemaType.SealedConditional;

  /** the primitive type for the condition */
  conditionalType: ConditionalType;

  /** the possible conditional values  */
  conditions: Array<ConditionalValue>;

  /** the source value that drives the target value */
  sourceValue: Value;
}

export class SealedConditionalSchema<ConditionalType extends PrimitiveSchema = StringSchema>
  extends Schema
  implements SealedConditionalSchema<ConditionalType> {
  constructor(
    name: string,
    description: string,
    sourceValue: Value,
    objectInitializer?: DeepPartial<ConditionalSchema<ConditionalType>>,
  ) {
    super(name, description, SchemaType.SealedConditional);
    this.sourceValue = sourceValue;
    this.apply(objectInitializer);
  }
}
