# $ref siblings.

As described in the [OpenAPI documentation](https://swagger.io/docs/specification/using-ref/) properties next to a `$ref` should be ignored.

However there is not really any way around this for certain things specially around describing properties of a definition vs the definition itself.
That's why `autorest` does support a set of properties next to a `$ref`. Using different ones will log a warning and will have them be ignored.

## Autorest supported properties

### `description`

Can be used to provide a description on a schema/definition property.

```yaml
schemas:
  Foo:
    myProp:
      $ref: "#/components/schemas/Bar"
      description: "This is a description for myProp"
```

### `title`

Can be used to provide a title on a schema/definition property.

```yaml
schemas:
  Foo:
    myProp:
      $ref: "#/components/schemas/Bar"
      title: "This is a title for myProp"
```

### `readonly`

Can be used to mark a property as readonly.

```yaml
schemas:
  Foo:
    myProp:
      $ref: "#/components/schemas/Bar"
      readonly: true
```

### `nullable`

Can be used to mark a property as nullable.

```yaml
schemas:
  Foo:
    myProp:
      $ref: "#/components/schemas/Bar"
      nullable: true
```

### `x-ms-client-name`

Can be used to change the property name in the resulting SDK

```yaml
schemas:
  Foo:
    myProp:
      $ref: "#/components/schemas/Bar"
      x-ms-client-name: myMoreMeaningfulProp
```

### `x-*`

Any custom extension will also be allowed and pass through to the SDK codemodel.

```yaml
schemas:
  Foo:
    myProp:
      $ref: "#/components/schemas/Bar"
      x-my-custom-value: "something"
```
