# MS-Rest-Azure

Infrastructure for error handling, tracing, and http client pipeline configuration. Required by nodeJS Azure client libraries, generated using AutoRest.

- **Node.js version: 0.10.0 or higher**


## How to Install

```bash
npm install ms-rest-azure
```

## Usage
```javascript
var msrestAzure = require('ms-rest-azure');
```
## Authentication

```javascript
 //user authentication
 var credentials = new msRestAzure.UserTokenCredentials('your-client-id', 'your-domain', 'your-username', 'your-password', 'your-redirect-uri');
 //service principal authentication
 var credentials = new msRestAzure.ApplicationTokenCredentials('your-client-id', 'your-domain', 'your-secret');
```
### Non-Interactive Authentication
If you need to create an automation account for non interactive or scripting scenarios then please take a look at the documentation over [here](https://github.com/Azure/azure-sdk-for-node/blob/autorest/Documentation/Authentication.md).

## Related Projects

- [AutoRest](https://github.com/Azure/AutoRest)