# Cowbell Factory

## General

``` yaml
swagger: '2.0'
info:
  description: This is a sample.
  version: 1.0.0
  title: Cowbell Factory
schemes:
- https
consumes:
- application/json
produces:
- application/json
paths: {}
```

Host definition in JSON, because we can.

``` json
{ "host": "localhost" }
```

## Operations

### Add Cowbell

A good description.

`` yaml
paths:
  "/cowbell":
    post:
      description: []
      operationId: Cowbell_Add
      parameters:
      - in: body
        name: body
        required: true
        schema:
          $ref: '#/definitions/Cowbell'
      responses:
        '200':
          description: Cowbell was added.
```

## Definitions

### Cowbell

A cowbell.

``` yaml
definitions:
  Cowbell:
    required:
    - name
    properties:
      id:
        type: integer
        format: int64
      name:
        type: string
    description: []
```