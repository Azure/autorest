# Generate Pets in Python with Conditional Tags

### General settings

```yaml
python: true
package-name: azure-pets
tag: v2
```

### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.

```yaml $(tag) == 'v1'
input-file: pets.json
namespace: azure.pets.v1
output-folder: $(python-sdks-folder)/pets/azure-pets/azure/pets/v1
```

### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.

```yaml $(tag) == 'v2'
input-file: petsv2.json
namespace: azure.pets.v2
output-folder: $(python-sdks-folder)/pets/azure-pets/azure/pets/v2
```
