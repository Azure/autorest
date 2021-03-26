# Authentication in generated SDKs

Autorest only supports 2 types of authentication, any other will need to be handled manually:

- `AADToken`: Represent an AzureAD oauth2 authentication
- `AzureKey`: Represent an api key authentication

This can be either configured in OpenAPI spec or using flags/config

## Configure in OpenAPI

This uses [OpenAPI security model](https://swagger.io/docs/specification/authentication/)

### AAD Token authentication

- OpenAPI 3

```json
{
  "components": {
    "securitySchemes": {
      "AADToken": {
        "$ref": "https://raw.githubusercontent.com/Azure/autorest/master/schemas/aad-token-security.json#/components/securitySchemes/AADToken"
      }
    }
  },
  "security": [
    {
      "AADToken": ["https://myservice.azure.com/.default"]
    }
  ]
}
```

- Swagger 2.0

```json
{
  "securityDefinitions": {
    "AADToken": {
      "$ref": "https://raw.githubusercontent.com/Azure/autorest/master/schemas/aad-token-security.json#/components/securitySchemes/AADToken"
    }
  },
  "security": [
    {
      "AADToken": ["https://myservice.azure.com/.default"]
    }
  ]
}
```

### Key authentication

- OpenAPI 3

```json
{
  "components": {
    "securitySchemes": {
      "AzureKey": {
        "type": "apiKey",
        "in": "header",
        "name": "my-header-name"
      }
    }
  },
  "security": [
    {
      "AzureKey": []
    }
  ]
}
```

- Swagger 2.0

```json
{
  "securityDefinitions": {
    "AzureKey": {
      "type": "apiKey",
      "in": "header",
      "name": "my-header-name"
    }
  },
  "security": [
    {
      "AzureKey": []
    }
  ]
}
```
