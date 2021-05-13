# Autorest built-in directives

Autorest provides a set of built-in directives for common scenarios to simplify things.

Those directives are defined [here](https://github.com/Azure/autorest/blob/master/packages/libs/configuration/resources/directives.md)

## Selection

### Selecting operation

```yaml
directive:
  - where-operation: <operationId>
    transform: ... # Your transform code
```

### Selecting model

```yaml
directive:
  - where-model: <modelName>
    transform: ... # Your transform code
```

## Transforms

### Remove operation

```yaml
directive:
  - remove-operation: <operationId>
```

Examples:

```yaml
directive:
  # Remove operation with operationId: Foo_Get
  - remove-operation: Foo_Get
```

### Rename operation

```yaml
directive:
  - rename-operation:
      from: <operationId>
      to: <new-operationId>
```

Examples:

```yaml
directive:
  # Rename operation with operationId: Foo_Get to Bar_Get
  - rename-operation:
      from: Foo_Get
      to: Foo_Get
```

### Remove model

```yaml
directive:
  - remove-model: <name>
```

Examples:

```yaml
directive:
  # Remove model named MyModel
  - remove-model: MyModel
```

### Rename model

```yaml
directive:
  - rename-model:
      from: <name>
      to: <new-name>
```

Examples:

```yaml
directive:
  # Rename model named MyModel to NewModel
  - rename-operation:
      from: MyModel
      to: NewModel
```

### Remove property

Remove the property on a model, to be used with `where-model`

```yaml
directive:
  - where-model: <model-name>
    remove-property: <property-name>
```

Examples:

```yaml
directive:
  # Remove property foo on model named MyModel
  - where-model: MyModel
    remove-property: foo
```

### Rename property

Rename the property on a model(Rename the actual property name and doesn't change `x-ms-client-name`.), to be used with `where-model`

```yaml
directive:
  - where-model: <model-name>
    rename-property:
      from: <property-name>
      to: <new-property-name>
```

Examples:

```yaml
directive:
  # Rename property foo to bar on model named MyModel
  - where-model: MyModel
    remove-property:
      from: foo
      to: bar
```

### Remove parameter

Remove a parameter. To be used with `where-operation` or `where: '$.paths..'` for all operations.

```yaml
directive:
  - remove-parameter:
      in: <type> # header,query,cookie(Same options allowed in OpenAPI)
      name: <name> # Name of the parameter
```

Examples:

```yaml
directive:
  # Remove header named myHeader on operation Foo_Get
  - where-operation: Foo_Get
    remove-parameter:
      in: header
      name: myHeader

  # Remove query parmeter named page on all operations
  - where: "$.paths..*"
    remove-parameter:
      in: header
      name: page
```
