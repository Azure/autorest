# <img align="center" src="../images/logo.png">  Index of AutoRest Flags

## Shared Flags
| Flag | Description | Python | .NET | Java | TS | Go
|------------------|-------------|-------------|-------------|-------------|-------------|-------------
| `--input-file=FILENAME` | Adds the given file to the list of input files for generation process | x | x | x | x | x
|`--output-folder=DIRECTORY`|The location for generated files. If not specified, uses `./generated` as the default| x | x | x | x | x
|`--clear-output-folder`|Clear all contents from our output folder before outputting your newly generated code into that folder. Defaults to `false`.| x | x | x | x | x
|`--project-folder=DIRECTORY`|Use this flag if you have a project folder that will contain both generated code and existing code you would like to persist. You can then define the output folder relative to this project folder, i.e. `output-folder: $(project-folder)/generated`.| x | x | x | x | x
|`--add-credential`|If specified, the generated client will require a credential to make network calls. See [our language docs][client] for information on how to authenticate to our generated clients. Forced to be `true` if `--azure-arm` is set, otherwise defaults to `false`.| x | No flag for `--add-credential`, will add credential param for a `TokenCredential` if `--azure-arm` is `true`. | No flag for `--add-credential`, gets whether to add credential from value of `--credential-types`. Defaults to false.| Is called `--add-credentials`. Defaults to false. | No flag, looks in `authenticationRequired` field in the swagger. Does not automatically set to true in azure-arm.
|`--credential-scopes=VALUE(S)`|Specify the scopes over which the credential functions (see previous flag `--add-credential` for adding client credentials). This is tied with `BearerTokenCredentialPolicy`. If generating management plane code (see `--azure-arm` flag directly below), we default the scope to `'https://management.azure.com/.default'`. If not, we highly recommend you  use this flag if `--add-credential` is specified. If you don't generate with scopes in this case, it forces your SDK users to pass credential scopes themselves when calling your code. You can pass multiple values in using CSV format.| x | No flag for credential scopes. Currently only sets `TokenCredential` in mgmt mode. In mgmt mode's case, the credential scope is forced to `{endpoint}/.default`. In mgmt mode, this endpoint (which is gotten from the swagger), is `https://management.azure.com`| Currently doesn't default to ARM scope in mgmt mode | | `--credential-scope`
|`--license-header=LICENSE_HEADER`|Specify the type of license header for your files. Common values include `MICROSOFT_MIT_NO_VERSION` and `MICROSOFT_MIT_NO_CODEGEN` TODO: list of all possible values and default| x | x | x | x | x
|`--namespace=NAMESPACE`|Sets the namespace to use for the generated code| x | x | x | |
|`--tag=VALUE`|Preferred way to have conditional configurations. I.e., in my configuration file, I can set the `input-file` equal to different values depending on the `VALUE` passed through the `tag` flag. See our [Adding Tags When Generating][adding_tags_when_generating] section for more information|
|`--azure-arm`|generates control plane (Azure Resource Manager) code. Use this if you're generate SDKs for people to manage their Azure resources. See our [mgmt plane section][mgmt_plane_section] for more info. Defaults to `false`.| x | x | x | x | Uses flag `--openapi-type=arm` to specify
|`--head-as-boolean`|With this flag, HEAD calls to non-existent resources (404) will not raise an error. Instead, if the resource exists, we return `true`, else `false`. Forced to be `true` if `--azure-arm` is set, otherwise defaults to `false`.| x | x ||| Go default is always `false`.
|`--title=NAME`|Override the service client's name listed in the swagger under `title`.| x | x | x | x | x
|`--description=DESCRIPTION`|Override the service client's description listed in the swagger under the top level `description`.| x | x | x | x | x
|`--client-side-validation`|Whether you want the SDK to perform validation on inputs and outputs, based on swagger information. Recommended to be `false` for track 2 code, since we want the network to validate instead. Defaults to `false`.| x | x | calls it `--client-side-validations` | | x
|`--package-name=NAME`|The name of your package. This is the name your package will be published under.| x | | |x |
|`--package-version=VERSION`|The semantic versioning of your generated SDK (i.e., `1.0.0`). Not to be confused with the version of the service you're creating an SDK for. If no version is specified, AutoRest will not create a new version file. Generally not necessary if you are going to wrap the generated code before exposing to users.| Needs to be specified if `--basic-setup-py` is specified. | Currently can't generate version for track 2|Default is `1.0.0-beta.1`. Only available in `fluent` mode.|Currently can't set version for track 2| Defaults to `1.0.0`|
|`--trace`|Whether to natively support tracing libraries, such OpenCensus or OpenTelemetry. See this [tracing quickstart][tracing_quickstart] for an overview. Defaults to `false`.| x | | | x|

## Autorest flags
Those are flags that affect autorest only

| Flag                          | Description                                                                                                                      |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `--output-converted-oai3`     | If enabled and the input-files are `swager 2.0` this will output the resulting OpenAPI3.0 converted files to the `output-folder` |
| `--skip-semantics-validation` | Disable the semantic validator plugin.                                                                                           |


## Temporary flags
Those flags are temporary and will be removed in the future. Those flags are here to have a smoother rollout of certain feature.

| Flag | Description
|------------------|-------------
| `--mark-oai3-errors-as-warnings` | Mark OpenAPI3 validation(schema) error as warnings. (When removed OpenAPI3 validation errors will always fail the pipeline)

## Python Flags
| Flag | Description
|------------------|-------------
|`--python-sdks-folder=DIRECTORY`| The path to the root directory of your [`azure-sdk-for-python`][azure_sdk_for_python] clone. Be sure to note that we include `sdk` in the folder path.
|`--black`| Runs [black][black] formatting on your generated files. Defaults to `false`.
|`--basic-setup-py`|Whether to generate a build script for setuptools to package your SDK. See [here][setup_py] for more information about a `setup.py` file. Defaults to `false`, generally not suggested if you are going to wrap the generated code before exposing to users. Needs `--package-version` to be specified. Defaults to `false`.
|`--multiapi`|Whether to generate a multiapi client. See [our multiapi section][multiapi_section] for more information. Defaults to `false`.
|`--default-api=VALUE`|In the case of `--multiapi`, you can override the default service API version with this flag. If not specified, we use the latest GA service version as the default API.
|`--keep-version-file`|Whether you want to override the current version file in your package or not. Defaults to `false`.
|`--no-namespace-folders`|Specify if you don't want pkgutil-style namespace folders. See [here][namespace_folders] for more information on pkgutil namespace folders. Defaults to `false`.
|`--credential-default-policy-type=BearerTokenCredentialPolicy\|AzureKeyCredentialPolicy`|Specify the default credential policy (authentication policy) for your client. Use in conjunction with `--add-credential`. Currently only supports [`BearerTokenCredentialPolicy`][bearer_token_credential_policy] and [`AzureKeyCredentialPolicy`][azure_key_credential_policy]. Default value is `BearerTokenCredentialPolicy`. `--credential-scopes` is tied with `BearerTokenCredentialPolicy`, do not pass them in if you want `AzureKeyCredentialPolicy`.
|`--credential-key-header-name=NAME`|The name of the header which will pass the credential. Use if you have `--credential-default-policy-type` set to [`AzureKeyCredentialPolicy`][azure_key_credential_policy]. For example, if generating cognitive services code, you might use `--credential-key-header-name=Ocp-Apim-Subscription-Key`.

## .NET Flags

| Flag | Description
|------------------|-------------
|`--library-name=NAME`|The name of your library. This is what will be displayed on NuGet.
|`--shared-source-folders=VALUE(S)`|Pass shared folder paths through here. Common values point to the [shared generator assets][shared_generator_assets] and [shared azure core assets][shared_azure_core_assets] in [autorest.csharp][autorest_csharp]
|`--public-clients`|Whether to have your client public. Defaults to `false`.
|`--model-namespace`|Whether to add a separate namespace of Models, more specifically adding `{value-from-namespace-flag}.Models`. Defaults to `true`.

## Java Flags

| Flag | Description
|------------------|-------------
|`--azure-libraries-for-java-folder=DIRECTORY` | The path to the root directory of your [`azure-sdk-for-java`][azure_sdk_for_java] clone. Be sure to note that we include `sdk` in the folder path.
|`--fluent=LITE\|PREMIUM`|Enables Java's fluent generator, generating a set of fluent Java interfaces for a guided and convenient user experience for the client library. Currently used by Azure management libraries. `LITE` for Fluent Lite; `PREMIUM` for Fluent Premium. Default is `PREMIUM` if provided as other values. See [the java docs][fluent_docs] for all of the Fluent specific flags.
|`--regenerate-pom`|Whether to regenerate the pom file in your project. See [here][pom] for more information on what a pom file is. Defaults to `false`.
|`--generate-client-as-impl`|Append "Impl" to the names of service clients and method groups and place them in the `implementation` sub-package. Defaults to `false`.
|`--generate-client-interfaces`|Generates interfaces for all the "Impl"s. Forces `--generate-client-as-impl` to `true`, and generates an interface for it as well. Defaults to `false`.
|`--generate-sync-async-clients`|Generates sync and async convenience layer clients for all the "Impl"s. Forces `--generate-client-as-impl` to `true`. Defaults to `false`.
|`--implementation-subpackage=NAME`|The sub-package that the Service client and Method Group client implementation classes will be put into. Defaults to `implementation`.
|`--models-subpackage=NAME`|The sub-package that Enums, Exceptions, and Model types will be put into. Defaults to `models`.
|`--add-context-parameter`|Indicates whether the [`com.azure.core.util.Context`][java_context] parameter should be included in generated proxy methods. Use if you want to pass arbitrary data (key-value pairs) to pipeline policies. Defaults to `false`.
|`--context-client-method-parameter`|Indicates whether the [`com.azure.core.util.Context`][java_context] parameter should also be included in generated client methods. Forces `--add-context-parameter` to `true`. Defaults to `false`.
|`--sync-methods=all\|essential\|none`|Specifies mode for generating sync wrappers. Supported values are <br>&nbsp;&nbsp;`essential` - generates only one sync returning body or header (default) <br>&nbsp;&nbsp;`all` - generates one sync method for each async method<br>&nbsp;&nbsp;`none` - does not generate any sync methods
|`--required-parameter-client-methods`|Indicates whether client method overloads with only required parameters should be generated. Defaults to `false`.
|`--custom-types-subpackage=VALUE`|The sub-package that the custom types should be generated in. The types that custom types reference, or inherit from will also be automatically moved to this sub-package. **Recommended usage**: You can set this value to `models` and set `--models-subpackage=implementation.models`to generate models to `implementation.models` by default and pick specific models to be public through `--custom-types`.
|`--custom-types=VALUE(S)`|Specifies a list of files to put in the package specified in `--custom-types-subpackage`. You can pass multiple values in using CSV format.
|`--client-type-prefix=PREFIX`|The prefix that will be added to each generated client type.
|`--model-override-setter-from-superclass`|Indicates whether to override the superclass setter method in model. Defaults to `false`.
|`--non-null-annotations`|Whether or not to add the `@NotNull` annotation to required parameters in client methods. Defaults to `false`.
|`--client-logger`|Whether the client should log by default. Defaults to `false`.
|`--required-fields-as-ctor-args`|Whether an object's required fields should be specified as arguments to its constructor. Defaults to `false`.
|`--service-interface-as-public`|Whether the service's interface should be set as public. Defaults to `false`.
|`--artifact-id`|The name of your project jar without its version. See [here][artifact_id] for more information about an artifact id.
|`--credential-types=TokenCredential\|AzureKeyCredential\|None`|The type of credential if `--add-credential` is specified. Defaults to `None`.
|`--customization-jar-path=FILEPATH`|Pass in the path to your .jar file that contains customizations to the output files. This will allow AutoRest to dynamically load the class you provide in `--customization-class`.
|`--customization-class=NAME`|Use in conjunction with `--customization-jar-path`. That flag tells AutoRest where to look for your custom class, while `--customization-class` tells AutoRest the name of your custom class.

## TS Flags

| Flag | Description
|------------------|-------------
|`--source-code-folder-path=DIRECTORY`|Where to output the generated code inside the `output-folder`. Use in the scenario when you are going to write a convenience layer on top of the generated code. Defaults to `src`.| | || x|
|`--generate-metadata`|Whether to generate extra metadata in your package. For instance, generates a README file, license file etc if set to `true`. Defaults to `false`.
|`--tracing-spanprefix=SPAN_PREFIX`|If you are tracing (passing in flag `--trace`), and you want to overwrite the span prefix AutoRest assigns, use this flag.
|`--disable-async-iterators`|Whether to generate pageable methods as [AsyncIterators][ts_async_iterator]. Defaults to `true`.

## Go flags

| Flag | Description
|------------------|-------------
|`--module=NAME`|The name of the module. This is the name your module will be published under.
|`--file-prefix=PREFIX`|Optional prefix to file names. For example, if you set your file prefix to "zzz", all generated code files will begin with "zzz".
|`--openapi-type=arm\|data-plane`|Specify if you want to generate `data-plane` code or `arm` code.
|`--armcore-connection`|If set to `true`, we output the code with the `Connection` type specified in [`armcore`][armcore_connection]. If not, we output a new `Connection` constructor with the generated code. Defaults to `false`.

## Debugging flags

| Flag | Description | Python | .NET | Java | TS | Go
|------------------|-------------|-------------|-------------|-------------|-------------|-------------
|`--verbose`| Log verbose-level information during generation time | x | x | x | x | x
|`--debug`| Log debug-level information during generation time | x | x | x | x | x
|`--{language-generator}-debugger`| Debug into a specific language's code. See our [debugging docs][debugging] to see if there are extra steps needed to for your language generator of choice | x | x | x | x | x
|`--save-inputs`|Whether to save the configuration files (i.e. `Configuration.json` or `codeyaml.json`). Defaults to `false`.| | x| | | | |


## Deprecated / Not-Recommended Flags

| Flag | Description | Python | .NET | Java | TS | Go
|------------------|-------------|-------------|-------------|-------------|-------------|-------------
|`--payload-flattening-threshold=NUMBER`|The maximum number of properties in the request body. If the number of properties in the request body is less than or equal to this value, these properties will be represented as method arguments. Not recommended because it can cause surprise breaking changes when adding properties. | x | x | x | x | x
|`--add-credentials`|Same as flag `--add-credential`, renamed because we only add one `credential` param in this case. | x | x | x | x | x

<!-- LINKS -->
[tracing_quickstart]: https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/core/azure-core-tracing-opentelemetry/README.md
[azure_sdk_for_python]: https://github.com/Azure/azure-sdk-for-python/tree/master/sdk
[mgmt_plane_section]: https://github.com/Azure/autorest/blob/master/docs/generate/readme.md#generating-management-plane-code
[setup_py]: https://packaging.python.org/tutorials/packaging-projects/#creating-setup-py
[multiapi_section]: https://github.com/Azure/autorest/blob/master/docs/generate/readme.md#generating-multi-api-code
[namespace_folders]: https://packaging.python.org/guides/packaging-namespace-packages/#pkgutil-style-namespace-packages
[bearer_token_credential_policy]: https://docs.microsoft.com/en-us/python/api/azure-core/azure.core.pipeline.policies.bearertokencredentialpolicy?view=azure-python
[azure_key_credential_policy]: https://docs.microsoft.com/en-us/python/api/azure-core/azure.core.pipeline.policies.azurekeycredentialpolicy?view=azure-python
[shared_generator_assets]: https://github.com/Azure/autorest.csharp/tree/feature/v3/src/assets/Generator.Shared
[shared_azure_core_assets]: https://github.com/Azure/autorest.csharp/tree/feature/v3/src/assets/Azure.Core.Shared
[autorest_csharp]: https://github.com/Azure/autorest.csharp
[azure_sdk_for_java]: https://github.com/Azure/azure-sdk-for-java/tree/master/sdk
[pom]: https://maven.apache.org/guides/introduction/introduction-to-the-pom.html#what-is-a-pom
[java_context]: https://azuresdkdocs.blob.core.windows.net/$web/java/azure-core/1.0.0/index.html?com/azure/core/util/Context.html
[artifact_id]: https://maven.apache.org/guides/mini/guide-naming-conventions.html
[fluent_docs]: https://github.com/Azure/autorest.java#additional-settings-for-fluent
[armcore_connection]: https://github.com/Azure/azure-sdk-for-go/blob/master/sdk/armcore/connection.go
[debugging]: https://github.com/Azure/autorest/blob/master/docs/troubleshooting.md#debugging
[black]: https://pypi.org/project/black/
[ts_async_iterator]: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-3.html#async-iterators
[client]: https://github.com/Azure/autorest/blob/master/docs/client/readme.md
[adding_tags_when_generating]: https://github.com/Azure/autorest/blob/master/docs/generate/readme.md#adding-tags-when-generating
