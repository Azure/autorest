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

First step is to create our configuration file. The preferred name for a configuration file is `README.md`, so you may hear these terms interchangeably.

Once your configuration file is created, we can work on moving our flags into the config file. We tell AutoRest what flags we want using `yaml` code chunks in the
README.

The preferred name for a configuration file is `README.md`, so these terms might be used interchangeably. With your configuration file,
the command line is simplified to
> `autorest [path to your config-file.md] [optional flags to override the configuration in your config file]`

Bonus: if you aren't overriding your configuration, your config file name is `README.md`, and you are calling AutoRest in the same directory
level as your config file resides, your AutoRest command boils down to...
> `autorest`

And that's it!

## Adding Tags When Generating

## Generating in Multiple Languages

## Generating Management Plane Code

### azure-rest-api-specs

--track2
--azure-arm

## Advanced: Generating with Directives

## Generating MultiAPI Code

## Index of Flags

| Flag | Description | Python | .NET | Java | TS | Go | Swift |
|------------------|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| `--input-file=FILENAME` | Adds the given file to the list of input files for generation process | x | x | x | x | x | x |
|`--output-folder=DIRECTORY`|The location for generated files. If not specified, uses `./Generated` as the default| x | x | x | x | x | x |
|`--clear-output-folder`|Clear all contents from our output folder before outputting your newly generated code into that folder| x | x | x | x | x | x |
|`--namespace=NAMESPACE`|sets the namespace to use for the generated code| x | x | x | x | x | x |
|`--add-credential`|If specified, the generated client will require a credential to make network calls. See [TODO] for information on how to authenticate to our generated clients| x | x | x | x | x | x |
|`--azure-arm`|Generate code tailor-made for management plane. See our [previous section](#generating-management-plane-code) for more info| x | x | x | x | x | x |
|`--license-header`|Generate code tailor-made for management plane. See our [previous section](#generating-management-plane-code) for more info| x | x | x | x | x | x |
| `--python-sdks-folder=DIRECTORY` | The path to the root directory of your [`azure-sdk-for-python`](https://github.com/Azure/azure-sdk-for-python/tree/master/sdk) clone. | x | | | | | |

## I'm Curious: How does AutoRest Actually Generate Code From an OpenAPI Definition?

See [here](./how-autorest-generates-code-from-openapi.md)

## Troubleshooting