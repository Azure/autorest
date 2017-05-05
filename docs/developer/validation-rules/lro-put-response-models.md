# M2064 - LROStatusCodesValidation
## Description
This violation is flagged if a long-running PUT operation has a 200/201 status code specified without a response model definition. Eg:
```
"operationId": "Redis_Create",
"x-ms-long-running-operation": true,
....

"responses": {
    "201": {
        "description": ""
    },
    "200": {
        "description": ""
    }
}

```

## How to fix
If a 200/201 response code is defined in the `responses` section of the operation, ensure that there is a model schema referenced in the response body section for either status codes.