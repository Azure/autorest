# OperationIdNounInVerb
## Breaking change?
__True__. Operation ids become method names, so changing them is a breaking change.
## Description
Operation ids can be used to define operation groups by using a single underscore to separate a noun and a verb (e.g. _Users\_Get_). In the generated code, the _Noun_ becomes a property on the service client that groups _Verbs_. This provides a better interface by putting similar operations together and avoiding long lists of methods on the client.

The _Noun_ should not appear in the verb part of the operation id. Consumers of the generated code will already use the _Noun_ in their code, and having to repeat it in the method name is redundant.
## How to fix
Remove the _Noun_ from the part after the underscore
## Effect on generated code
### Before
#### Spec
```json5
…
"post": {
    "operationId": "Foo_ListFoos"
}
…
```
#### Generated code consumer
```csharp
…
var user = client.Foo.ListFoos();
…
```
### After
#### Spec
```json5
…
"post": {
    "operationId": "Foo_List"
}
…
```
#### Generated code consumer
```csharp
…
var user = client.Foo.List();
…
```