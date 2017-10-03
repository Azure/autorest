# AutoRest Command Line Interface Documentation

## AutoRest

The AutoRest command line has been vastly simplified, with the preference to move things that were on the command line into a configuration file, with the ability to override the configuration file settings from the command line.

### Command-line Usage

> `autorest [config-file.md] [additional options]`

### Configuration file

AutoRest will use a [configuration file](literate-file-formats/configuration.md) to control the code generation process. By default, AutoRest will look for a file called `readmd.md` or it can be passed on the command line. 

This is the preferred method, instead of passing all the information on the command line. 

If you prefer to name your configuration file something else, you can supply the filename on the command line:

``` bash
autorest my_config.md 
```

#### Passing additional options on the command line.

It is possible to override settings from the configuration file on the command line by prefacing the value with double dash (`--`) and setting the value with an equals sign (`=`). Ie:

``` bash
autorest --input-file=myfile.json --output-folder=./generated/code/ --namespace=foo.bar
```

### Common Command-line Options 

#### Output Verbosity

| Option | Description |
|--------|-------------|
|`--verbose`|show verbose output information|
|`--debug`|show internal debug information|
|`--quiet`|suppress output|

#### Managing the installed/used AutoRest version

|Option                              &nbsp;| Description |
|------------------|-------------|
|`--list-installed`|show all installed versions of AutoRest tools|
|`--list-available=nn`|lists the last nn releases available from github (defaults to 10)|
|`--version=version`|uses version of AutoRest (installing if necessary.)<br>For version you can use a version label (see --list-available) or<br>&nbsp;&nbsp;`latest` - get latest nightly build<br>&nbsp;&nbsp;`latest-release` - get latest release version|
|`--reset`|remove all installed versions of AutoRest tools and install the latest (override with --version)|
|`--runtime-id=id`|overrides the platform detection for the dotnet runtime (special case). Refer to the <a href="https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog">Runtime Identifier (RID) catalog</a> for more details.|

#### Commonly used Settings
|Option                                                                &nbsp;| Description |
|------------------|-------------|
|`--input-file=FILENAME`|Adds the given file to the list of input files for generation process|
|`--output-folder=DIRECTORY`|The location for generated files. If not specified, uses `./Generated` as the default|
|`--namespace=NAMESPACE`|sets the namespace to use for the generated code|
|`--license-header\|licence-header=HEADER`| Text to include as a header comment in generated files. Use NONE to suppress the default header.|
|`--add-credentials`|If specified, the generated client includes a ServiceClientCredentials property and constructor parameter. Authentication behaviors are implemented by extending the ServiceClientCredentials type.|
|`--package-name=PACKAGENAME`|Name of the package (Ruby, Python)|
|`--package-version=VERSION`|Version of the package (Ruby, Python)|
|`--sync-methods=all\|essential\|none`|Specifies mode for generating sync wrappers. Supported value are <br>&nbsp;&nbsp;`essential` - generates only one sync returning body or header (default) <br>&nbsp;&nbsp;`all` - generates one sync method for each async method<br>&nbsp;&nbsp;`none` - does not generate any sync methods|
|`--payload-flattening-threshold=NUMBER`|The maximum number of properties in the request body. If the number of properties in the request body is less than or equal to this value, these properties will be represented as method arguments|
|`--override-client-name=NAME`|Name to use for the generated client type. By default, uses the value of the 'Title' field from the input files|
|`--use-internal-constructors`|Indicates whether ctor needs to be generated with `internal` protection level.|
|`--use-datetimeoffset`|Indicates whether to use DateTimeOffset instead of DateTime to model date-time types|
|`--models-name=NAME`|Name to use for the generated client models namespace and folder name. By default, uses the value of 'Models'. This is not currently supported by all code generators.|
|`--output-file=FILENAME`|If set, will cause generated code to be output to a single file. Not supported by all code generators.|

#### Authentication

AutoRest supports generating from private GitHub repositories.
There are multiple options:

1) **Using the `token` query parameter**: Pass the `token` query parameter you get when clicking "Raw" on a file of a private repo, i.e. `https://github.com/<path-on-some-private-repo>/readme.md?token=<token>`.
When such a URI is passed to AutoRest, it will automatically reuse that token for subsequent requests (e.g. querying referenced OpenAPI definitions).
This is a quick and easy solution if you manually want to run AutoRest against private bits from time to time.
2) **Using OAuth**: GitHub allows generating OAuth tokens under `Settings -> Personal access tokens`.
Create one with `repo` scope.
It can be passed to AutoRest using `--github-auth-token=<token>` or by setting the environment variable `GITHUB_AUTH_TOKEN`.
This is the way to go for all scripts and automation.
Needless to say, *do not put this token* into scripts directly, use Azure KeyVault or similar.

#### Validation
|Option                                                                &nbsp;| Description |
|------------------|-------------|
|`--azure-validator`|If set, runs the Azure specific validator plugin.|
|`--openapi-type=arm│default│data-plane`|Indicates the type of configuration file being passed to the `azure-validator` so that it can run the appropriate class of validation rules accordingly.|
|`--model-validator`|If set, validates the provided OpenAPI definition(s) against provided `examples`.|
|`--semantic-validator`|If set, semantically verifies the provided OpenAPI definition(s), e.g. checks that a parameter's specified `default` value matches the parameter's declared type.|

Also, see [Samples/2a-validation](../../Samples/2a-validation) for an example of validation using a configuration file.

#### Selecting the Language with which to generate code

|Option                              &nbsp;| Description |
|------------------|-------------|
|`--csharp`|Runs the C# code generator|
|`--nodejs`|Runs the nodejs javascript code generator|
|`--python`|Runs the python code generator|
|`--java`|Runs the java code generator|
|`--ruby`|Runs the ruby code generator|
|`--go`|Runs the go code generator|
|`--azureresourceschema`|Runs the AzureResourceSchema|
| &nbsp; | |
|`--azure-arm`|Uses the `Azure` version of the specified code generator|

You may generate one or more languages in a given invocation, ie:

`autorest --csharp --python --ruby`

To set a language-specific setting, prefix the setting with the language, ie:

`autorest --csharp.namespace=Foo.Bar `
