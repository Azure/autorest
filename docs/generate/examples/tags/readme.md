# Generate Pets in Python with Conditional Tags

### General settings
```yaml
python: true
output-folder: generated/
tag: v2
```

### Tag: v1

These settings apply only when `--tag=v1` is specified on the command line.
```yaml $(tag) == 'v1'
input-file: pets.json
namespace: pets.v1
```

### Tag: v2

These settings apply only when `--tag=v2` is specified on the command line.
```yaml $(tag) == 'v2'
input-file: petsv2.json
namespace: pets.v2
```
