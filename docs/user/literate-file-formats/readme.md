# AutoRest: Literate file-format support

## Purpose

To provide a means to tie together **all** related information for a given set of OpenAPI specifications including information regarding:

- version of AutoRest to use.
- global and code-generator specific settings 
- hints, overrides and information related to code generation that does not affect the wire-protocol 
- references to additional supplemental resources like test data, examples, and other documentation
- metadata to track the publishing/release state of a given SDK

In a singular file, instead of passed on the command line and/or embedded in the OpenAPI input file, or batch files.

The design of the file formats chosen here promotes a documentation-centric model for both settings and OpenAPI spec authoring.

## File Format
The 'Literate' file format is [CommonMark](http://spec.commonmark.org/) document that has embedded `code-blocks`
for machine-readable sections. The this encourages easy-to-author documentation while permitting the specificity 
desired when authoring and processing instructions.

Generally speaking, it is prefereable that the documentation section that follows a given `code-block` applies to that `code-block`.

## Scenarios to consider
Using AutoRest with Literate files is as simple as possible without the user having to understand convoluted mechanisms in order to do day-to-day work with the tool.

The usage is consistent regardless of how AutoRest is used (ie, from the command line, as a language service in VSCode, or in a CI/CD system.) 

This includes authoring and execution support for using AutoRest
- on a single `OpenAPI` file, with a specific set of settings 
- on a collection of related OpenAPI files, (like the now-defunct `composite-modeler`), but allow for individually generating SDKs, or merge them based into one.
- on `OpenAPI` files, in parallel for a given set of language generators 

## Implementation
Since AutoRest has moved towards a pluggable extension model where generators, validators and transformer can be implemented out-of-proc in any language, the intention is that AutoRest implement the support to handle the Literate 
file formats, and the individual extensions can simply request the processed object model, and not have to do any coding to process or parse the CommonMark file formats. 

### Compatibility
AutoRest can transparently process a `JSON` file, a `YAML` file or a Literate document for any purpose that is necessary, and an author can substitute one for another if it contains the information required. 

AutoRest can also be used to 'preprocess' a given file into a `JSON` or `YAML` for consumption by other tools that are not able to process a Literate file.

## Specifications
  The specification for the [Literate Configuration](./configuration.md)

  The specification for the [Literate Swagger](./literate-swagger.md)
  