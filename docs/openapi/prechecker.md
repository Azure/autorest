# Prechecker

Prechecker is a step that runs before the modeler that will validate and fix up the OpenAPI spec. 

## Rules

### Schema without type

Prechecker will look for schema that should be defined as `type: "object"` but are missing the `type` property. It will automatically inject the `type: "object"` field.

Note: This is a warning and was added for backward compatiblity. It is not recommended to omit the `type: "object"`

### Schema with empty parent

Prechecker will look for schemas that use `allOf` referencing an empty schema. In that case it will remove the reference.

### Duplicate schema

Prechecker will compare all the schemas and check for duplicates. 
- If the 2 duplicates are exacty the same they will be merged together.
- If the 2 schemas have the same name but are different it will then raise an error.

### Properties

Prechecker will check redefinition of properties in child schemas. If a child schema redefine a property already defined in a parent schema(Using `allOf`).
It will:
- If the property is the same, just remove the redefinition and log a warning.
- If the property only difference is changing the `readOnly` property it will remove the redefinition and log a warning(Ignoring the change to `readOnly`).
- If the property is different it will raise an error.

### Duplicate parents

Prechecker will check that there isn't duplication in the parent(`allOf`) tree. It will raise an error if there is.
