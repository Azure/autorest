# Python

These settings apply only when `--python` is specified on the command line.

```yaml
package-name: azure-pets
```

## Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.

```yaml $(tag) == 'v1'
namespace: azure.pets.v1
output-folder: python/pets/azure-pets/azure/pets/v1
```

## Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.

```yaml $(tag) == 'v2'
namespace: azure.pets.v2
output-folder: python/pets/azure-pets/azure/pets/v2
```
