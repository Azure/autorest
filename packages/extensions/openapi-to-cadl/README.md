## Autorest openapi-to-cadl Plugin Configuration

Autorest extension to scaffold a new TypeSpec definition from an existing OpenApi document.

To run it

```bash
autorest --openapi-to-cadl --input-file=<path-to-swagger> --namespace=<namespace> --title="<ProjectName>" --use=@autorest/openapi-to-cadl@next --output-folder=.
```

or with a README config file

```bash
autorest --openapi-to-cadl --require=<path-to-readme-config>.md --use=@autorest/openapi-to-cadl@next --output-folder=.
```

This plugin will generate the following files

main.tsp - Entry point of the TypeSpec project, it contains service information
models.tsp - Contains all the model definitions
routes.tsp - Contains all the resource endpoints
tsproject.yaml - Contains configuration for the TypeSpec compiler
package.json - Configuration of the TypeSpec project

```yaml
version: 3.6.6
use-extension:
  "@autorest/modelerfour": "^4.23.5"

modelerfour:
  # this runs a pre-namer step to clean up names
  prenamer: false

openapi-to-cadl-scope/emitter:
  input-artifact: openapi-to-cadl-files

output-artifact: openapi-to-cadl-files

pipeline:
  openapi-to-cadl: # <- name of plugin
    input: modelerfour/identity
    output-artifact: openapi-to-cadl-files

  openapi-to-cadl/emitter:
    input: openapi-to-cadl
    scope: openapi-to-cadl-scope/emitter
```
