# OpenAPI Polymorphism in autorest.

[OpenAPI Docs](https://swagger.io/docs/specification/data-models/inheritance-and-polymorphism/)

Autorest only support defining polymorphic types using `allOf`(`oneOf` is not supported)

### Basic example

Basic example with `type` being the discriminator. By default the discriminator value will be the schema name(`Cat` and `Dog` here).

**OpenAPI 3**

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

**Swagger 2**

```yaml
definitions:
  Pet:
    type: object
    discriminator: type

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

### Custom discriminator values

If the discriminator values are not the object names you can change it using

- the `discriminator.mapping` property in OpenAPI 3
- the `x-ms-discriminator-value` extension property in Swagger 2.0

Here changing to `catType` and `dogType`

**OpenAPI 3**

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

**Swagger 2**

```yaml
components:
  schemas:
    Pet:
      type: object
      discriminator: type

    Cat:
      x-ms-discriminator-value: catType
      type: object
      allOf:
        - $ref: "#/components/schemas/Pet"
        - properties:
            moew:
              type: boolean

    Dog:
      x-ms-discriminator-value: dogType
      type: object
      allOf:
        - $ref: "#/components/schemas/Pet"
        - properties:
            bark:
              type: boolean
```
