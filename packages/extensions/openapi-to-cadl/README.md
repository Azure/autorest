## Autorest openapi-to-cadl Plugin Configuration

Autorest extension to scaffold a new CADL definition from an existing OpenApi document.

To run it

```bash
autorest --openapi-to-cadl --input-file=<path-to-swagger> -namespace=<namespace> --title="<ProjectName>" --use=@autorest/openapi-to-cadl@next --output-folder=.
```

or with a README config file

```bash
autorest --openapi-to-cadl --require=<path-to-readme-config>.md --use=@autorest/openapi-to-cadl@next --output-folder=.
```

This plugin will generate the following files

main.cadl - Entry point of the CADL project, it contains service information
models.cadl - Contains all the model definitions
routes.cadl - Contains all the resource endpoints
cadl-project.yaml - Contains configuration for the CADL compiler
package.json - Configuration of the CADL project

```yaml
version: 3.6.6
use-extension:
  "@autorest/modelerfour": "^4.23.5"

modelerfour:
  # this runs a pre-namer step to clean up names
  prenamer: true

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
