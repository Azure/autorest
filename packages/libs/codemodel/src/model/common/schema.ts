import { Aspect } from "./aspect";
import { SerializationFormats } from "./formats";
import { AllSchemaTypes, SchemaType } from "./schema-type";
import { DeepPartial } from "@azure-tools/codegen";
import { Dictionary } from "@azure-tools/linq";
import { Extensions } from "./extensions";
import { Languages } from "./languages";

export interface SerializationFormat extends Extensions, Dictionary<any> {}

/** The Schema Object allows the definition of input and output data types. */
export interface Schema extends Aspect {
  /** per-language information for Schema */
  language: Languages;

  /** the schema type  */
  type: AllSchemaTypes;

  /* short description */
  summary?: string;

  /** example information  */
  example?: any;

  /** If the value isn't sent on the wire, the service will assume this */
  defaultValue?: any;

  /** per-serialization information for this Schema  */
  serialization?: SerializationFormats;

  /* are these needed I don't think so? */
  // nullable: boolean;
  // readOnly: boolean;
  // writeOnly: boolean;
}

export class Schema extends Aspect implements Schema {
  type: AllSchemaTypes;

  constructor(schemaName: string, description: string, type: AllSchemaTypes, initializer?: DeepPartial<Schema>) {
    super(schemaName, description);
    this.type = type;

    this.apply(
      {
        language: {
          default: {},
        },
        protocol: {},
      },
      initializer,
    );
  }
}

/** schema types that are non-object or complex types */
export interface ValueSchema extends Schema {}

/** Schema types that are primitive language values */
export interface PrimitiveSchema extends ValueSchema {}

export class PrimitiveSchema extends Schema implements PrimitiveSchema {
  constructor(
    name: string,
    description: string,
    schemaType: AllSchemaTypes,
    objectInitializer?: DeepPartial<PrimitiveSchema>,
  ) {
    super(name.indexOf("·") > -1 ? schemaType : name, description, schemaType);

    this.apply(objectInitializer);
  }
}

/** schema types that can be objects */
export interface ComplexSchema extends Schema {}
