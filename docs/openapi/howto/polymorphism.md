# OpenAPI Polymorphism in autorest.

[OpenAPI Docs](https://swagger.io/docs/specification/data-models/inheritance-and-polymorphism/)

Autorest only support defining polymorphic types using `allOf`(`oneOf` is not supported)

### Basic example

Basic example with `type` being the discriminator. By default the discriminator value will be the schema name(`Cat` and `Dog` here).

```yaml
components:
  schemas:
    Pet:
      type: object
      discriminator:
        propertyName: type

    Cat:
      type: object
      allOf:
        - $ref: "#/components/schemas/Pet"
        - properties:
            moew:
              type: boolean

    Dog:
      type: object
      allOf:
        - $ref: "#/components/schemas/Pet"
        - properties:
            bark:
              type: boolean
```

### Custom discriminator names

If the discriminator values are not the object names you can change it using the `discriminator.mapping` property. Here changing to `catType` and `dogType`

```yaml
components:
  schemas:
    Pet:
      type: object
      discriminator:
        propertyName: type
        mapping:
          catType: "#/components/schemas/Cat"
          dogType: "#/components/schemas/Dog"
    Cat:
      type: object
      allOf:
        - $ref: "#/components/schemas/Pet"
        - properties:
            moew:
              type: boolean

    Dog:
      type: object
      allOf:
        - $ref: "#/components/schemas/Pet"
        - properties:
            bark:
              type: boolean
```
