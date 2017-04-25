#M3016 - DefinitionsPropertiesNamesCamelCase/BodyPropertiesNamesCamelCase
## Description
This violation is flagged if a model definition's property name (DefinitionsPropertiesNamesCamelCase) or a request body parameter's property name (BodyPropertiesNamesCamelCase)  is not in `camelCase` format. This is because the model's properties are sent across the wire and must adhere to common Json conventions for naming. This implies that every property name must start with a lower cased letter and all subsequent words within the name must start with a capital letter. In cases where there are abbreviations involved, a maximum of three contiguous capital letters are allowed. Eg: `redisCache`, `publicIPAddress`, `location` are valid, but `sampleSQLQuery` is not (must be renamed as `sampleSqlQuery`).

## How to fix
Convert the property name string into `camelCase` format as suggested in the description


## Effect on generated code
### Before
#### Spec
```json5
…
"ModelDefinition":{
    "properties":{
        "ModelProperty1":{
            "type":"string"
        }
    }
}
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