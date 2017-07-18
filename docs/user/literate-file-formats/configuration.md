# Literate Configuration 

## About the Literate file formats
The literate configuration format is a [CommonMark](http://spec.commonmark.org/) document that has embedded code 
blocks for machine readable sections. This encourages easy-to-author documentation while permitting the specificity 
desired when authoring and processing instructions.

### Notable Features
- All the relavent settings for generating code for any language can be unified into a single location
- Choose a specific version (or a valid range?) of AutoRest to run (discovery/acquring when necessary.)
- Specify the OpenAPI files that it applies to.
- Apply code generation tweaks without having to mark up the OpenAPI 

## The File Format

The Literate configuration file is a CommonMark (aka Markdown) file that has code blocks. 

In order that AutoRest identifies a CommonMark document as a **AutoRest Configuration** file, the markdown must contain the following string exactly (and not as the first line in the file!) :

``` markdown
> see https://aka.ms/autorest
```

#### Example: Bare-minimum configuration file

A bare minimum configuration file that contains no specific settings would look like this:

``` markdown 
# My API
> see https://aka.ms/autorest 
```

### Naming your configuration file

When AutoRest runs, if the user does not specify the configuration file explicitly, AutoRest will attempt to discover by the following process:

``` markdown
Are there any Markdown files [*.md , *.markdown] in the current directory that contain the magic string "\n> see https://aka.ms/autorest"?

 -> No; Navigate to parent directory [..] and try again. 
    If the parent folder is invalid, there is no configuration file. 

 -> Yes; Is one of them called "readme.md" 
      -> No; Choose the one with the shortest filename.
      -> Yes; Use the one called "readme.md"
```
It is highly recommended that the configuration file is named `readme.md` -- it serves dual-purpose as both the documentation that a user sees in github where instructuions for use can be, as well as the storage for configuration information.


### Best-practices 

A configuration file should _document_ how to use the configuration file, without assuming that the user knows how to use any of the tools required.

> Example: a configuration `readme.md` that starts off with instructions on how to use it.

> ~~~ markdown
> # My API 
> > see https://aka.ms/autorest 
> 
> ## Getting Started 
> To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:
> > `autorest readme.md`
> 
> To see additional help and options, run:
> > `autorest --help`
> 
> For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.
> 
> ---
> 
> ## Configuration 
> The following are the settings for this using this API with AutoRest.
>
> ``` yaml
> # specify the version of Autorest to use
> version: 1.0.1-20170402 
> 
> # (more settings here...)
> ```
>
>
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
# specify a single OpenAPI file
input-file: foo.yaml

# specify a set of OpenAPI files 
input-file:
  - foo.yaml
  - bar.yaml
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


#### JSONPath document reference

[JSONPath](http://goessner.net/articles/JsonPath/) will be used to reference nodes in the OpenAPI document object model.

JSONPath is similar to XPath, but is designed for JSON (and YAML) documents. This will be used in conjunction with the [OpenAPI DOM Query Format](#OpenAPI-DOM-Query-Format) 

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
# specifically refers to a single node in the OpenAPI DOM
# #/definitions/fooresource/properties/properties/provisioningState
some-node: $definitions.fooresource.properties.properties.provisioningState
```

Or you can use a more complex expression to identify a collection of nodes:

``` yaml
# selects all nodes in the 'paths' collection that have an node that has a property 'operationId' where the value starts with 'blob_'
some-nodes: $..paths[($..operationId["blob_*"])]
```

The applicability of the selected nodes is explained further in the section [OpenAPI DOM Query Format](#OpenAPI-DOM-Query-Format) 

## The OpenAPI DOM

In the configuration file, you can specify the list of OpenAPI documents that you wish to include.

``` yaml
input-file: 
  - ./2015-01-02/foo.json   # referenced documents can be JSON, YAML or Markdown. 
  - ./2016-02-03/bar.md     
```
Once a file is loaded, it can beereferred to in configuration by it's file name or instead by it's OpenAPI `title` value. (You can think of this as the `namespace` for the OpenAPI document)

## Configuration sections

The general layout of the Literate Configuration DOM is :

### Settings 
Settings are top-level key-value pairs that AutoRest uses to create the Literate OpenAPI DOM and control the pipeline.

These generally include the things that have been traditionally passed on the cmdline. Ie:

``` yaml
namespace: MyApp.MyNameSpace
output-folder : ./Generated
azure-arm: true # 'azure-arm' is a declaration that the OpenAPI is an Azure arm resource (not specified as part of the generator name.)
input-file:
  - OpenAPI/MySpec.json
  - OpenAPI/MySpec2.json
```

### Per-language Settings
At the top-level of the Literate Configuration document, you may also specify a language, which performs two things:

- includes that language generator as a language target in the pipeline.
- allows specifying/overriding settings on a per-language basis.

``` yaml
csharp: # just having a 'csharp' node enables the use of the csharp generator.
  namespace: Microsoft.MyApp.MyNameSpace #override the namespace 
  output-folder : generated/csharp # relative to the global value.

ruby: 
  namespace: Microsoft::Azure::MyApp::MyNameSpace # another alternative
  output-folder : $(output-folder)/ruby/sdk # relative to the global value.
```

### OpenAPI DOM Query Format
In order to make it possible to remove most of the AutoRest-specific extensions from
the OpenAPI DOM, it is necessary to be able to refer to one or more nodes in the OpenAPI document and apply options to those nodes.

#### Querying the OpenAPI DOM.

In order to accurately query nodes in the OpenAPI DOM for a specific set, we have a JSON/YAML object that is used to specify what we're looking for.

The query is basically two things: the list of OpenAPI documents and the nodes inside of those documents:

``` yaml
from: <OpenAPI-document-selection> # based on OpenAPI document (aka, the filename )
where: <json-path-query>           # a JSONPath expression to select the nodes in the OpenAPI DOM
```

If the `from` isn't set, the default is to apply the directive to all the Literate OpenAPI DOMs

If the `where` isn't set, the default is to apply the directive to all the nodes in the selected Literate OpenAPI DOMs


### Directives - global or per-language

Directives are nodes that change generation **behavior** based on the selection of a set of nodes in the OpenAPI DOM. See  [OpenAPI DOM Query Format](#OpenAPI-DOM-Query-Format)

Directives are specified as a collection of `directive` objects fall under the `directive:` setting.

A `directive` object appears as follows:

``` yaml
from: <OpenAPI-document-selection> 
where: <json-path-query>           # a JSONPath expression to select the nodes in the OpenAPI DOM
set: <object>                      # an object that has a series of key-value settings to apply to the selected nodes.
<other-directive-targets> : <*>    # other directives that don't set properties on the node, but rather are directed towards parts of autorest.
```

If the `from` isn't set, the default is to apply the directive to all the Literate OpenAPI DOMs

If the `where` isn't set, the default is to apply the directive to all the nodes in the selected Literate OpenAPI DOMs

> Example: overriding a `method-group` name 

``` yaml
directive: # an array of directive objects
  - from: myspec.json # specify a specific document 'namespace' (aka title)
    where: $..[@operationId="blob_*"]
    set:
      method-group: Blobber # override the method-group for a given set of operations matching blob_*
  
csharp:
  directive:
    # change blob method group name to AzureBlob
    - from: myspec.json # specify a specific document 'namespace' (aka title)
      where: $..[@operationId="blob_*"]
      set:
        method-group: AzureBlob # per-language (csharp) override for method-group name
```

