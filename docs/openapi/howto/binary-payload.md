# How to represent binary/file payload in openapi

This document will explain how you can represent various binary payload in swagger/openapi.

## Basics

There are 2 part to describe a binary/file payload:

- Describe the `content-type`, this could be anything, for example

  - `application/octet-stream`: For a raw binary file.
  - `image/png`: To describe returning a png file.
  - `application/json`: To describe returning some json file.(This could be used to describe a json file where the server/sdk has no control over the content)

- Describe the schema of the payload. This is the important part to mark the payload as a binary/file. It is a different process for OpenAPI 2(Swagger) and OpenAPI 3
  - OpenAPI3: Use schema `{"type": "string", "format": "binary"}`
  - OpenAPI2: This one is a little more complex, for responses: `{"type": "file"}` and for requests `{"type": "string", "format": "binary"}` (This is a autorest specific feature. Read [below](#openapi-2-1) for more details.)

[See more information on Swagger docs](https://swagger.io/docs/specification/describing-responses/#response-that-returns-a-file)

### Request body

The overall request should look like this(Replace `{{INSERT_CONTENT_TYPE}}` with desired content type):

#### OpenAPI 3

```json
{
  "paths": {
    "/upload-file": {
      "post": {
        "requestBody": {
          "content": {
            "{{INSERT_CONTENT_TYPE}}": {
              "schema": {
                "type": "string",
                "format": "binary"
              }
            }
          }
        }
      }
    }
  }
}
```

#### OpenAPI 2

**Important:** OpenAPI 2 doesn't actually generate file content as described in their docs [File upload](https://swagger.io/docs/specification/2-0/file-upload/).
However autorest does provide an extension and lets user follow the same pattern as OpenAPI3 using the schema using `{"type": "file"}`.

```json
{
  "paths": {
    "/upload-file": {
      "consumes": ["{{INSERT_CONTENT_TYPE}}"],
      "post": {
        "parameters": [
          {
            "name": "body",
            "in": "body",
            "schema": {
              "type": "string",
              "format": "file"
            }
          }
        ]
      }
    }
  }
}
```

### Response

The overall response should look like this(Replace `{{INSERT_CONTENT_TYPE}}` with desired content type):

#### OpenAPI 3

```json
{
  "paths": {
    "/return-file": {
      "get": {
        "responses": {
          "200": {
            "description": "Returns a binary file",
            "content": {
              "{{INSERT_CONTENT_TYPE}}": {
                "schema": {
                  "type": "string",
                  "format": "binary"
                }
              }
            }
          }
        }
      }
    }
  }
}
```

#### OpenAPI 2

```json
{
  "paths": {
    "/return-file": {
      "get": {
        "produces": ["{{INSERT_CONTENT_TYPE}}"],
        "responses": {
          "200": {
            "description": "Returns a binary file",
            "schema": {
              "type": "file"
            }
          }
        }
      }
    }
  }
}
```


## Examples

### Upload and return a png

**OpenAPI 3**

```json
{
  "paths": {
    "/png": {
      "get": {
        "operationId": "getImage",
        "responses": {
          "200": {
            "description": "Returns a binary file",
            "content": {
              "image/png": {
                "schema": {
                  "type": "string",
                  "format": "binary"
                }
              }
            }
          }
        }
      },
      "put": {
        "operationId": "putImage",
        "requestBody": {
          "content": {
            "image/png": {
              "schema": {
                "type": "string",
                "format": "binary"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Ok."
          }
        }
      }
    }
  },
  "openapi": "3.0.0",
  "info": {
    "title": "FileExamples",
    "description": "FileExamples",
    "version": "1.0"
  }
}
```

**OpenAPI 2**

```json
{
  "paths": {
    "/png": {
      "get": {
        "operationId": "getImage",
        "produces": ["image/png"],
        "responses": {
          "200": {
            "description": "Returns a png file",
            "schema": {
              "type": "file"
            }
          }
        }
      },
      "put": {
        "operationId": "putImage",
        "consumes": ["image/png"],
        "parameters": [
          {
            "name": "png",
            "in": "body",
            "schema": {
              "type": "string",
              "format": "file"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Ok."
          }
        }
      }
    }
  },
  "swagger": "2.0",
  "info": {
    "title": "FileExamples",
    "description": "FileExamples",
    "version": "1.0"
  }
}
```
