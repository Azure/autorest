# Default Configuration

This configuration applies to every run of AutoRest, but with less priority than any other specified configuration (i.e. it is overridable).

## Basic Settings

``` yaml
azure-arm: false
output-folder: generated
openapi-type: arm

# Load additional configurations.
require:
  - $(this-folder)/directives.md
  - $(this-folder)/pipeline-merger.md
  - $(this-folder)/pipeline-composer.md
  - $(this-folder)/loader-openapi2.md
  - $(this-folder)/loader-openapi3.md
  - $(this-folder)/markdown-documentation.md
  - $(this-folder)/miscellaneous.md
  - $(this-folder)/patches.md
  - $(this-folder)/plugin-azureresourceschema.md
  - $(this-folder)/plugin-csharp.md
  - $(this-folder)/plugin-go.md
  - $(this-folder)/plugin-java.md
  - $(this-folder)/plugin-nodejs.md
  - $(this-folder)/plugin-php.md
  - $(this-folder)/plugin-python.md
  - $(this-folder)/plugin-ruby.md
  - $(this-folder)/plugin-typescript.md
  - $(this-folder)/plugin-validators.md

  - $(this-folder)/graphs.md
  - $(this-folder)/help-configuration.md

```

##### Actually load files

If we don't specify `--help`, we will trigger the setting to load files

``` yaml !$(help)
perform-load: true # kick off loading
```