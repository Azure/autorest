import { ChoiceSchema, SealedChoiceSchema } from "./schemas/choice";
import { camelCase } from "@azure-tools/codegen";
import { SchemaType } from "./schema-type";
import { ArraySchema, ByteArraySchema } from "./schemas/array";
import { DictionarySchema } from "./schemas/dictionary";
import { BooleanSchema, CharSchema } from "./schemas/primitive";
import { NumberSchema } from "./schemas/number";
import { ObjectSchema, GroupSchema } from "./schemas/object";
import { StringSchema, UuidSchema, UriSchema, CredentialSchema, ODataQuerySchema } from "./schemas/string";
import { UnixTimeSchema, DateSchema, DateTimeSchema, DurationSchema, TimeSchema } from "./schemas/time";
import { Schema, PrimitiveSchema } from "./schema";
import { ConditionalSchema, SealedConditionalSchema } from "./schemas/conditional";
import { FlagSchema } from "./schemas/flag";
import { ConstantSchema } from "./schemas/constant";
import { OrSchema, XorSchema } from "./schemas/relationship";
import { BinarySchema } from "./schemas/binary";
import { finished } from "stream";
import { AnyObjectSchema, AnySchema } from "./schemas/any";

export { SchemaUsage, SchemaContext } from "./schemas/usage";

/** the full set of schemas for a given service, categorized into convenient collections */
export interface Schemas {
  /** a collection of items */
  arrays?: Array<ArraySchema>;

  /** an associative array (ie, dictionary, hashtable, etc) */
  dictionaries?: Array<DictionarySchema>;

  /** a true or false value */
  booleans?: Array<BooleanSchema>;

  /** a number value */
  numbers?: Array<NumberSchema>;

  /** an object of some type */
  objects?: Array<ObjectSchema>;

  /** a string of characters  */
  strings?: Array<StringSchema>;

  /** UnixTime */
  unixtimes?: Array<UnixTimeSchema>;

  /** ByteArray -- an array of bytes */
  byteArrays?: Array<ByteArraySchema>;

  /* a binary stream */
  streams?: Array<Schema>;

  /** a single character */
  chars?: Array<CharSchema>;

  /** a Date */
  dates?: Array<DateSchema>;

  /** a time */
  times?: Array<TimeSchema>;

  /** a DateTime */
  dateTimes?: Array<DateTimeSchema>;

  /** a Duration */
  durations?: Array<DurationSchema>;

  /** a universally unique identifier  */
  uuids?: Array<UuidSchema>;

  /** an URI of some kind */
  uris?: Array<UriSchema>;

  /** a password or credential  */
  credentials?: Array<CredentialSchema>;

  /** OData Query */
  odataQueries?: Array<ODataQuerySchema>;

  /** a choice between one of several  values (ie, 'enum')
   *
   * @description - this is essentially can be thought of as an 'enum'
   * that is a choice between one of several items, but an unspecified value is permitted.
   */
  choices?: Array<ChoiceSchema>;

  /** a choice between one of several  values (ie, 'enum')
   *
   * @description - this is essentially can be thought of as an 'enum'
   * that is a choice between one of several items, but an unknown value is not allowed.
   */
  sealedChoices?: Array<SealedChoiceSchema>;

  /**
   * a schema that infers a value when a given parameter holds a given value
   *
   * @description ie, when 'profile' is 'production', use '2018-01-01' for apiversion
   */
  conditionals?: Array<ConditionalSchema>;

  sealedConditionals?: Array<SealedConditionalSchema>;

  flags?: Array<FlagSchema>;

  /** a constant value */
  constants?: Array<ConstantSchema>;

  ors?: Array<OrSchema>;

  xors?: Array<XorSchema>;

  binaries?: Array<BinarySchema>;

  /** the type is not known.
   *
   * @description it's possible that we just may make this an error
   * in representation.
   */
  unknowns?: Array<Schema>;

  groups?: Array<GroupSchema>;

  any?: Array<AnySchema>;

  anyObjects?: AnyObjectSchema[];
}

export class Schemas {
  add<T extends Schema>(schema: T): T {
    if (schema instanceof AnySchema) {
      if (!this.any?.[0]) {
        this.any = [schema];
      }
      return this.any[0] as T;
    }

    if (schema instanceof AnyObjectSchema) {
      if (!this.anyObjects?.[0]) {
        this.anyObjects = [schema];
      }
      return this.anyObjects[0] as T;
    }

    let group = `${camelCase(schema.type)}s`.replace(/rys$/g, "ries");
    if (group === "integers") {
      group = "numbers";
    }

    const a: Array<Schema> = (<any>this)[group] || ((<any>this)[group] = new Array<Schema>());

    // for simple types, go a quick check to see if an exact copy of this is in the collection already
    // since we can just return that. (the consumer needs to pay attention tho')
    if (
      schema instanceof ConstantSchema ||
      schema instanceof PrimitiveSchema ||
      schema instanceof AnySchema ||
      schema instanceof ArraySchema ||
      schema instanceof ByteArraySchema ||
      schema instanceof DictionarySchema ||
      schema instanceof ChoiceSchema ||
      schema instanceof SealedChoiceSchema
    ) {
      try {
        const s = JSON.stringify(schema);
        const found = a.find((each) => JSON.stringify(each) === s);
        if (found) {
          return <T>found;
        }
      } catch {
        // not the same!
      }
    }

    if (a.indexOf(schema) > -1) {
      throw new Error(`Duplicate ! ${schema.type} : ${schema.language.default.name}`);
      // return schema;
    } else {
      //console.error(`Adding ${schema.type} : ${schema.language.default.name}`);
    }
    a.push(schema);
    return schema;
  }
}
