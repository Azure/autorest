/**
 * The Serialization Style used for the parameter.
 *
 * Describes how the parameter value will be serialized depending on the type of the parameter value.
 * @see https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md#style-examples
 *
 */
export enum SerializationStyle {
  /**
   * Path-style parameters defined by RFC6570
   *
   *
   * @type primitive, array, object
   * @in path
   */
  Matrix = "matrix",
  /**
   * Label style parameters defined by RFC6570
   *
   * @type primitive, array, object
   * @in path
   */
  Label = "label",
  /**
   * Simple style parameters defined by RFC6570. This option replaces collectionFormat with a csv value from OpenAPI 2.0.
   *
   * @default - path and header
   * @type array
   * @in path, header
   */
  Simple = "simple",
  /**
   * Form style parameters defined by RFC6570. This option replaces collectionFormat with a csv (when explode is false) or multi (when explode is true) value from OpenAPI 2.0.
   *
   * @default - query and cookie
   * @type primitive, array, object
   * @in query, cookie, body
   */
  Form = "form",
  /**
   * Space separated array values. This option replaces collectionFormat equal to ssv from OpenAPI 2.0.
   *
   * @type array
   * @in query
   */
  SpaceDelimited = "spaceDelimited",
  /**
   * Pipe separated array values. This option replaces collectionFormat equal to pipes from OpenAPI 2.0.
   *
   * @type array
   * @in query
   */
  PipeDelimited = "pipeDelimited",
  /**
   * Provides a simple way of rendering nested objects using form parameters.
   *
   * @type object
   * @in query
   */
  DeepObject = "deepObject",
  /**
   * Serialize to JSON text
   *
   * @default - body
   * @type primitive, array, object
   * @in body
   */
  Json = "json",
  /**
   * Serialize to XML text
   *
   * @type primitive, array, object
   * @in body
   */
  Xml = "xml",

  /**
   * The content is a binary (stream)
   * @type binary
   * @in body
   */
  Binary = "binary",

  /**
   * Tab delimited array
   */
  TabDelimited = "tabDelimited",
}

export type QueryEncodingStyle =
  | SerializationStyle.Form
  | SerializationStyle.SpaceDelimited
  | SerializationStyle.PipeDelimited
  | SerializationStyle.DeepObject;

export type PathEncodingStyle = SerializationStyle.Matrix | SerializationStyle.Label | SerializationStyle.Simple;
