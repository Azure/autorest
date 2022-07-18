# <img align="center" src="../images/logo.png"> Writing OpenAPI Definitions for AutoRest

- Main OpenAPI docs [here][swagger]
- See AutoRest specific extensions [here][extensions]
- See our OpenAPI definition rules [here][rules]
- Generally swaggers are kept in [this][azure_rest_api_specs] repo
- Additional OpenAPI validation done by [Prechecker][prechecker]

Autorest interpretation of swagger specs:

- [Request body](./request-body.md)
- [Formats](./formats.md) Supported formats by autorest

How to guides:

- [Define binary/file requests](./howto/binary-payload.md)
- [Add fields next to $ref](./howto/$ref-siblings.md)
- [Polymorphism](./howto/polymorphism.md)

<!-- LINKS -->

[swagger]: https://swagger.io/docs/
[extensions]: ../extensions/readme.md
[rules]: https://github.com/Azure/azure-rest-api-specs/blob/master/documentation/openapi-authoring-automated-guidelines.md
[azure_rest_api_specs]: https://github.com/Azure/azure-rest-api-specs
[prechecker]: ./prechecker.md
