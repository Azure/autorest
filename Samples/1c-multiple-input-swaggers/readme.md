# Scenario: Client generation from multiple input OpenAPI definitions

> see https://aka.ms/autorest

## Inputs

We want a single client to be created from the following OpenAPI definition files:

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/search/2015-02-28/swagger/searchservice.json
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
```

Since the info sections of the OpenAPI definition files differ, we choose a new title for the overall client:

``` yaml
override-info:
  title: Search and Storage
```

## Generation

``` yaml
csharp:
  output-folder: Client
```

## Further artifacts

``` yaml
output-folder: Artifacts
```

### Fully resolved OpenAPI definition

To support tools unable to process multiple OpenAPI definitions or definitions with external references (`$ref: "<URI to another OpenAPI definition>#/definitions/SomeModel"`), AutoRest allows exporting a single, fully resolved OpenAPI definition without any external references that tools should be able to consume.

``` yaml
output-artifact: 
  - swagger-document.json
  - swagger-document.yaml
```

### Source maps

AutoRest tries to create source maps for output artifacts. These will relate the artifact with the original input files which may be helpful for tools created around AutoRest.
For example, AutoRest uses the source map internally in order to relate validation messages back to the original files.

``` yaml
output-artifact:
  - swagger-document.json.map
  - swagger-document.yaml.map
```
