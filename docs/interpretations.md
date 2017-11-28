# Interpretations

AutoRest (as much as possible) adheres to a number of specifications, e.g. the OpenAPI specification or communication protocols.
However, those specifications often leave room for interpretation, in which case we try to decide in terms of what customers want or expect.
The purpose of this document is to record those decisions.

## application/json

[The RFC](https://tools.ietf.org/html/rfc4627) seems to not require handling of primitive values or null values, it merely says that parsers have to parse "JSON text", which is either an object or array. Beyond that, parsers may apparently do as they please.
For AutoRest, we extend the (de)serialization responsibilities as follows:
- *any* [JSON value](https://www.json.org/) must be supported, behaving just like `JSON.stringify`/`JSON.parse` in JavaScript
- an empty request/response payload is an alternative valid way to serialize `null`

Reference implementation:
``` TypeScript
const serialize = (obj: any): string => JSON.stringify(obj);                     // alternative 1
const serialize = (obj: any): string => obj === null ? "" : JSON.stringify(obj); // alternative 2
const deserialize = (str: string): any => str === "" ? null : JSON.parse(str);
```