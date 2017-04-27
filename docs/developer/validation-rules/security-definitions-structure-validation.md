# Validation of the structure of Security Definitions
## Description
Every swagger/configuration must have a security definitions section and it must adhere to the following structure:

```
"securityDefinitions": {
    "azure_auth": {
        "type": "oauth2",
        "authorizationUrl": "https://login.microsoftonline.com/common/oauth2/authorize",
        "flow": "implicit",
        "description": "Azure Active Directory OAuth2 Flow",
        "scopes": {
            "user_impersonation": "impersonate your user account"
        }
    }
}
```

## How to fix
Add the above security definitions.