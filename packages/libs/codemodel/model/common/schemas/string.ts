import { PrimitiveSchema, Schema } from "../schema";
import { SchemaType } from "../schema-type";
import { DeepPartial } from "@azure-tools/codegen";

/** a Schema that represents a string value */
export interface StringSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.String;

  /** the maximum length of the string */
  maxLength?: number;

  /** the minimum length of the string */
  minLength?: number;

  /** a regular expression that the string must be validated against */
  pattern?: string; // regex
}

export class StringSchema extends PrimitiveSchema implements StringSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<StringSchema>) {
    super(name, description, SchemaType.String);
    this.apply(objectInitializer);
  }
}

/** a schema that represents a ODataQuery value */
export interface ODataQuerySchema extends Schema {
  /** the schema type  */
  type: SchemaType.ODataQuery;
}

export class ODataQuerySchema extends Schema implements ODataQuerySchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<ODataQuerySchema>) {
    super(name, description, SchemaType.ODataQuery);
    this.apply(objectInitializer);
  }
}

/** a schema that represents a Credential value */
export interface CredentialSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.Credential;

  /** the maximum length of the string */
  maxLength?: number;

  /** the minimum length of the string */
  minLength?: number;

  /** a regular expression that the string must be validated against */
  pattern?: string; // regex
}

export class CredentialSchema extends PrimitiveSchema implements CredentialSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<CredentialSchema>) {
    super(name, description, SchemaType.Credential);
    this.apply(objectInitializer);
  }
}

/** a schema that represents a Uri value */
export interface UriSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.Uri;

  /** the maximum length of the string */
  maxLength?: number;

  /** the minimum length of the string */
  minLength?: number;

  /** a regular expression that the string must be validated against */
  pattern?: string; // regex
}

export class UriSchema extends PrimitiveSchema implements UriSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<UriSchema>) {
    super(name, description, SchemaType.Uri);
    this.apply(objectInitializer);
  }
}
/** a schema that represents a Uuid value */
export interface UuidSchema extends PrimitiveSchema {
  /** the schema type  */
  type: SchemaType.Uuid;
}

export class UuidSchema extends PrimitiveSchema implements UuidSchema {
  constructor(name: string, description: string, objectInitializer?: DeepPartial<UuidSchema>) {
    super(name, description, SchemaType.Uuid);
    this.apply(objectInitializer);
  }
}
