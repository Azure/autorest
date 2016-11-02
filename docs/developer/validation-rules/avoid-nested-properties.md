# AvoidNestedProperties
## Description
This rule appears when you define a property with the name `properties`, and do not use the [`x-ms-client-flatten` extension](../../extensions/index.md#x-ms-client-flatten). Users often provide feedback that they don't want to create multiple levels of properties to be able to use an operation. By applying the `x-ms-client-flatten` extension, you move the inner `properties` to the top level of your definition.
## How to fix
Add the `x-ms-client-flatten` extension to the inner `properties` definition.
## Effect on generated code
### Before
#### Spec
```json5
…
"definitions": {
    "Foo": {
        "type": "object",
        "properties": {
            "properties": {
                "type": "object",
                "properties": {
                    "bar": {
                        "type": "string"
                    }
                }
            }
        }
    }
}
…
```
#### Generated code
```csharp
public class Foo {
    FooProperties Properties { get; set; } 
}

public class FooProperties {
    string Bar { get; set; } 
}
```
### After
#### Spec
```json5
…
"definitions": {
    "Foo": {
        "type": "object",
        "properties": {
            "properties": {
                "type": "object",
                "properties": {
                    "bar": {
                        "type": "string"
                    }
                }
            },
            "x-ms-client-flatten": true
        }
    }
}
…
```
#### Generated code
```csharp
public class Foo {
    string Bar { get; set; } 
}
```