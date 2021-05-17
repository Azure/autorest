# Feature status tracking

This is a table tracking the implementation of new features across Autorest generators and which version there were added.

| Feature                                  | Core Version | Modelerfour version | Python  | CSharp                              | Java | Typescript | Go  | Swift |
| ---------------------------------------- | ------------ | ------------------- | ------- | ----------------------------------- | ---- | ---------- | --- | ----- |
| [`AnyObject` vs `Any`][any-feat]         |              | `4.19.0`            | `5.8.0` | `v3.0.0-beta.20210428.3`            |
| [Security standarization][security-feat] |              | `4.19.0`            |         | [WIP: PR#1128][security-csharp-wip] |
| [Deprecation][deprecation-feat]          |              | `4.19.0`            |

<!-- Feature links -->

[any-feat]: https://github.com/Azure/autorest/pull/4067
[security-feat]: https://github.com/Azure/autorest/pull/4018
[deprecation-feat]: https://github.com/Azure/autorest/pull/4033

<!-- Generator links -->

[security-csharp-wip]: https://github.com/Azure/autorest.csharp/pull/1128
