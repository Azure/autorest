# An isomorphic javascript sdk for - Deprecated
This project provides an isomorphic javascript package. Right now it supports:
- node.js version 6.x.x or higher
- browser javascript

## How to Install

- nodejs
```
npm install
```
- browser
```html
<script type="text/javascript" src="/deprecatedBundle.js"></script>
```

## How to use

### nodejs - Authentication, client creation and no path as an example written in TypeScript.

```javascript
import * as msRest from "ms-rest-js";
import { Deprecated, DeprecatedModels, DeprecatedMappers } from "";
const subscriptionId = process.env["AZURE_SUBSCRIPTION_ID"];

const token = "<access_token>";
const creds = new msRest.TokenCredentials(token);
const client = new Deprecated(creds, subscriptionId);
const arg = "testarg";
client.path.no(arg).then((result) => {
  console.log("The result is:");
  console.log(result);
}).catch((err) => {
  console.log('An error ocurred:');
  console.dir(err, {depth: null, colors: true});
});
```

### browser - Authentication, client creation and no path as an example written in javascript.

- index.html
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>My Todos</title>
    <script type="text/javascript" src="https://raw.githubusercontent.com/Azure/ms-rest-js/master/msRestBundle.js"></script>
    <script type="text/javascript" src="./deprecatedBundle.js"></script>
    <script type="text/javascript">
      document.write('hello world');
      const subscriptionId = "<Subscription_Id>";
      const token = "<access_token>";
      const creds = new msRest.TokenCredentials(token);
      const client = new Deprecated(creds, subscriptionId);
      const arg = "testarg";
      client.path.no(arg).then((result) => {
        console.log("The result is:");
        console.log(result);
      }).catch((err) => {
        console.log('An error ocurred:');
        console.dir(err, { depth: null, colors: true});
      });
    </script>
  </head>
  <body>
  </body>
</html>
```

# Related projects
 - [Microsoft Azure SDK for Javascript](https://github.com/Azure/azure-sdk-for-js)
