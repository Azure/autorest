# <img align="center" src="./docs/images/logo.png"> AutoRest

The **AutoRest** tool generates client libraries for accessing RESTful web services. Input to *AutoRest* is a spec that describes the REST API using the [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification) format.

## Packages

| Name                                            | Changelog                       | Latest                                                       | Next                                                              |
| ----------------------------------------------- | ------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------- |
| Core functionality                              |
| [autorest][autorest_src]                        | [Changelog][autorest_chg]       | ![](https://img.shields.io/npm/v/autorest)                   | ![](https://img.shields.io/npm/v/autorest/next)                   |
| [@autorest/core][core_src]                      | [Changelog][core_chg]           | ![](https://img.shields.io/npm/v/@autorest/core)             | ![](https://img.shields.io/npm/v/@autorest/core/next)             |
| [@autorest/modelerfour][modelerfour_src]        | [Changelog][modelerfour_chg]    | ![](https://img.shields.io/npm/v/@autorest/modelerfour)      | ![](https://img.shields.io/npm/v/@autorest/modelerfour/next)      |
| Language generators                             |
| [@autorest/csharp][csharp_src]                  | [Changelog][csharp_chg]         | ![](https://img.shields.io/npm/v/@autorest/csharp)           |                                                                   |
| [@autorest/go][go_src]                          | [Changelog][go_chg]             | ![](https://img.shields.io/npm/v/@autorest/go)               |                                                                   |
| [@autorest/java][java_src]                      | [Changelog][java_chg]           | ![](https://img.shields.io/npm/v/@autorest/java)             |                                                                   |
| [@autorest/python][python_src]                  | [Changelog][python_chg]         | ![](https://img.shields.io/npm/v/@autorest/python)           |                                                                   |
| [@autorest/swift][swift_src]                    | [Changelog][swift_chg]          | ![](https://img.shields.io/npm/v/@autorest/swift)            |                                                                   |
| [@autorest/typescript][typescript_src]          | [Changelog][typescript_chg]     | ![](https://img.shields.io/npm/v/@autorest/typescript)       |                                                                   |
| Internal packages                               |
| [@autorest/codemodel][codemodel_src]            | [Changelog][codemodel_chg]      | ![](https://img.shields.io/npm/v/@autorest/codemodel)        | ![](https://img.shields.io/npm/v/@autorest/codemodel/next)        |
| [@autorest/common][common_src]                  | [Changelog][common_chg]         | ![](https://img.shields.io/npm/v/@autorest/common)           | ![](https://img.shields.io/npm/v/@autorest/common/next)           |
| [@autorest/configuration][configuration_src]    | [Changelog][configuration_chg]  | ![](https://img.shields.io/npm/v/@autorest/configuration)    | ![](https://img.shields.io/npm/v/@autorest/configuration/next)    |
| [@autorest/extension-base][extension_base_src]  | [Changelog][extension_base_chg] | ![](https://img.shields.io/npm/v/@autorest/extension-base)   | ![](https://img.shields.io/npm/v/@autorest/extension-base/next)   |
| [@azure-tools/extension][extension_src]         | [Changelog][extension_chg]      | ![](https://img.shields.io/npm/v/@azure-tools/extension)     | ![](https://img.shields.io/npm/v/@azure-tools/extension/next)     |
| [@azure-tools/codegen][codegen_src]             | [Changelog][codemodel_chg]      | ![](https://img.shields.io/npm/v/@azure-tools/codegen)       | ![](https://img.shields.io/npm/v/@azure-tools/codegen/next)       |
| [@azure-tools/openapi][openapi_src]             | [Changelog][openapi_chg]        | ![](https://img.shields.io/npm/v/@azure-tools/openapi)       | ![](https://img.shields.io/npm/v/@azure-tools/openapi/next)       |
| [@azure-tools/deduplication][deduplication_src] | [Changelog][deduplication_chg]  | ![](https://img.shields.io/npm/v/@azure-tools/deduplication) | ![](https://img.shields.io/npm/v/@azure-tools/deduplication/next) |
| [@azure-tools/datastore][datastore_src]         | [Changelog][datastore_chg]      | ![](https://img.shields.io/npm/v/@azure-tools/datastore)     | ![](https://img.shields.io/npm/v/@azure-tools/datastore/next)     |
| [@azure-tools/oai2-to-oai3][oai2-to-oai3_src]   | [Changelog][oai2-to-oai3_chg]   | ![](https://img.shields.io/npm/v/@azure-tools/oai2-to-oai3)  | ![](https://img.shields.io/npm/v/@azure-tools/oai2-to-oai3/next)  |
| [@azure-tools/jsonschema][jsonschema_src]       | [Changelog][jsonschema_chg]     | ![](https://img.shields.io/npm/v/@azure-tools/jsonschema)    | ![](https://img.shields.io/npm/v/@azure-tools/jsonschema/next)    |

[autorest_src]: packages/apps/autorest
[core_src]: packages/extensions/core
[modelerfour_src]: packages/extensions/modelerfour
[csharp_src]: https://github.com/Azure/autorest.csharp
[python_src]: https://github.com/Azure/autorest.python
[go_src]: https://github.com/Azure/autorest.go
[java_src]: https://github.com/Azure/autorest.java
[swift_src]: https://github.com/Azure/autorest.swift
[typescript_src]: https://github.com/Azure/autorest.typescript
[codemodel_src]: packages/libs/codemodel
[common_src]: packages/libs/common
[configuration_src]: packages/libs/configuration
[extension_base_src]: packages/libs/extension-base
[extension_src]: packages/libs/extension
[codegen_src]: packages/libs/codegen
[openapi_src]: packages/libs/openapi
[deduplication_src]: packages/libs/deduplication
[datastore_src]: packages/libs/datastore
[jsonschema_src]: packages/libs/oai2-to-oai3
[autorest_chg]: packages/apps/autorest/CHANGELOG.md
[core_chg]: packages/extensions/core/CHANGELOG.md
[modelerfour_chg]: packages/extensions/modelerfour/CHANGELOG.md
[csharp_chg]: https://github.com/Azure/autorest.csharp
[python_chg]: https://github.com/Azure/autorest.python/blob/autorestv3/ChangeLog.md
[go_chg]: https://github.com/Azure/autorest.go
[java_chg]: https://github.com/Azure/autorest.java/releases
[swift_chg]: https://github.com/Azure/autorest.swift
[typescript_chg]: https://github.com/Azure/autorest.typescript
[codemodel_chg]: packages/libs/codemodel/CHANGELOG.md
[common_chg]: packages/libs/common/CHANGELOG.md
[configuration_chg]: packages/libs/configuration/CHANGELOG.md
[extension_base_chg]: packages/libs/extension-base/CHANGELOG.md
[extension_chg]: packages/libs/extension/CHANGELOG.md
[codegen_chg]: packages/libs/codegen/CHANGELOG.md
[openapi_chg]: packages/libs/openapi/CHANGELOG.md
[deduplication_chg]: packages/libs/deduplication/CHANGELOG.md
[datastore_chg]: packages/libs/datastore/CHANGELOG.md
[oai2-to-oai3_chg]: packages/libs/oai2-to-oai3/CHANGELOG.md
[jsonschema_chg]: packages/libs/jsonschema/CHANGELOG.md

## Support Policy

AutoRest is an open source tool -- if you need assistance, first check the documentation. If you find a bug or need some help, feel free to submit an [issue](https://github.com/Azure/autorest/issues)

## Getting Started using AutoRest ![image](./docs/images/normal.png)

View our [docs readme][docs_readme] as a starting point to find both general information and language-generator specific information

## Contributing

### Contributing guide

Check our [internal developer docs](./docs/internal/readme.md) to learn about our development process, how to propose bugfixes and improvements, and how to build and test your changes to Autorest.

### Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

<!--LINKS-->
[docs_readme]: docs/readme.md

