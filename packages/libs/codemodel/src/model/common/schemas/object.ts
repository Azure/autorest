import { SchemaType } from "../schema-type";
import { Schema, ComplexSchema } from "../schema";
import { DeepPartial } from "@azure-tools/codegen";
import { Property } from "../property";
import { Dictionary, values } from "@azure-tools/linq";
import { Parameter } from "../parameter";
import { SchemaUsage } from "./usage";

export interface Relations {
  immediate: Array<ComplexSchema>;
  all: Array<ComplexSchema>;
}
export class Relations {
  constructor() {
    this.immediate = [];
    this.all = [];
  }
}

export interface Discriminator {
  property: Property;
  immediate: Dictionary<ComplexSchema>;
  all: Dictionary<ComplexSchema>;
}

export class Discriminator implements Discriminator {
  constructor(public property: Property) {
    this.immediate = {};
    this.all = {};
  }
}

export interface GroupProperty extends Property {
  originalParameter: Array<Parameter>;
}

export class GroupProperty extends Property implements GroupProperty {
  originalParameter = new Array<Parameter>();
  constructor(name: string, description: string, schema: Schema, initializer?: DeepPartial<GroupProperty>) {
    super(name, description, schema);

    this.applyWithExclusions(["schema"], initializer);
  }
}

export interface GroupSchema extends Schema, SchemaUsage {
  type: SchemaType.Group;
  properties?: Array<GroupProperty>;
}
export class GroupSchema extends Schema implements GroupSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<GroupSchema>) {
    super(name, description, SchemaType.Group);
    this.apply(objectInitializer);
  }

  add(property: GroupProperty) {
    (this.properties = this.properties || []).push(property);
    return property;
  }
}

/** a schema that represents a type with child properties. */
export interface ObjectSchema extends ComplexSchema, SchemaUsage {
  /** the schema type  */
  type: SchemaType.Object;

  /** the property of the polymorphic descriminator for this type, if there is one */
  discriminator?: Discriminator;

  /** the collection of properties that are in this object */
  properties?: Array<Property>;

  /**  maximum number of properties permitted */
  maxProperties?: number;

  /**  minimum number of properties permitted */
  minProperties?: number;

  parents?: Relations;

  children?: Relations;

  discriminatorValue?: string;
}

export class ObjectSchema extends Schema implements ObjectSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<ObjectSchema>) {
    super(name, description, SchemaType.Object);
    this.apply(objectInitializer);
  }

  addProperty(property: Property) {
    (this.properties = this.properties || []).push(property);
    return property;
  }
}

export function isObjectSchema(schema: Schema): schema is ObjectSchema {
  return schema.type === SchemaType.Object;
}

// gs01: todo/Note -- these two need to be commented out to run the schema generation script
export function* getAllProperties(schema: ObjectSchema): Iterable<Property> {
  for (const parent of values(schema.parents?.immediate)) {
    if (isObjectSchema(parent)) {
      yield* getAllProperties(parent);
    }
  }
  yield* values(schema.properties);
}
export function* getAllParentProperties(schema: ObjectSchema): Iterable<Property> {
  for (const parent of values(schema.parents?.immediate)) {
    if (isObjectSchema(parent)) {
      yield* getAllProperties(parent);
    }
  }
}
