## Formats supported by Autorest

Format provided via the `format:` property of schema(`string`, `number` or `integer`)

### `string` formats

Those formats can be used to specify a more accurate type of data that is sent as `string` over the wire.

- `char`: A single character
- `binary`:
  Any sequence of octets. (ie, a sequence of unencoded bytes)

  - This may not be used for a parameter or property, as it represents a sequence of bytes,
  - it may only be used as for a request or response body, and must be used with an appropriate content-type

- `byte`: A base64 string of characters. Represents a byte array
- `certificate`: A certificate treated as an array of bytes.
- `date`: A date as defined by full-date - RFC3339
- `time`: A time as defined by ISO 8661
- `date-time`: A Date-Time as defined by date-time - RFC3339
- `date-time-rfc1123`: A Date-Time as defined by date-time - RFC1123
- `date-time-rfc7231`: A Date-Time as defined by date-time - RFC7231
- `duration`: A duration of time
- `password`: A hint to UIs to obscure input.
- `uuid`: Universally Unique Identifier
- `base64url`: a base64url string of characters, represented as a byte array (see RFC 4648 )
- `uri`/`url`: Represent a URL/URI

Azure specific:

- `arm-id`: Represent a Azure Resource Manager Resource ID.

### `integer` formats

- `int32`: A 32 bit integer
- `int64`: A 64 bit integer
- `unixtime`: a UnixTime (number of seconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970)

### `number` formats

- `float`: A 32 bit float
- `double`: A 64 bit float
- `decimal`: A 128 bit float
