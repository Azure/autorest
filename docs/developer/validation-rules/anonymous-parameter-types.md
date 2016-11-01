# AnonymousParameterTypes
## Description
This rule appears when you define a model type inline, rather than in the `definitions` section. Since code generation does not have a name to call your model, the class will have a non-descriptive name. Additionally, if it represents the same type as another parameter in a different operation, then it becomes impossible to reuse that same class for both operations.
## How to fix
Move the schema to the `definitions` section and reference it using `$ref`.
## Effect on generated code
### Before
#### Spec
```json5
…
"parameters": [
    {
        "name": "foo",
        "in": "body",
        "schema": {
            "type": "object",
            "properties": {
                …
            }
        }
    }
]
…
```
#### Generated code
```csharp
public class FooParameter1 {
    …
}
```
### After
#### Spec
```json5
…
"parameters": [
    {
        "name": "foo",
        "in": "body",
        "schema": {
            "$ref": "#/definition/FooCreationSettings"
        }
    }
],
…
"definitions": {
    "FooCreationSettings": {
        "type": "object",
        "properties": {
            …
        }
    }
}
…
```
#### Generated code
```csharp
public class FooCreationSettings {
    …
}
```