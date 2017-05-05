# Scenario: Common settings available

> see https://aka.ms/autorest

## Standard

The following settings have already been introduced in previous examples and are the starting point of this example

``` yaml 
input-file: https://github.com/Azure/azure-rest-api-specs/blob/master/arm-storage/2015-06-15/swagger/storage.json
csharp:
  output-folder: Client
output-artifact: swagger-document.json
```

## Settings

### Base Folder

If the configuration file doesn't sit where the input files are or where the output is supposed to go, it can make sense to tell AutoRest "interpret *every path* relative to XY".
In this case, we wanna put *all* artifacts under a folder "base/folder" (this is a relative path, but absolute paths are supported as well).

``` yaml
base-folder: base/folder
```

In practice, the base folder affects all relative paths specified in this configuration file.
Since the input file in this particular example is absolute (`http` URL), it is hence unaffected.
The output folder of C# generation on the other hand is affected.
Furthermore, the implicit output folder of the `output-artifacts` is affected.
Literally all relative file access takes the base folder into account.

### Namespace

Some generators allow setting/overwriting the namespace (should the concept of "namespaces" exist) used for the generated client.

``` yaml
namespace: AwesomeNamespace
```

### License Header

AutoRest allows specifying a license header prepended to all generated source files.
There are also predefined ones that are accessible using special strings:

``` yaml
license-header: >-
  This is my custom license header.
  I am a nice person so please don't steal my code.


  Cheers.
```

Usage of a predefined header can be found below.

### Plugin Specific Settings

Some settings are specific to plugins, such as:
- `add-credentials` which adds a `Credentials` property to C# Azure clients
- `sync-methods` which allows specifying whether synchronous wrappers for asynchronous methods should be generated (discouraged!)
- `payload-flattening-threshold` which controls whether a body parameter should be passed directly (as an argument to the generated method) or whether its properties should be passed as arguments. As the latter option makes sense for body parameter types with few properties (less overhead for `new`ing), this setting is a threshold specifying when to use which option.
- `client-side-validation` which controls whether or not client side validation of constrains such as `minLength`, `maximum` or `pattern` is desired

``` yaml
csharp:
  - output-folder: AzureClient
    azure-arm: true
    add-credentials: true # generates `Credentials` property
    license-header: MICROSOFT_MIT # override the `license-header` defined at the top level. (see above)
    sync-methods: none # other possible values: essential, all
    payload-flattening-threshold: 3 # body parameter types with 3 or less properties cause method to expect those properties instead of an object 
    client-side-validation: false # disable client side validation
```