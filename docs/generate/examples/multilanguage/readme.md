### General settings

```yaml
tag: v2
license-header: MICROSOFT_MIT_NO_VERSION
```

### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.

```yaml $(tag) == 'v1'
input-file: pets.json
```

### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.

```yaml $(tag) == 'v2'
input-file: petsv2.json
```

## Python

See configuration in [readme.python.md](./readme.python.md)

## Java

See configuration in [readme.java.md](./readme.java.md)
