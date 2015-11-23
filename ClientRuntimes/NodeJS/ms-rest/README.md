# MS-Rest

Infrastructure for error handling, tracing, and http client pipeline configuration. Required by nodeJS client libraries generated using AutoRest.

- **Node.js version: 0.10.0 or higher**


## How to Install

```bash
npm install ms-rest
```

## Browser Testing
This library is moving toward being isomorphic. A step toward that is enabling browser based testing. To test in the browser,
you will need to install [Zuul](https://github.com/defunctzombie/zuul) via the following command:
```bash
npm install -g zuul
```
After you have installed Zuul, you can run the tests in a browser locally by running:
```bash
zuul --local -- tests/*.js
```
If you'd like to get fancy and run them in the cloud, follow [these instructions](https://github.com/defunctzombie/zuul/wiki/cloud-testing).
After you've setup your sauce credentials, you should be able to run:
```bash
zuul -- tests/*.js

or via

npm run test-browser
```

## Related Projects

- [AutoRest](https://github.com/Azure/AutoRest)
