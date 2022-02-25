# Body payload and operation overloads

## Principles

1. Operation produces in m4 are grouped by body types not by content-types
2. If multiple content-types have the same body type it is given as an option
3. Idea is that each of the request given is a compatible overload if using positional arguments

Those principle are the basic on how it should generate different requests under an operation. It is much more meaningful for OpenAPI3 where contentType => body type
In swagger as it is multiple content types mapping to a single body types there is a few special cases.
With that in mind those are the additional rules for Swagger 2.0:

1. If the body is defined as binary(`type: string, format: binary`, `type: string, format: file`, ) then there will be a single request that takes in binary data and what content type the data is regardless of the content types. (See [Scenario 1](#1-binary-body))
2. If the body is of other types:
   1. `text/plain` always assume the body is `string` See [Scenario 3][s3], [Scenario 4][s4] and [Scenario 5][s5]
   2. `application/json` produces an request taking in the schema defined for the body [Scenario 2][s2], [Scenario 3][s3] and [Scenario 4][s4]
   3. Other content types assume the body is `binary` [Scenario 3][s3], [Scenario 4][s4]

## Scenarios for Swagger 2.0

As explained in the principles above Swagger 2.0 intrepretation is a little more complex. Here are a few scenarios and how they are treated.

### 1. Binary body

Swagger:

```yaml
consumes:
  - "application/json"
  - "application/octet-stream"
  - "image/png"
  - "text/plain"
parameters:
  - in: body
    name: body
    schema:
      type: string
      format: binary
```

Modelerfour:

```yaml
- schema: binary
  contentTypes:
    - "application/json"
    - "application/octet-stream"
    - "image/png"
    - "text/plain"
```

Generated operations:

```ts
function myOp(body: Stream, contentType: "application/json" | "application/octet-stream" | "image/png" | "text/plain");
```

### 2. Basic `application/json` object in body

Swagger:

```yaml
consumes:
  - "application/json"
parameters:
  - in: body
    name: body
    schema:
      type: object
      properties: { $ref: MySchema }
```

Modelerfour:

```yaml
schema: MySchema
contentTypes:
  - "application/json"
```

Generated operations:

```ts
function myOp(body: MySchema); // Sent as application/json
```

### 3. Body is json object with mutltiple non-json content-types

Swagger:

```yaml
consumes:
  - "application/json"
  - "application/octet-stream"
  - "image/png"
  - "text/plain"

parameters:
  - in: body
    name: body
    schema:
      type: object
      properties: { $ref: MySchema }
```

Equivalent OpenAPI3:

```yaml
requestBody:
  application/json:
    type: object
    properties: { $ref: MySchema }

  application/octet-stream:
    type: object
    properties:
      type: string
      format: binary
  image/png:
    type: object
    properties:
      type: string
      format: binary
  text/plain:
    type: object
    properties:
      type: string
```

Modelerfour:

```yaml
requests:
  - schema: MySchema
    contentTypes:
      - "application/json"

  - schema: binary
    contentTypes:
      - "application/octet-stream"
      - "image/png"

  - schema: string
    contentTypes:
      - "text/plain"
```

Generated operations:

```ts
function myOp(body: MySchema); // Sent as application/json
function myOp(body: stream, contentType: "application/octet-stream" | "image/png" | string);
function myOp(body: string); // Sent as text/plain
```

### 4. Body is string(not binary) with many content-types

Swagger:

```yaml
consumes:
  - "application/json"
  - "application/octet-stream"
  - "image/png"
  - "text/plain"

parameters:
  - in: body
    name: body
    schema:
      type: string
```

Modelerfour:

```yaml
- schema: string
  contentTypes:
    - "application/json"
    - "text/plain"

- schema: binary
  contentTypes:
    - "application/octet-stream"
    - "image/png"
```

Generated operations:

```ts
function myOp(body: string, contentType: "application/json" | "text/plain" | string);
function myOp(body: stream, contentType: "application/octet-stream" | "image/png" | string);
```

### 5. Body is string with `text/plain` content type

```yaml
consumes:
  - "text/plain"

parameter:
  body:
    type: string
```

Modelerfour:

```yaml
- schema: string
  contentTypes:
    - "text/plain"
```

Generated operations:

```ts
function myOp(body: string); // Sent as text/plain
```

### 6. Basic multipart

```yaml
consumes:
  - "multipart/form-data"

parameter:
  - in: formData
    type: string
    format: binary
    name: file

  - in: formData
    name: filename
    type: string
```

```yaml
requests:
  - parameters:
      - schema: binary
        name: file

      - schema: string
        name: filename
    contentTypes:
      - "multipart/form-data"
```

Generated operations:

```ts
function myOp(file: Stream, filename: string); // Sent as multipart/form-data
```

### 7. Multipart & `application/octet-stream` single file param

```yaml
consumes:
  - "multipart/form-data"
  - "text/plain"
  - "application/octet-stream"

parameter:
  - in: formData
    type: string
    format: binary
    name: file
```

```yaml
requests:
  - parameters:
      - schema: binary
        name: file
    contentTypes:
      - "multipart/form-data"
      - "application/octet-stream"

  - parameters:
      - schema: string
        name: body
    contentTypes:
      - "text/plain"
```

Generated operations:

```ts
function myOp(file: Stream, contentType: "multipart/form-data" | "application/octet-stream" | string);
function myOp(file: string); // sent as text/plain
```

### 8. Multipart & `application/octet-stream` multi file param

**NOT SUPPORTED**

<!--LINKS-->

[s1]: #1-binary-body
[s2]: #2-basic-applicationjson-object-in-body
[s3]: #3-body-is-json-object-with-mutltiple-non-json-content-types
[s4]: #4-body-is-stringnot-binary-with-many-content-types
[s5]: #5-body-is-string-with-textplain-content-type
[s6]: #6-basic-multipart
[s7]: #7-multipart--applicationoctet-stream-single-file-param
[s8]: #8-multipart--applicationoctet-stream-multi-file-param
