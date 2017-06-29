# Literate Configuration 

## About the Literate file formats
The literate configuration format is a [CommonMark](http://spec.commonmark.org/) document that has embedded code 
blocks for machine readable sections. This encourages easy-to-author documentation while permitting the specificity 
desired when authoring and processing instructions.

### Notable Features

- Choose a specific version (or a valid range?) of AutoRest to run (discovery/acquring when necessary.)
- Specifiy the swagger files that it applies to.

### Continutity with pre-existing AutoRest scripts 

Passing settings on the command line will be continue to be supported for continutity, the
preference going forward would be to build an accompanying file to drive the execution.

The implementation of the command line will be to translate the existing command-line-parameters into 
an in-memory configuration document and feed that to the configuration processing system to ensure 
that the rest of the system doesn't require any extra effort to process.

## The File Format

The Literate configuration file is a CommonMark (aka Markdown) file that has code blocks. 

If the configuration file is actually named `Readme.md` it serves dual-purpose as both the documentation that 
a user sees in github where instructuions for use can be, as well as the storage for configuration information.

A configuration file should also _document_ how to use the configuration file, without assuming that the user knows
how to use any of the tools required.

> Example: a configuration `readme.md` that starts off with instructions on how to use it.

> ~~~ markdown
> # My API 
> 
> ## Getting Started 
> To build the SDKs for My API, simply [Install AutoRest](#Installing-AutoRest) and run:
> > `Autorest.exe readme.md`
> 
> To see additional help and options, run:
> > `Autorest.exe help readme.md`
> 
> ### Installing AutoRest
> AutoRest is most easily installed via the Node JS package `autorest`:
> > npm install -g autorest 
> 
> For other options on installation see [Installing AutoRest](https://aka.ms/installing-autorest.md) on the AutoRest github page.
> 
> ## AutoRest configuration ...
> ``` yaml
> autorest: 
>   minimum-version: 1.0 # specify the version of Autorest to use
>   # (more settings here...)
> ```
> ~~~


### Configuration element conventions

- all elements should be lower-case, singular tense, and use dashes to separate words. ie:

``` yaml
# not 'inputs'
input-file: foo.yaml

base-folder: c:/output/folder
```

- elements should be parsed to take either a single value, or an an array of values where possible, AutoRest should figure out what to do.

``` yaml
# specify a single swagger file
input-file: foo.swagger.yaml

# specify a set of swagger files 
input-file:
  - foo.swagger.yaml
  - bar.swagger.yaml
```

- all elements should try to follow the `purpose-noun` style for compound element names:

``` yaml
output-folder: c:/my/output/folder
log-file: c:/my/output/logs.txt
```

- In order to decrease ambiguity, we shall have a list of preferred purposes and nouns that should be used if possible. In the case of a new purpose or noun, new ones should be considered and added to the master list.

> *Purposes*
> ``` yaml
> folder: Used to specify one or more directory, folder, file container 
> file: used for one or more files 
> ```

> *Nouns*
> 

### Extending syntax thru meta variables

An r-value can specify the use of a `$` to prefix to indicate a value that is resolved at evaluation time.
This introduces the use of a *meta-variables* that the user can use to make paths relative, find nodes in the Swagger DOM, or accept values from the command line.

There are two basic formats for meta-variable resolution

#### Straight value replacement 
Straight value replacement is a simple substitution of the target value. The format is: `$(VARIABLE-NAME)` where the `VARIABLE-NAME` is a meta-variable or value from the current literate document.

``` yaml
output-folder: "$(base-folder)/Generated" # relative to this file's actual location.
log-folder: "$(output-folder)/logs" # relative to the output folder specified above.
```

##### Ideas for some *S-R-V* Meta-variables
- `$(base-folder)` - the full path to the directory (or partial URL) that contains this file   
   ideally, this should be the same as saying `.` (ie, `include-file: ./foo.json`)
- `$(current-directory)` - the full path to the current directory when AutoRest was run
- `$(random-number)` - a random number?  
- `$(output-folder)` - the current value of the output folder (after all the layers of settings have been applied)

##### Setting the value of a meta-variable from the host environment
You can set (override) a value for a meta-variable in the host environment (cmdline, VSCode Extension, CI system, etc)

|Environment|Setting|Description|
|-----------|-------|-----------|
| via cmdline | `-some-value=true` | sets the `$(some-value)` meta variable to `true` |
| via VSCode | (via UI) |in the VSCode UI, a setting can be set via a property by a value in the editor preferences, or via the UI (like a toggle, etc) <br>As the VSCode exensibility improves to support custom UI, this can be enhanced further.
| via CI (environment?) | `$env:autorest-some-variable = true` | environment variables prefixed with `autorest-` are implicity added as metavariables|

> Idle thought:
> Should we support direct environment variable references in Literate Configuration?
> 
> ie, `$(env:TMP)` to could resolve to the environment variable `TMP`

##### Additional Uses of Meta-variables

In addition to simple **macro-value** replacement, meta-variables can be used to control the evaluation of a code-block in a document. For example, take this literate document:

~~~ markdown
## Debug Version
When the `$(some-value)` is set to `true`, this section will be activated.

``` yaml enabled=$(some-value)
output-folder: "$(base-folder)/Generated/Debug"
log-folder: "$(output-folder)/logs" 
log-level: debug
```
~~~

In the above case, the `some-value` meta-variable would have to evaluate to `true` before that codeblock would be included in the configuration.

From the command-line, this would look like:

> `AutoRest.exe readme.md -some-value=true`

#### JSONPath document reference

[JSONPath](http://goessner.net/articles/JsonPath/) will be used to reference nodes in the swagger document object model.

JSONPath is similar to XPath, but is designed for JSON (and YAML) documents. This will be used in conjunction with the [Swagger DOM Query Format](#Swagger-DOM-Query-Format) 

> ### Excerpted from the [JSONPath website](http://goessner.net/articles/JsonPath/)
>
> JSONPath expressions always refer to a JSON structure in the same way as XPath expression are used in combination with an XML document. Since a JSON structure is usually anonymous and doesn't necessarily have a "root member object" JSONPath assumes the abstract name $ assigned to the outer level object.
>
>JSONPath expressions can use the dot–notation
>
>`$.store.book[0].title`
>
>or the bracket–notation
>
>`$['store']['book'][0]['title']`
>
>for input pathes. Internal or output pathes will always be converted to the more general bracket–notation.
>
>JSONPath allows the wildcard symbol * for member names and array indices. It borrows the descendant operator '..' from E4X and the array slice syntax proposal [start:end:step] from ECMASCRIPT 4.
>
>Expressions of the underlying scripting language (`<expr>`) can be used as an alternative to explicit names or indices as in
>
> `$.store.book[(@.length-1)].title`
>
>using the symbol '@' for the current object. Filter expressions are supported via the syntax ?(<boolean expr>) as in
>
>`$.store.book[?(@.price < 10)].title`
>
>Here is a complete overview and a side by side comparison of the JSONPath syntax elements with its XPath counterparts.
>
>|XPath|JSONPath|Description|
>|-----|--------|-----------|
>| `/` |	`$`  |the root object/element|
>| `.`	| `@`	 | the current object/element|
>| `/` |	`.` or `[]` | child operator|
>|`..`	| n/a	|parent operator|
>|`//`	|`..`	|recursive descent. JSONPath borrows this syntax from E4X.|
>|`*`|	`*`|	wildcard. All objects/elements regardless their names.|
>|`@`|	n/a|	attribute access. JSON structures don't have attributes.|
>|`[]`|`[]`|	subscript operator. XPath uses it to iterate over element collections and for predicates. In Javascript and JSON it is the native array operator.|
>| `|`|`[,]`|Union operator in XPath results in a combination of node sets. JSONPath allows alternate names or array indices as a set.|
>|n/a|	`[start:end:step]`|	array slice operator borrowed from ES4.|
>|`[]`	|`?()`|	applies a filter (script) expression.|
>|n/a	|`()`|	script expression, using the underlying script engine.|
>|`()`	|n/a	|grouping in XPath|

Among the many virtues of JSONPath, an expression can be virtually exactly as you'd expect to identify a specific node with JSON, ie:

``` yaml
# specifically refers to a single node in the Swagger DOM
# #/definitions/fooresource/properties/properties/provisioningState
some-node: $definitions.fooresource.properties.properties.provisioningState
```

Or you can use a more complex expression to identify a collection of nodes:

``` yaml
# selects all nodes in the 'paths' collection that have an node that has a property 'operationId' where the value starts with 'blob_'
some-nodes: $..paths[($..operationId["blob_*"])]
```

The applicability of the selected nodes is explained further in the section [Swagger DOM Query Format](#Swagger-DOM-Query-Format) 

## The Swagger DOM

AutoRest has traditionally supported two 'modeler' implementations. The `swagger` modeler, which accepts a single swagger document, and a `composite` modeler that merges multiple swagger documents into a single DOM. The `composite` modeler suffers from a few unfortunate design limitations, and we will phase it's use out in favor of a more natural multi-document approach in AutoRest.

In the configuration file, you can specify the list of swagger documents that you wish to include.

``` yaml
input-file: 
  - ./2015-01-02/swagger/foo.json   # referenced documents can be JSON, YAML or Markdown. 
  - ./2016-02-03/swagger/bar.md     
```

Once a file is loaded, it's never referred to in configuration by it's file name (which may be arbitrary, auto-generated , or even non-existent), but instead by it's Swagger `title` value. (You can think of this as the `namespace` for the swagger document)

> _Idle thought:_
>
> The impact/difference regarding multiple documents with a single namespace? 
> The assumption is that those would be merged early in the document parsing phase as if the content were in the exact same file, and would be indistinguishable at that point.
> 
> When the documents each have a different `namespace`, the nodes can be referred to seperately, even if the final output of AutoRest is a single, merged SDK.

## Configuration sections

The general layout of the Literate Configuration DOM is :

### Settings 
Settings are top-level key-value pairs that AutoRest uses to create the Literate Swagger DOM and control the pipeline.

These generally include the things that have been traditionally passed on the cmdline. Ie:

``` yaml
namespace: MyApp.MyNameSpace
modeler : default # options are 'default' or 'composite' 
output-folder : ./Generated
azure-arm: true # 'azure-arm' is a declaration that the swagger is an Azure arm resource (not specified as part of the generator name.)
input-file:
  - swagger/MySpec.json
  - swagger/MySpec2.json
```

### Per-language Settings
At the top-level of the Literate Configuration document, you may also specify a language, which performs two things:

- includes that language generator as a language target in the pipeline.
- allows specifying/overriding settings on a per-language basis.

``` yaml
csharp: # just having a 'csharp' node enables the use of the csharp generator.
  namespace: Microsoft.MyApp.MyNameSpace #override the namespace 
  output-folder : $(output-folder)/csharp # relative to the global value.

ruby: 
  namespace: Microsoft::Azure::MyApp::MyNameSpace # another alternative
  output-folder : $(output-folder)/ruby/sdk # relative to the global value.
```

### Swagger DOM Query Format
In order to make it possible to remove most of the AutoRest-specific extensions from
the Swagger DOM, it is necessary to be able to refer to one or more nodes in the 
swagger document and apply options to those nodes.

#### Querying the swagger DOM.

In order to accurately query nodes in the Swagger DOM for a specific set, we have a JSON/YAML object that is used to specify what we're looking for.

The query is basically two things: the list of swagger documents and the nodes inside of those documents:

``` yaml
from: <swagger-document-selection> # based on swagger namespaces (aka, the swagger 'title')
where: <json-path-query>           # a JSONPath expression to select the nodes in the swagger DOM
```

If the `from` isn't set, the default is to apply the directive to all the Literate Swagger DOMs

If the `where` isn't set, the default is to apply the directive to all the nodes in the selected Literate Swagger DOMs


### Directives - global or per-language

Directives are nodes that change generation **behavior** based on the selection of a set of nodes in the Swagger DOM. See  [Swagger DOM Query Format](#Swagger-DOM-Query-Format)

Directives are specified as a collection of `directive` objects fall under the `directive:` setting.

A `directive` object appears as follows:

``` yaml
from: <swagger-document-selection> # based on swagger namespaces
where: <json-path-query>           # a JSONPath expression to select the nodes in the swagger DOM
set: <object>                      # an object that has a series of key-value settings to apply to the selected nodes.
<other-directive-targets> : <*>    # other directives that don't set properties on the node, but rather are directed towards parts of autorest.
```

If the `from` isn't set, the default is to apply the directive to all the Literate Swagger DOMs

If the `where` isn't set, the default is to apply the directive to all the nodes in the selected Literate Swagger DOMs

> Example: overriding a `method-group` name 

``` yaml
directive: # an array of directive objects
  - from: My Spec # specify a specific document 'namespace' (aka title)
    where: $..[@operationId="blob_*"]
    set:
      method-group: Blobber # override the method-group for a given set of operations matching blob_*
  
csharp:
  directive:
    # change blob method group name to AzureBlob
    - from: My Spec # specify a specific document 'namespace' (aka title)
      where: $..[@operationId="blob_*"]
      set:
        method-group: AzureBlob # per-language (csharp) override for method-group name

    # change 
    - from: My Spec # specify a specific document 'namespace' (aka title)
      where: $..[@operationId="glob_*_*"] # take nodes where it has more than one underscore
      transform: 
        - mytransformer
```

``` js transformer=mytransformer
// assume that the nodes are given as a collection of nodes.
for( nodename in nodes ) {
  nodes[nodename].methodgroup = nodes[nodename].methodgroup.replace(/(glob_.*)_(.*)/ig,'AzureGlob_$1');
}

// return the nodes to the colllection.
return nodes;
```


> Example: disabling a validation for a couple of docs

``` yaml
directive: 
  - from: # specify multiple document 'namespace's (aka title)
      - My API
      - SomeOther API
    suppress:
      - VE1025 # codes for validation suppression
      - VE1104   
```

> Example: applying `x-ms` Swagger Extensions to the DOM:

``` yaml
directive:
  - where: definitions.myobject.properties.foo
    set:
      client-flatten: true    # you can omit the x-ms prefix, it's ok, we'll figure it out.
      x-ms-client-name: HELLO # or you can specify the x-ms prefix. 
      enum:
        name: MyEnum
        modelAsString: false
```

In this example, rather than specifying the information in the swagger file (because it doesn't affect the wire data) we specify the extension usage as directives for code generation.


## AutoRest Settings 

The collection of AutoRest settings that is currently available on the command line can be expressed in Literate Configuration.

#### Important additions: 
The notion of the version/minimum/maximum version to use of AutoRest. The purpose of this is to get to the point where you don't have to ever actively install a given version of AutoRest. 
Instead, you install any version of AutoRest that supports Literate Configuration, and if the configuration calls for a different version of AutoRest, we download and install AutoRest into a version-specific folder (in say `$env:AppData`...) and pass thru the work to that version.

Then, once you've installed AutoRest, you can use any arbitrary version by just specifying it.


#### Any-language settings

|Setting|Example|Purpose|
|-------|-------|-------|
|version|`version: 1.0.0-Nightly20170107` | Specify a specific version of AutoRest to use for the code generation (try to use `minimum-version` and `maximum-version` if possible) |
|minium-version|`version: 1.0` | Specify a minimum version of AutoRest to use for the code generation |
|maximum-version|`version: 1.999` | Specify a maximum version of AutoRest to use for the code generation |
|azure|`azure-arm:true` | specifies that that the generation is designed to create an Azure Resource Manager SDK |
|add-credentials| `add-credentials: true` | If true, the generated client includes a ServiceClientCredentials property and constructor parameter. Authentication behaviors are implemented by extending the ServiceClientCredentials type.|
|client-name| `client-name: MyClient ` |  Name to use for the generated client type. By default, uses the value of the 'Title' field from the Swagger input. |
|generation-mode| `generation-mode: ['rest-client', 'rest-server'] `| The code generation mode. Possible values: rest, rest-client, rest-server. Determines whether AutoRest generates the client or server side code for given spec.|
|header-text| `header-text: MIT` | Text to include as a header comment in generated files. Use NONE to suppress the default header. |
|input-file| `input-file: foo.json` | The location of the input specification. |
|modeler| `modeler: composite` |  The Modeler to use on the input. If not specified, defaults to Swagger.|
|models-name|`models-name: foo` |  Name to use for the generated client models namespace and folder name. Not supported by all code generators. |
|namespace|`namespace:Microsoft.Azure.MyLib`| The namespace to use for generated code.|
|output-folder| `output-folder: c:/output` | The location for generated files. If not specified, uses "Generated" as the default. |
|output-file| `output-file: foo.cs` | If set, will cause generated code to be output to a single file. Not supported by all code generators.|
|package-name|`package-name: somePackage`| Package name of then generated code package. Should be then names wanted for the package in then package manager. |
|package-version|`package-version: 1.0.5`| Package version of then generated code package. Should be then version wanted for the package in then package manager.|
|payload-flatteningthreshold|`payload-flatteningthreshold: 2`| The maximum number of properties in the request body. If the number of properties in the request body is less than or equal to this value, these properties will be represented as method arguments. |

#### CSharp Settings
|Setting|Example|Purpose|
|-------|-------|-------|
|disable-simplifier| `disable-simplfier:true` | Disables c# post-codegeneration simplifier|
|internal-constructors| `internal-constructors: true` | Indicates whether ctor needs to be generated with internal protection level. |
|sync-methods| `sync-methods: true `| Specifies mode for generating sync wrappers. |
|use-date-time-offset| `use-date-time-offset: true` | Indicates whether to use DateTimeOffset instead of DateTime to model date-time types |

#### NodeJS Settings:
|Setting|Example|Purpose|
|-------|-------|-------|
|disable-typescript|`disable-typescript: true` | Disables TypeScript generation. |

