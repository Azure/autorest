# Literate OpenAPI (aka 'swagger')

## The File Format

The test file is a CommonMark (aka Markdown) file that contains code blocks containing the OpenAPI document.

The idea is to split the OpenAPI document into meaningful parts and provide documentation for each of those parts at the right spot.

Using markdown headings one can further group those parts in a more meaningful way than OpenAPI itself supports.

> Example
> ~~~ markdown
> # My Simple API  
> My Simple API is a REST interface to something quite simple.
> 
> ``` yaml 
> swagger: '2.0'
> info:
>   version: 1.0.0
>   title: Simple API
> ```
> 
> ## Operations on Flubbers
> 
> ### Create Flubber
> ``` yaml 
> paths:
>   /operation:
>     get:
>       operationId: flubber_create
>       deprecated: true
>       documentation: ['Description']
>       parameters:
>        - name: cowbell
>          in: query
>          type: boolean
>          required: true
>          description: ['Parameter: cowbell']
>        - name: fruit
>          in: query
>          type: string
>          required: false
>          description: ['Parameter: fruit']
>       responses:
>         200:
>           description: OK
>           schema:
>             $ref: ['Result Object']
> ```
> 
> #### Description
> This operation creates a new flubber, yada yada yada.
> 
> #### Parameter: cowbell
> Needs to be fun.
> 
> #### Parameter: fruit
> Should be left-handed.
> 
> 
> ## Model Definitions
> 
> ### Result Object
> ``` json
> {
>   "definitions": {
>     "ResultObject": { 
>       ...
>     }
>   }
> }
> ```
> 
> ### Error Object
> ``` yaml 
> definitions:
>   ErrorObject:
>     ...
> ```
> ~~~

This renders as

> # My Simple API  
> My Simple API is a REST interface to something quite simple.
> 
> ``` yaml 
> swagger: '2.0'
> info:
>   version: 1.0.0
>   title: Simple API
> ```
> 
> ## Operations on Flubbers
> 
> ### Create Flubber
> ``` yaml 
> paths:
>   /operation:
>     get:
>       operationId: flubber_create
>       deprecated: true
>       documentation: '#/descriptions/Create-Flubber/Description'
>       parameters:
>        - name: cowbell
>          in: query
>          type: boolean
>          required: true
>          description: '#/descriptions/Parameter-cowbell'
>        - name: fruit
>          in: query
>          type: string
>          required: false
>          description: '#/descriptions/Parameter-fruit'
>       responses:
>         200:
>           description: OK
>           schema:
>             $ref: '#/definitions/ResultObject'
> ```
> 
> #### Description
> This operation creates a new flubber, yada yada yada.
> 
> #### Parameter: cowbell
> Needs to be fun.
> 
> #### Parameter: fruit
> Should be left-handed.
> 
> 
> ## Model Definitions
> 
> ### Result Object (Jason loves JSON)
> ``` json
> {
>   "definitions": {
>     "ResultObject": { 
>       ...
>     }
>   }
> }
> ```
> 
> ### Error Object (Johnny loves YAML)
> ``` yaml 
> definitions:
>   ErrorObject:
>     ...
> ```

## Semantic Merging
Code blocks are semantically merged (in memory) into one OpenAPI document.
Specifically, this means that code blocks are parsed individually.
The resulting object trees are then merged recursively. 

This has multiple benefits:
- language independence across code blocks (YAML, JSON, ...)
- order independence (e.g. one could mix model definitions and operations. This may make sense if, say, a model is very specific to a certain operation or operation group.)
- improved readability: Instead of relying on previous codeblocks and indentation, restating the path to an object (e.g. `definitions`, `paths` or operation names) makes structure explicit

## Referencing Markdown Documentation
Using literate OpenAPI, one can (and is encouraged) to provide rich documentation for raw OpenAPI using markdown.
However, note that raw OpenAPI comes with documentation features as well (`description`, `summary`, ...), which even support markdown formatting.
It is therefore desirable to allow referencing surrounding markdown documentation from within the codeblocks, causing the documentation to be forwarded into OpenAPI.

To reference markdown documentation, one can name a markdown anchor in place of documentation.
The parser will resolve the heading corresponding to that anchor and grab the documentation up to one of the following points:
- a heading of equal or less depth (as the anchor heading)
- a code block
- the end of the file

Note that GFM auto-generates anchors for all headings, so one does not have to place anchors manually.