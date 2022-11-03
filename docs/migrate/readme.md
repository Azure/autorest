# <img align="center" src="../images/logo.png"> Migrating from AutoRest V2 to V3

## General Guidance

First, make sure when generating you are using AutoRest V3. Follow the steps in [our installation section][install] for information on upgrading and confirming your new AutoRest version.

## New Features

### OpenAPI3 support!

AutoRest 3.0 finally supports OpenAPI3 files as an input format, with the following caveats:

- `anyOf`, `oneOf` are not currently supported
- other OpenAPI3 specific features may not be entirely supported.

### Generators - **Breaking**

A new set of language generator plugins are being written that adopt the lighter-weight patterns for Azure Core libraries.<br>

**The older generators are only compatible with Autorest V2.**

| Generator   | Packages names                         | Autorest Core |
| ----------- | -------------------------------------- | ------------- |
| V2 (Track1) | `@microsoft.azure/autorest.<language>` | `2.x`         |
| V3 (Track2) | `@autorest/<language>`                 | `3.x`         |

### Generate More Idiomatic SDKs

Support for track 2 SDKs that follow the guidelines listed [here][guidelines]

For language-specific information about migration and changes, please refer to our language-specific documentation:

- [Python][python]
- [Java][java]
- [C#][csharp]
- [Typescript][typescript]

<!-- LINKS -->

[install]: https://github.com/Azure/autorest/blob/main/docs/install/readme.md
[language_flags]: https://github.com/Azure/autorest/blob/main/docs/generate/readme.md#language-flags
[guidelines]: https://azure.github.io/azure-sdk/general_introduction.html
[python]: https://github.com/Azure/autorest.python/tree/autorestv3/docs/migrate/readme.md
[java]: https://github.com/Azure/autorest.java/blob/main/docs/migrate/readme.md
[csharp]: https://github.com/Azure/autorest.csharp/tree/feature/v3/docs/migrate/readme.md
[typescript]: https://github.com/Azure/autorest.typescript/blob/main/packages/autorest.typescript/docs/migrate/readme.md
