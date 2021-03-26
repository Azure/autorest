# Authentication in generated SDKs

Autorest only supports 2 types of authentication, any other will need to be handled manually:

- `AADToken`: Represent an AzureAD OAuth2 authentication
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
        "type": "oauth2",
        "flows": {
          "authorizationCode": {
            "authorizationUrl": "https://login.microsoftonline.com/common/v2.0/oauth2/authorize",
            "tokenUrl": "https://login.microsoftonline.com/common/v2.0/oauth2/token"
          }
        }
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
      "type": "oauth2",
      "flow": "accessCode",
      "authorizationUrl": "https://login.microsoftonline.com/common/v2.0/oauth2/authorize",
      "tokenUrl": "https://login.microsoftonline.com/common/v2.0/oauth2/token"
    }
  },
  "security": [
    {
      "AADToken": ["https://myservice.azure.com/.default"]
    }
  ]
}
```

Alternatively instead of using a `$ref` you can

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

## Configure using flags/config

There is a few config options that will result in the same generation:

### `--security`

This is a list of the supported security schemes(`AADToken` | `AzureKey`).

Example

```yaml
# For AAD Token  only
security: AADToken

# For Azure key  only
security: AzureKey

# For both
security: [AADToken, AzureKey]
```

By default:

- `AADToken` scope is `https://management.azure.com/.default`
- `AzureKey` header name is `Authorization`

### `--security-scopes`

To be used with `security: AADToken` will override the list of scopes.

Example:

```yaml
security: AADToken
security-scopes:
  - "https://fakeendpoint.azure.com/.default"
  - "https://dummyendpoint.azure.com/.default"
```

### `--security-header-name`

To be used with `security: AzureKey` will override the header name.

Example:

```yaml
security: AzureKey
security-header-name: CustomAuth
```

### `--azure-arm`

This will automatically configure `AADToken` credentials with `https://management.azure.com/.default` scope.

Equivalent to passing

```json
{
  "components": {
    "securitySchemes": {
      "AADToken": {
        "type": "oauth2",
        "flows": {
          "authorizationCode": {
            "authorizationUrl": "https://login.microsoftonline.com/common/v2.0/oauth2/authorize",
            "tokenUrl": "https://login.microsoftonline.com/common/v2.0/oauth2/token"
          }
        }
      }
    }
  },
  "security": [{ "AADToken": ["https://management.azure.com/.default"] }]
}
```
