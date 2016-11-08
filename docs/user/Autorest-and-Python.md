This page explains how to use Autorest to generate Python code from a Swagger file.

# Autorest availability

Autorest release can be found on Nuget: https://www.myget.org/gallery/autorest

Source code is on Github: https://github.com/Azure/autorest/

For Python, I currently suggest the nightly build.

## Ubuntu 

Add repo from here
http://www.mono-project.com/docs/getting-started/install/linux

    sudo apt-get install mono-complete

DNVM/DNX is not needed to execute Autorest for Python.

# Autorest options

Typical command line to generate Python is:
```bash
AutoRest.exe -i swagger.json -g Python
```

The following sections describe the available options and how this impact the Python code.

## CodeGenerator / g
Specify the code generator to use. For Python, there is two generators `Python` and `Azure.Python`. `Azure.Python` should not be used for something else than Azure ARM RestAPI.

## AddCredentials
Use this parameter if your RestApi requires authentication to add the necessary classes in your `__init__` methods:

    -AddCredentials true

## ClientName / name
Will change the name of the client class to instantiate:

     -name Foo

will implies python code:
```python
client = Foo(credentials, parameters)
```

## Header
Change the license information at the beginning of the generated file. Usual predefined value is MICROSOFT_MIT_NO_VERSION:

    -Header MICROSOFT_MIT_NO_VERSION

## Input / i
The Swagger file to generate

## Namespace / n
The package where you plan to put the code, used *only* for cross-reference in the Docstring (i.e. no code difference). For instance, if you plan to release the generated code under the foo.bar package, use `-n foo.bar` to have correct Docstring content:
```python
:rtype: :class:`UsagePaged <foo.bar.models.UsagePaged>`
```

Autorest Python does *not* create recursive packages. If your namespace is more by one level, you will have the manually creates the intermediary sub-packages.

## Modeler
Allows to merge several Swagger files into one client. If you want to do that, you have to call with:
```
-m Composite
```
And to give in input a file like this:
```json
{
  "info": {
    "title": "ComputeManagementClient",
    "description": "Composite Swagger for Compute Client"
  },
  "documents": [
    "./arm-compute/2016-03-30/swagger/compute.json",
    "./arm-compute/2016-03-30/swagger/containerService.json"
  ]
}
```

## OutputDirectory / o
By default generates into the "Generated" folder in the current directory.

## OutputFileName
Not supported by any Python extensions. Will fail the call to Autorest.

## PackageName / pn
Not supported by any Python extensions. Will be ignored silently.

## PackageVersion / pv
Change the `__version__` attribute of the generated package and the `setup.py`. This is also used inside the UserAgent. This is *NOT* sent to the RestApi as parameter or something else.

## PayloadFlatteningThreshold / ft

In case your RestApi needs a complex payload, this tells Autorest to flatten parameters in the method signature instead of create a complex class.

This parameter is actually a threshold based of the number of parameters. If `ft` is a high value, your method signature will grow in number of parameters. If `ft` is low, you will have a complex class (or a dict) to instantiate even for one parameter only.

Typical value is 2.

# Mainteners

@lmazuel @annatisch