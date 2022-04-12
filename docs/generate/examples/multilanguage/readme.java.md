# Java

These settings apply only when `--java` is specified on the command line.

```yaml
fluent: true
```

## Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.

```yaml $(tag) == 'v1'
namespace: com.microsoft.azure.pets.v1
output-folder: java/pets/v1
```

## Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.

```yaml $(tag) == 'v2'
namespace: azure.pets.v2
output-folder: java/pets/v2
```
