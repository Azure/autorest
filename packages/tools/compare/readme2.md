# AutoRest Compare

`autorest-compare` provides a regression testing tool which can compare the
output of two AutoRest runs to determine whether there are any material changes
to the generated source for a given service spec.  Comparisons can be made between:

- Versions of the AutoRest CLI (v2 versus v3)
- Versions of AutoRest Core
- Versions of the AutoRest modeler
- Versions of a language generator

The primary use case for this tool is to determine whether changes to the
[AutoRest v3 modeler](https://github.com/Azure/autorest.modelerfour) have
changed the output of the various language generators in undesirable ways.

## Installation

This tool is written for Node.js [Node.js](https://nodejs.org/en/), so make sure
to have that installed before continuing (we recommend 10.16.x LTS).

With Node.js installed, you can install `autorest-compare` by running the
following command:

```shell
npm install -g @autorest/compare
```

If you'd prefer not to install this tool globally, you can use the following
command to invoke it with [`npx`] on a one-shot basis:

```
npx @autorest/compare [arguments]
```

**NOTE:** Some dependencies contain native code components that need to be
compiled before they can be used so you'll need to have the appropriate C
compiler and Python 2.7/3.5 or greater installed on your machine before using
this tool.

### Windows

If you don't already have Python and the MS Visual Studio C++ compiler tools
installed, you can easily install them with the following command:

```shell
npm install --global windows-build-tools
```

### Linux

Install gcc and  . For Debian/Ubuntu, the following command should work:

```shell
sudo apt-get install build-essential python
```

### macOS

On macOS, Python should be installed by default.  The C/C++ compiler can be
installed with XCode by running the following command:

```shell
xcode-select --install
```

## Running `autorest-compare`

Running `autorest-compare --help` will display the list of arguments you might
wish to use.  Specific usage scenarios are described in the following sections.

* Comparing the Python output between two versions of `@autorest/modelerfour`:

  ```shell
  autorest-compare --compare --language:python --spec-path:path/to/spec.json \
    --output-path:path/to/output \
    --old-args --use:@autorest/modelerfour@4.1.59 \
    --new-args --use:@autorest/modelerfour@4.1.60
  ```

* Comparing the TypeScript output of generating a set of specs in the
  `azure-rest-api-specs` repository between AutoRest v2 and AutoRest v3:

  ```shell
  autorest-compare --compare --language:typescript \
    --spec-root-path:../path/to/azure-rest-api-specs/specifications \
    --spec-path:redis/resource-manager \
    --spec-path:keyvault/resource-manager \
    --output-path:path/to/output \
    --old-args --version:^2.0.0 \
    --new-args --version:3.0.6179
  ```

  Note that the `--spec-path` parameter can be passed multiple times to include
  multiple specs in a single run.

## How it Works

> TODO: Fill this in.


# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
