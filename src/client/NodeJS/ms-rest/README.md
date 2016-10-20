# MS-Rest

Infrastructure for serialization/deserialization, error handling, tracing, and http client pipeline configuration. Required by nodeJS client libraries generated using AutoRest.

- **Node.js version: 4.x.x or higher**


## How to Install

```bash
npm install ms-rest
```

## Usage
```javascript
var msrest = require('ms-rest');
```
## Serialization/Deserialization
Features
- Type checking
  - (String, Number, Boolean, ByteArray, Base64Url, Date, DateTime, Enum, TimeSpan, DateTimeRfc1123, UnixTime, Object, Stream, Sequence, Dictionary, Composite, Uuid(as a string))
- Validation of specified constraints
  - ExclusiveMaximum, ExclusiveMinimum, InclusiveMaximum, InclusiveMinimum, MaxItems, MaxLength, MinItems, MinLength, MultipleOf, Pattern, UniqueItems
- Flattening/Unflattening properties
- Default Values
- Model Properties marked as constant are set during serialization, irrespective of they being provided or not
- Required check (If a model or property is marked required and is not provided in the object then an error is thrown)
- Readonly check (If a model or property is marked readonly then it is not sent on the wire during, serialization)
- Serializing Constant values

- serialize an array of dictionary of primitive values
```javascript
var mapper = {
  type : {
    name: 'Sequence', 
    element: {
      type : {
        name: 'Dictionary',
        value: {
          type: {
            name: 'Boolean'
          }
        }
      }
    }
  }
};
var array = [{ 1: true }, { 2: false }, { 1: true, 2: false, 3: true }];
var serializedArray = msRest.serialize(mapper, array, 'arrayObj');
assert.deepEqual(array, serializedArray);
var serializedProduct = msrest.serialize(mapper, productObj, 'productObject');
var deserializedArray = msRest.deserialize(mapper, serializedArray, 'serializedArrayObj');
```
For more examples on serialization/deserialization with complex types please take a look over [here](https://github.com/Azure/autorest/blob/master/ClientRuntimes/NodeJS/ms-rest/test/serializationTests.js#L116).

## Related Projects

- [AutoRest](https://github.com/Azure/AutoRest)