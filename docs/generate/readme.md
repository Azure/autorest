# <img align="center" src="./images/logo.png">  Generating Clients with AutoRest

This guide tells you how to generate code from your OpenAPI definition using AutoRest. We'll take this incrementally, working
on first how to generate a single file, then how to generate with a configuration file, and keep taking it from there.

The command line usage of AutoRest boils down to the following:
> `autorest [config-file.md | config-file.json | config-file.yaml] [additional options]`
We'll be building upon this in our individual sections.

## Introduction: Flags


### Language flags

AutoRest has varying levels of support for the following languages. When generating code, we always want to specify what language we
want our generated code to have, and we specify our language through a command line flag

| Language | Description |
|------------------|-------------|
|`--python`|Python|
|`--csharp`|C# / .NET code|
|`--java`|Java|
|`--typescript`|Typescript|
|`--go`|Golang|
|No flag yet|Swift|

### Common flags

For a full-set of flags, go to our [flag index](#index-of-flags)

| Option | Description |
|------------------|-------------|
|`--input-file=FILENAME`|Adds the given file to the list of input files for generation process|
|`--output-folder=DIRECTORY`|The location for generated files. If not specified, uses `./Generated` as the default|
|`--clear-output-folder`|Clear all contents from our output folder before outputting your newly generated code into that folder|
|`--namespace=NAMESPACE`|sets the namespace to use for the generated code|
|`--add-credential`|If specified, the generated client will require a credential to make network calls. See [TODO] for information on how to authenticate to our generated clients|
|`--tag=VALUE`|Preferred way to have conditional configurations. I.e., in my configuration file, I can set the `input-file` equal to different values depending on the `VALUE` passed through the `tag` flag. See our [Adding Tags When Generating](#adding-tags-when-generating) section for more information|

## Most Basic: Generating with a Single File on the Command Line

The first step in an AutoRest journey usually starts with generating a single OpenAPI file. We will also show
how to set options during generation by building up our command-line step-by-step.

The first step here is to have your OpenAPI file definition of your client ([docs](./openapi/introduction.md)) on how to do that).
This example will use an example OpenAPI definition found [here](../../openapi/examples/pets.json), so feel free to follow along with
our sample code. To get things started, the command that starts AutoRest on the command line is `autorest`, so this is what our command line
looks like to start with

```
autorest
```

Next, we want to tell AutoRest which swagger file to generate. We do this by passing our swagger file through the `--input-file` flag, see [common
flags](#common-flags) for a description of its uses. Adding this to our command, we have

```
autorest --input-file=pets.json
```

We also need to tell AutoRest what language we want our SDK to be in, which we specify using our [language flags](#language-flags). For the sake of this example,
let's say we want to generate Python code. Adding this to our command line, we get

```
autorest --input=file=pets.json --python
```

In our final required step, we need to tell AutoRest where to output the generated SDK. We do this through the `--output-folder` flag (once again, see [common
flags](#common-flags) for more information). Putting this all together, we have:

```
autorest --input-file=pets.json --python --output-folder=generated/
```

There are many other flags you can specify when generating. As an add-on, let's say we want to generate our code under the namespace `pets`. This gives us:

```
autorest --input-file=pets.json --python --output-folder=generated/ --namespace=pets
```
And this concludes our basic example of generating with AutoRest. Continue reading to the next section to see our recommend way of generating AutoRest.

## Slighly More Complicated, But Preferred: Generating with a Configuration File

This section goes over the most common, and the preferred way of generating with AutoRest: that is, generating with a configuration file.
With a configuration file, we can move most of our flags from the command line into our configuration file, while still allowing
us the ability to override the configuration file settings from the command line. This both simplifies our command line for generation,
and allows us to have a standardized set of flags to generate your OpenAPI documents with.

As you can see in the above example, having to include these flags (i.e. `--input-file`, `--output-folder` etc) every time you generate can be annoying,
and if you're trying to have every AutoRest generation standardized, a tiny typo can make a big difference. This is where a configuration file comes in.
With a configuration file, we can add most, if not all of these flags into one file, where they can persist.

Lets start with our command line from the previous example, and work on moving these flags into a config file.

```
autorest --input-file=pets.json --python --output-folder=generated/ --namespace=pets
```

First step is to create our configuration file. The preferred name for a configuration file is `readme.md`, so you may hear these terms interchangeably.

Once your configuration file is created, we can work on moving our flags into the config file. We tell AutoRest what flags we want using `yaml` code chunks in the
readme.

We start building up the skeleton of our configuration file by adding our `yaml` code block.
````
```yaml
```
````

Now, we'll start moving the flags into the `yaml` code block. Adding the input file becomes
````
```yaml
input-file: pets.json
```
````
We also want our code to be generated in python, so let's add that to the config as well.

````
```yaml
input-file: pets.json
python: true
```
````
Finally, let's add our remaining 2 flags.

````
```yaml
input-file: pets.json
python: true
output-folder: generated/
namespace: pets
```
````

Now, all of our flags are transferred into our configuration file! We've also included this final config file in our [examples](examples/basic/readme.md)

Having a configuration file doesn't mean you aren't allowed to specify flags on the command line, however, we recommend moving all flags into the config file, and only
specifying flags on the command line if you're looking to override the values in the config file.

Your command line is now just
`autorest readme.md`

And that's it!

## Adding Tags When Generating

Say you only want certain configurations if a specific tag is included on the command line. The most common use case for this is having different versions of swagger files,
and wanting to toggle between generating both versions.

Let's start by examining what behavior we want to have when generating. The suggested way of toggling between versions on the command line is to specify a value in the `tag` flag.
Let's say we want to generate our first [pets.json](./openapi/examples/pets.json) if you specify `--tag=v1`, and we want to generate our second [petsv2.json](./openapi/examples/petsv2.json)
if `--tag=v2` is specified on the command line. Let's go about putting in the markdown code to make this possible.

Starting with the flags we wantin both cases, we add in a `yaml` code block with no condition for entry.
````
### General settings
```yaml
python: true
output-folder: generated/
```
````

In the `yaml` code blocks we have in our markdown file, we can add conditional blocks, which we only enter if a specific value is passed for a specific flag. In this case, we want our `input-file`
to be `pets.json`, if `--tag=v1` is specified on the command line, and if `--tag=v2` is specified, we want our `input-file` to be `petsv2.json`. Finally, we also want different namespaces for each
of these versions so both can be allowed to persist at the same time.

Our code block for `tag=v1` thus looks like t his
````
### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.
```yaml $(tag) == 'v1'
input-file: pets.json
namespace: pets.v1
```
````
> Note: It is highly recommended to comment your conditional `yaml` blocks with the conditions required to enter. This is because the `yaml` conditionals don't show up in rendered
markdown, so comments are needed for visibility.

Similarly, our `tag=v2` code block will look like:
````
### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.
```yaml $(tag) == 'v2'
input-file: petsv2.json
namespace: pets.v2
```
````

Finally, let us say we want `v2` to be generated by default, and `v1` only to be generating if `--tag=v1` is specified on the command line. We can add into our `General settings` `tag: v2`. This way,
unless we override the value of `tag` by specifying `--tag=v1` on the command line, `tag` will be `v2`, and we will enter that conditional `yaml` code block by default. Updating our `General settings`, we get
````
### General settings
```yaml
python: true
output-folder: generated/
tag: v2
```
````

Putting this all together, we get the [following config file](examples/tags/readme.md), and to generate v1, our command line is `autorest readme.md --tag=v1`, while generating v2, our command line
is just `autorest readme.md` since `tag`'s default value is `v2`.

## Generating in Multiple Languages

A common occurrence is wanting to generate your SDK in multiple languages. Since flags can vary across languages (i.e., certain flags are specific to certain languages), we commonly add conditional sections
for each language. In this example, we will show how to generate in both Java and Python. In situations like this, it is preferred to have one main
language agnostic configuration file titled `readme.md`, where you list the configuration you want regardless of language. Then, you create a configuration file for every language you want with the language name in the path. In this case, we would create a `readme.java.md`, and a `readme.python.md`. These configuration files will be linked to from the main `readme.md`.

Let's start with the configurations we want in the main `readme.md`. Following from the [previous example](#adding-tags-when-generating), we want to generate [pets.json](../../openapi/examples/pets.json) if `--tag=v1` is specified on the command line, and [petsv2.json](../../openapi/examples/petsv2.json) if `--tag=v2` is specified, regardless of which language we're generating in. We also need to link to our `readme.python.md` and `readme.java.md` from this main readme.

This gives us the following `readme.md`:

````
### General settings
``` yaml
tag: v2
license-header: MICROSOFT_MIT_NO_VERSION
```

### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.
```yaml $(tag) == 'v1'
input-file: pets.json
```

### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.
```yaml $(tag) == 'v2'
input-file: petsv2.json
```

## Python

See configuration in [readme.python.md](./readme.python.md)

## Java

See configuration in [readme.java.md](./readme.java.md)
````

Let's now discuss what's going to be different between the two languages.

1. Location of the output: We want our Python sdk to go into `azure-sdk-for-python`, and we want our Java sdk to go into `azure-sdk-for-java`. With Python, we use the flag `--python-sdks-folder` to indicate the location of our local [`azure-sdk-for-python`](https://github.com/Azure/azure-sdk-for-python/tree/master/sdk) clone, and for Java, we indicate the location of our local [`azure-sdk-for-java`](https://github.com/Azure/azure-sdk-for-java/tree/master/sdk) clone with the flag `--azure-libraries-for-java-folder`. This will vary based off of whether we're generating `v1` or `v2`, so we need individual conditional yaml blocks.
2. Namespace: We want our Python namespace to be `azure.pets`, while we want our Java namespace to be `com.microsoft.azure.pets`. We want different namespaces based off of whether we're generating `v1` or `v2` as well.
3. For Python, we also want to specify the name of our Python package with flag `package-name`
4. Finally, for Java, we would like our library to be `fluent`

Let's put all of this information into our Python readme, `readme.python.md`:
````
# Python
These settings apply only when `--python` is specified on the command line.

``` yaml
package-name: azure-pets
```

### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.
```yaml $(tag) == 'v1'
namespace: azure.pets.v1
output-folder: $(python-sdks-folder)/pets/azure-pets/azure/pets/v1
```

### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.
```yaml $(tag) == 'v2'
namespace: azure.pets.v2
output-folder: $(python-sdks-folder)/pets/azure-pets/azure/pets/v2
```
````

Similarly, we have our Java readme, `readme.java.md`:
````
# Java
These settings apply only when `--java` is specified on the command line.

``` yaml
fluent: true
```

### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.
```yaml $(tag) == 'v1'
namespace: com.microsoft.azure.pets.v1
output-folder: $(azure-libraries-for-java-folder)/pets/v1
```

### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.
```yaml $(tag) == 'v2'
namespace: azure.pets.v2
output-folder: $(azure-libraries-for-java-folder)/pets/v2
```
````

Now, when generating `v2` code in Python, our command line looks like
```
autorest readme.md --python --python-sdks-folder=../azure-sdk-for-python/sdk
```
while our Java command looks like
```
autorest readme.md --java --azure-libraries-for-java-folder=../azure-sdk-for-java/sdk
```
If we want to generate `v1` code in either language, all that's needed is to tack `--tag=v1` on the command line.

## Generating Management Plane Code

### azure-rest-api-specs

--track2
--azure-arm

## Advanced: Generating with Directives

## Generating MultiAPI Code

Only Python supports generating

## Index of Flags

| Flag | Description | Python | .NET | Java | TS | Go |
|------------------|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| `--input-file=FILENAME` | Adds the given file to the list of input files for generation process | x | x | x | x | x |
|`--output-folder=DIRECTORY`|The location for generated files. If not specified, uses `./generated` as the default| x | x | x | x | x |
|`--clear-output-folder`|Clear all contents from our output folder before outputting your newly generated code into that folder. Defaults to `false`.| x | x | x | x | x |
|`--add-credential`|If specified, the generated client will require a credential to make network calls. See [TODO] for information on how to authenticate to our generated clients. Forced to be `true` if `--azure-arm` is set, otherwise defaults to `false`.| x | No flag for `--add-credential`, will add credential param for a `TokenCredential` if `--azure-arm` is `true`. | No flag for `--add-credential`, gets whether to add credential from value of `--credential-types`. Defaults to false.| Is called `--add-credentials`. Defaults to false. | No flag, looks in `authenticationRequired` field in the swagger. Does not automatically set to true in azure-arm. |
|`--credential-scopes=VALUE(S)`|Specify the scopes over which the credential functions (see previous flag `--add-credential` for adding client credentials). This is tied with `BearerTokenCredentialPolicy`. If generating management plane code (see `--azure-arm` flag directly below), we default the scope to `'https://management.azure.com/.default'`. If not, we highly recommend you  use this flag if `--add-credential` is specified. If you don't generate with scopes in this case, it forces your SDK users to pass credential scopes themselves when calling your code. You can pass multiple values in using CSV format.| x | No flag for credential scopes. Currently only sets `TokenCredential` in mgmt mode. In mgmt mode's case, the credential scope is forced to `{endpoint}/.default`. In mgmt mode, this endpoint (which is gotten from the swagger), is `https://management.azure.com`| Currently doesn't default to ARM scope in mgmt mode | | `--credential-scope` |
|`--license-header=LICENSE_HEADER`|Specify the type of license header for your files. Common values include `MICROSOFT_MIT_NO_VERSION` and `MICROSOFT_MIT_NO_CODEGEN` TODO: list of all possible values and defaulot| x | x | x | x | x |
|`--namespace=NAMESPACE`|sets the namespace to use for the generated code| x | x | x | | |
|`--azure-arm`|enerates control plane (Azure Resource Manager) code. Use this if you're generate SDKs for people to manage their Azure resources. See our [previous section](#generating-management-plane-code) for more info. Defaults to `false`.| x | x | x | x | Uses flag `--openapi-type=arm` to specify |
|`--head-as-boolean`|With this flag, HEAD calls to non-existent resources (404) will not raise an error. Instead, if the resource exists, we return `true`, else `false`. Forced to be `true` if `--azure-arm` is set, otherwise defaults to `false`.| x | .NET default is always `false`. ||| Go default is always `false`. |
|`--client-side-validation`|Whether you want the SDK to perform validation on inputs and outputs, based on swagger information. Recommended to be `false` for track 2 code, since we want the network to validate instead. Defaults to `false`.| x | x | calls it `--client-side-validations` | x | x |
|`--title=NAME`|Override the service client's name listed in the swagger under `title`.| x | x | x | x | x |
|`--description=DESCRIPTION`|Override the service client's description listed in the swagger under the top level `description`.| x | x | x | x | x |
|`--package-name=NAME`|The name of your package. This is the name your package will be published under.| x | | |x | |
|`--package-version=VERSION`|The semantic versioning of your generated SDK (i.e., `1.0.0`). Not to be confused with the version of the service you're creating an SDK for. If no version is specified, AutoRest will not create a new version file. Generally not necessary if you are going to wrap the generated code before exposing to users.| Needs to be specified if `--basic-setup-py` is specified. | |Default is `1.0.0-beta.1`. Only available in `fluent` mode.|Currently can't set version for track 2| Defaults to `1.0.0`|
|`--python-sdks-folder=DIRECTORY`| The path to the root directory of your [`azure-sdk-for-python`](https://github.com/Azure/azure-sdk-for-python/tree/master/sdk) clone. Be sure to note that we include `sdk` in the folder path.| x | | | | |
|`--basic-setup-py`|Whether to generate a build script for setuptools to package your SDK. See [here](https://packaging.python.org/tutorials/packaging-projects/#creating-setup-py) for more information about a `setup.py` file. Defaults to `false`, generally not suggested if you are going to wrap the generated code before exposing to users. Nees `--package-version` to be specified.| x | | | | |
|`--trace`|Whether to natively support tracing libraries, such OpenCensus or OpenTelemetry. See this [tracing quickstart](https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/core/azure-core-tracing-opentelemetry/README.md) for an overview. Defaults to `false`.| x | | | | |
|`--multiapi`|Whether to generate a multiapi client. See [our previous section](#generating-multiapi-code) for more information. Defaults to `false`.| x | | | | |
|`--default-api=VALUE`|In the case of `--multiapi`, you can override the default service API version with this flag. If not specified, we use the latest GA service version as the default API.| x | | | | |
|`--keep-version-file`|Whether you want to override the current version file in your package or not. Defaults to `false`.| x | | | | |
|`--no-namespace-folders`|Specify if you don't want pkgutil-style namespace folders. See [here](https://packaging.python.org/guides/packaging-namespace-packages/#pkgutil-style-namespace-packages) for more information on pkgutil namespace folders. Defaults to `false`.| x | | | | |
|`--credential-default-policy-type=BearerTokenCredentialPolicy|AzureKeyCredentialPolicy`|Specify the default credential policy (authentication policy) for your client. Use in conjunction with `--add-credential`. Currently only supports [`BearerTokenCredentialPolicy`](https://azuresdkdocs.blob.core.windows.net/$web/python/azure-core/latest/azure.core.pipeline.policies.html#azure.core.pipeline.policies.BearerTokenCredentialPolicy) and [`AzureKeyCredentialPolicy`](https://azuresdkdocs.blob.core.windows.net/$web/python/azure-core/latest/azure.core.pipeline.policies.html#azure.core.pipeline.policies.AzureKeyCredentialPolicy). Default value is `BearerTokenCredentialPolicy`. `--credential-scopes` is tied with `BearerTokenCredentialPolicy`, do not pass them in if you want `AzureKeyCredentialPolicy`.| x | | | | |
|`--credential-key-header-name=NAME`|The name of the header which will pass the credential. Use if you have `--credential-default-policy-type` set to [`AzureKeyCredentialPolicy`](https://azuresdkdocs.blob.core.windows.net/$web/python/azure-core/latest/azure.core.pipeline.policies.html#azure.core.pipeline.policies.AzureKeyCredentialPolicy). For example, if generating cognitive services code, you might use `--credential-key-header-name=Ocp-Apim-Subscription-Key`.| x | | | | |
|`--library-name=NAME`|The name of your library. This is what will be displayed on NuGet.| | x| | | |
|`--shared-source-folders=VALUE(S)`|Pass shared folder paths through here. Common values point to the [shared generator assets](https://github.com/Azure/autorest.csharp/tree/feature/v3/src/assets/Generator.Shared) and [shared azure core assets](https://github.com/Azure/autorest.csharp/tree/feature/v3/src/assets/Azure.Core.Shared) in [autorest.csharp](https://github.com/Azure/autorest.csharp)| | x| | | |
|`--public-clients`|Whether to have your client public. Defaults to `false`.| | x| | | |
|`--model-namespace`|Whether to add a separate namespace of Models, more specifically adding `{value-from-namespace-flag}.Models`. Defaults to `true`.| | x| | | |
|`--azure-libraries-for-java-folder=DIRECTORY` | The path to the root directory of your [`azure-sdk-for-java`](https://github.com/Azure/azure-sdk-for-java/tree/master/sdk) clone. Be sure to note that we include `sdk` in the folder path.| | | x | | |
|`--fluent=LITE|PREMIUM`|Enables Java's fluent generator, generating a set of fluent Java interfaces for a guided and convenient user experience for the client library. Currently used by Azure management libraries. `LITE` for Fluent Lite; `PREMIUM` for Fluent Premium. Default is `PREMIUM` if provided as other values. See [the java docs](https://github.com/Azure/autorest.java#additional-settings-for-fluent) for all of the Fluent specific flags.| | | x | | |
|`--enable-xml`|Enables sending XML payloads across the wire. Defaults to `false`.| | | x| | |
|`--regenerate-pom`|Whether to regenerate the pom file in your project. See [here](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html#what-is-a-pom) for more information on what a pom file is. Defaults to `false`.| | | x | | |
|`--generate-client-as-impl`|Append "Impl" to the names of service clients and method groups and place them in the `implementation` sub-package. Defaults to `false`.| | | x | | |
|`--generate-client-interfaces`|Generates interfaces for all the "Impl"s. Forces `--generate-client-as-impl` to `true`, and generates an interface for it as well. Defaults to `false`.| | | x | | |
|`--generate-sync-async-clients`|Generates sync and async convenience layer clients for all the "Impl"s. Forces `--generate-client-as-impl` to `true`. Defaults to `false`.| | | x | | |
|`--implementation-subpackage=NAME`|The sub-package that the Service client and Method Group client implementation classes will be put into. Defaults to `implementation`.| | | x | | |
|`--models-subpackage=NAME`|The sub-package that Enums, Exceptions, and Model types will be put into. Defaults to `models`.| | | x | | |
|`--add-context-parameter`|Indicates whether the [`com.azure.core.util.Context`](https://azuresdkdocs.blob.core.windows.net/$web/java/azure-core/1.0.0/index.html?com/azure/core/util/Context.html) parameter should be included in generated proxy methods. Use if you want to pass arbitrary data (key-value pairs) to pipeline policies. Defaults to `false`.| | | x | | |
|`--context-client-method-parameter`|Indicates whether the `com.azure.core.util.Context` parameter should also be included in generated client methods. Forces `--add-context-parameter` to `true`. Defaults to `false`.| | | x | | |
|`--sync-methods=all|essential|none`|Specifies mode for generating sync wrappers. Supported values are <br>&nbsp;&nbsp;`essential` - generates only one sync returning body or header (default) <br>&nbsp;&nbsp;`all` - generates one sync method for each async method<br>&nbsp;&nbsp;`none` - does not generate any sync methods| | | x | | |
|`--required-parameter-client-methods`|Indicates whether client method overloads with only required parameters should be generated. Defaults to `false`.| | | x | | |
|`--custom-types-subpackage=VALUE`|The sub-package that the custom types should be generated in. The types that custom types reference, or inherit from will also be automatically moved to this sub-package. **Recommended usage**: You can set this value to `models` and set `--models-subpackage=implementation.models`to generate models to `implementation.models` by default and pick specific models to be public through `--custom-types`.| | | x | | |
|`--custom-types=VALUE(S)`|Specifies a list of files to put in the package specified in `--custom-types-subpackage`. You can pass multiple values in using CSV format.| | | x | | |
|`--client-type-prefix=PREFIX`|The prefix that will be added to each generated client type.| | | x | | |
|`--model-override-setter-from-superclass`|Indicates whether to override the superclass setter method in model. Defaults to `false`.| | | x | | |
|`--non-null-annotations`|Whether or not to add the `@NotNull` annotation to required parameters in client methods. Defaults to `false`.| | | x | | |
|`--client-logger`|Whether the client should log by default. Defaults to `false`.| | | x | | |
|`--required-fields-as-ctor-args`|Whether an object's required fields should be specified as arguments to its constructor. Defaults to `false`.| | | x | | |
|`--service-interface-as-public`|Whether the service's interface should be set as public. Defaults to `false`.| | | x | | |
|`--artifact-id`|The name of your project jar without its version. See [here](https://maven.apache.org/guides/mini/guide-naming-conventions.html) for more information about an artifact id.| | | x | | |
|`--credential-types=TokenCredential|AzureKeyCredential|None`|The type of credential if `--add-credential` is specified. Defaults to `None`.| | | x | | |
|`--customization-jar-path=FILEPATH`|Pass in the path to your .jar file that contains customizations to the output files. This will allow AutoRest to dynamically load the class you provide in `--customization-class`.| | | x | | |
|`--customization-class=NAME`|Use in conjunction with `--customization-jar-path`. That flag tells AutoRest where to look for your custom class, while `--customization-class` tells AutoRest the name of your custom class.| | | x | | |
|`--model-override-setter-from-superclass`|TODO: ask weidong about this. Defaults to `false`.| | | x | | |
|`--source-code-folder-path=DIRECTORY`|Where to output the generated code inside the `output-folder`. Use in the scenario when you are goign to write a convenience layer on top of the generated code. Defaults to `src`.| | || x| |
|`--generate-metadata`|Whether to generate extra metadata in your package. For instance, generates a README file, license file etc if set to `true`. Defaults to `false`.| | | | x| |
|`--tracing-info=TRACING_OBJECT`|Information needed to conduct tracing. If passed, it requires two properties: `namespace` and `packagePrefix`. Alternatively, you can specify the following two flags.| | | | x| |
|`--tracing-info.namespace=NAME`|The namespace for tracing.| | | | x| |
|`--tracing-info.packagePrefix=NAME`|The package prefix information needed to conduct tracing.| | | | x| |
|`--module`|The name of the module. This is the name your module will be published under.| | | | |x |
|`--file-prefix=PREFIX`|Optional prefix to file names. For example, if you set your file prefix to "zzz", all generated code files will begin with "zzz".| | | | |x |
|`--openapi-type=arm|data-plane`|Specify if you want to generate `data-plane` code or `arm` code.| | | | |x |
|`--armcore-connection`|If set to `true`, we output the code with the `Connection` type specified in [`armcore`](https://github.com/Azure/azure-sdk-for-go/blob/master/sdk/armcore/connection.go). If not, we output a new `Connection` constructor with the generated code. Defaults to `false`.| | | | |x |


## I'm Curious: How does AutoRest Actually Generate Code From an OpenAPI Definition?

See [here](./how-autorest-generates-code-from-openapi.md)

## Troubleshooting