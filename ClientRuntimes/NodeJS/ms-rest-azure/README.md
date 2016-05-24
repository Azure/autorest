# MS-Rest-Azure

Infrastructure for error handling, tracing, and http client pipeline configuration. Required by nodeJS Azure client libraries, generated using AutoRest.

- **Node.js version: 4.x.x or higher**


## How to Install

```bash
npm install ms-rest-azure
```

## Usage
```javascript
var msrestAzure = require('ms-rest-azure');
```
## Authentication

#### Interactive Login is the simplest and the best way to authenticate.
It provides a url and code that needs to be copied and pasted in a browser and authenticated over there. If successful, 
the user will get a DeviceTokenCredentials object.
```javascript
 var someAzureServiceClient = require('azure-arm-someService');
 msRestAzure.interactiveLogin(function(err, credentials) {
   if (err) return console.log(err);
   var client = new someAzureServiceClient(credentials, 'your-subscriptionId');
   client.someOperationGroup.method(param1, param2, function(err, result) {
     if (err) return console.log(err);
     return console.log(result);
   });
 });
```

#### Login with username and password
This mechanism will only work for organizational ids and ids that are not 2FA enabled.
Otherwise it is better to use the above mechanism (interactive login).
```javascript
 var someAzureServiceClient = require('azure-arm-someService');
 msRestAzure.loginWithUsernamePassword(username, password, function(err, credentials) {
   if (err) return console.log(err);
   var client = new someAzureServiceClient(credentials, 'your-subscriptionId');
   client.someOperationGroup.method(param1, param2, function(err, result) {
     if (err) return console.log(err);
     return console.log(result);
   });
 });
```

### Non-Interactive Authentication
If you need to create an automation account for non interactive or scripting scenarios then please take a look at the documentation over [here](https://github.com/Azure/azure-sdk-for-node/blob/master/Documentation/Authentication.md). Once you have created a service principal you can authenticate using the following code snippet.

#### Login with service principal name and secret
```javascript
 var someAzureServiceClient = require('azure-arm-someService');
 msRestAzure.loginWithServicePrincipalSecret(clientId, secret, domain, function(err, credentials) {
   if (err) return console.log(err);
   var client = new someAzureServiceClient(credentials, 'your-subscriptionId');
   client.someOperationGroup.method(param1, param2, function(err, result) {
     if (err) retutrn console.log(err);
     return console.log(result);
   });
 });
```

## Related Projects

- [AutoRest](https://github.com/Azure/AutoRest)
