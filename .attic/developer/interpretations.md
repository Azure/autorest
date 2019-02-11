# Interpretations

AutoRest (as much as possible) adheres to a number of specifications, e.g. the OpenAPI specification or communication protocols.
However, those specifications often leave room for interpretation, in which case we try to decide in terms of what customers want or expect.
The purpose of this document is to record those decisions.

## application/json

[RFC 4627](https://tools.ietf.org/html/rfc4627) and [RFC 7159](https://tools.ietf.org/html/rfc7159) allow parsers to actually parse more than just JSON values:

> "A JSON parser MAY accept non-JSON forms or extensions."

We encountered situations in which servers send empty bodies that are meant to be interpreted as `null`, so AutoRest generated clients must deserialize such bodies as `null`.

### Summary
- any [JSON value](https://www.json.org/) must be supported (behaving just like `JSON.stringify`/`JSON.parse` in JavaScript)
- an empty request/response payload must deserialize to `null`

### Reference Implementation
``` TypeScript
const serialize = (obj: any): string => JSON.stringify(obj);
const deserialize = (str: string): any => str === "" ? null : JSON.parse(str);
```
