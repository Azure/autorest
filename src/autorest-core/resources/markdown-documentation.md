# Default Configuration - Markdown overrides

Literate YAML files (markdowns) can have additional syntax that let you dynamically pick up
Markdown for descriptions, etc.


``` yaml
pipeline:
  swagger-document-override/md-override-loader-swagger:
    output-artifact: immediate-config
    scope: perform-load
```

``` yaml
pipeline:
  openapi-document-override/md-override-loader-openapi:
    output-artifact: immediate-config
    scope: perform-load
```