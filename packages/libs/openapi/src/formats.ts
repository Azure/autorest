export enum StringFormat {
  /** @description Standard string format  */
  None = "",

  /** @description A single character  */
  Char = "char",

  /** @description A base64 string of characters.  Represents a byte array  */
  Byte = "byte",

  /**
   * @description Any sequence of octets. (ie, a sequence of unencoded bytes)
   * This may not be used for a parameter or property, as it represents a sequence of bytes,
   * it may only be used as for a request or response body, and must be used with an appropriate content-type
   */
  Binary = "binary",

  /** @description A date as defined by full-date - RFC3339 */
  Date = "date",

  /** @description A time as defined by ISO 8661 */
  Time = "time",

  /** @description A Date-Time as defined by date-time - RFC3339  */
  DateTime = "date-time",

  /** @description A hint to UIs to obscure input. */
  Password = "password",

  /** @description a A Date-Time as defined by date-time - RFC1123 */
  DateTimeRfc1123 = "date-time-rfc1123",

  /** @description a duration of time (todo: RFC reference? ) */
  Duration = "duration",

  /** @description a Universally Unique Identifier ( ISO/IEC 11578:1996) */
  Uuid = "uuid",

  /** @description a base64url string of characters, represented as a byte array (see RFC 4648 ) */
  Base64Url = "base64url",

  /** @description a string that should be an URL */
  Url = "url",

  /** @description an encoded odata query string */
  OData = "odata-query",

  Certificate = "certificate",
}

export enum IntegerFormat {
  /** @description an integer value (a javascript representation of maximum safe value is (2^53 - 1). ) */
  None = "",

  /** @description an explicity declared 32 bit integer */
  Int32 = "int32",

  /** @description an explicity declared 64 bit integer */
  Int64 = "int64",

  /** @description a UnixTime (number of seconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970) */
  UnixTime = "unixtime",
}

export enum NumberFormat {
  /** @description - any number */
  None = "",
  /** @description - a 32 bit-precision floating point value */
  Float = "float",

  /** @description - a 64 bit-precision floating point value */
  Double = "double",

  /** @description - a 128 bit-precision floating point value */
  Decimal = "decimal",
}
