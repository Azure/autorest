# ModelTypeIncomplete
## Description
AutoRest turns JSON schemas of `type: "object"` with properties into models in the generated code (i.e. class definitions in object oriented languages). Certain properties are required for generating this model, and this rule validates that they are present.
## How to fix
Add the missing properties to the schema.
## Effect on generated code
### Before
```

```
### After
```

```
