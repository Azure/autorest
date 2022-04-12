# AutoRest Modeler Four

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

### Autorest plugin configuration

- Please don't edit this section unless you're re-configuring how the powershell extension plugs in to AutoRest
  AutoRest needs the below config to pick this up as a plug-in - see https://github.com/Azure/autorest/blob/master/docs/developer/architecture/AutoRest-extension.md

```yaml
pipeline:
  cadl/cadl-compiler:
    output-artifact: swagger-document
    scope: perform-load

  openapi-document/openapi-document-converter:
    input: cadl/cadl-compiler

  swagger-document/loader-swagger:
    null: true

  openapi-document/loader-openapi:
    null: true

  openapi-document/individual/identity:
    null: true

  swagger-document/identity:
    null: true
```
