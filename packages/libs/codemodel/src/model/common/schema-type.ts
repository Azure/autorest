/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/** possible schema types that indicate the type of schema.
 *
 * @note - this is essentially a discriminator for Schema
 */
export enum SchemaType {
  /** a collection of items */
  Array = "array",

  /** an associative array (ie, dictionary, hashtable, etc) */
  Dictionary = "dictionary",

  /** a true or false value */
  Boolean = "boolean",

  /** an integer value */
  Integer = "integer",

  /** a number value */
  Number = "number",

  /** an object of some type */
  Object = "object",

  /** a string of characters  */
  String = "string",

  /** UnixTime */
  UnixTime = "unixtime",

  /** ByteArray -- an array of bytes */
  ByteArray = "byte-array",

  /* a binary stream */
  Binary = "binary",

  /** a single character */
  Char = "char",

  /** a Date */
  Date = "date",

  /** a Date */
  Time = "time",

  /** a DateTime */
  DateTime = "date-time",

  /** a Duration */
  Duration = "duration",

  /** a universally unique identifier  */
  Uuid = "uuid",

  /** an URI of some kind */
  Uri = "uri",

  /** a password or credential  */
  Credential = "credential",

  /** OData Query */
  ODataQuery = "odata-query",

  /** a type that can be anything */
  Any = "any",

  /**
   * A type that can be any object. Like Any but cannot be a primitive type or array
   */
  AnyObject = "any-object",

  /** a choice between one of several  values (ie, 'enum')
   *
   * @description - this is essentially can be thought of as an 'enum'
   * that is a choice between one of several strings
   */
  Choice = "choice",

  SealedChoice = "sealed-choice",

  Conditional = "conditional",

  SealedConditional = "sealed-conditional",

  Flag = "flag",

  /** a constant value */
  Constant = "constant",

  Or = "or",

  Xor = "xor",

  Not = "not",
  /** the type is not known.
   *
   * @description it's possible that we just may make this an error
   * in representation.
   */
  Unknown = "unknown",

  Group = "group",
}

/** Compound schemas are used to construct complex objects or offer choices of a set of schemas.
 *
 * (ie, allOf, anyOf, oneOf )
 *
 * @note - historically 'allOf' was used to manage object hierarchy.
 *
 */
export type CompoundSchemaTypes = SchemaType.Or | SchemaType.Xor;

/** Schema types that are primitive language values */
export type PrimitiveSchemaTypes =
  | SchemaType.Char
  | SchemaType.Date
  | SchemaType.Time
  | SchemaType.DateTime
  | SchemaType.Duration
  | SchemaType.Credential
  | SchemaType.UnixTime
  | SchemaType.Uri
  | SchemaType.Uuid
  | SchemaType.Boolean
  | SchemaType.Integer
  | SchemaType.Number
  | SchemaType.String;

/** schema types that are non-object or complex types */
export type ValueSchemaTypes =
  | SchemaType.ByteArray
  | PrimitiveSchemaTypes
  | SchemaType.Array
  | SchemaType.Choice
  | SchemaType.SealedChoice
  | SchemaType.Flag
  | SchemaType.Conditional
  | SchemaType.SealedConditional;

/** schema types that can be objects */
export type ObjectSchemaTypes = SchemaType.Or | SchemaType.Dictionary | SchemaType.Object;

/** all schema types */
export type AllSchemaTypes =
  | SchemaType.Any
  | SchemaType.AnyObject
  | ValueSchemaTypes
  | ObjectSchemaTypes
  | SchemaType.Constant
  | SchemaType.ODataQuery
  | SchemaType.Xor
  | SchemaType.Group
  | SchemaType.Not
  | SchemaType.Binary;
