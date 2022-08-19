# Suppress warnings

Warnings can be suppressed in autorest using the `suppressions` config entry. It takes an array of suppresion with the following properties

- `code`: **Required** Code of the suppression. Can be the code area. If the warning code is `Foo/Bar` the code in the suppression can either be `Foo/Bar` for that specifc warning or `Foo` for all warning starting with `Foo/`
- `reason`: **Optional** Reason for suppression. For documentation purposes
- `from`: **Optional** The artifact name or file name where this should be suppressed. If not provided will suppress all instance regardless of their location.
- `where`: **Optional** The json path where this error should be suppressed. If not provided will suppress all instance regardless of their location in the documents.

## Examples

### Suppress in a specific swagger document

```yaml
suppressions:
  - code: OutdatedExtension
    from: swagger.yaml
    reason: Keeping it for legacy tooling
```

### Suppress in all swagger documents

```yaml
suppressions:
  - code: OutdatedExtension
    from: swagger-document
    reason: Keeping it for legacy tooling
```

### Suppress at a specific path

```yaml
suppressions:
  - code: OutdatedExtension
    from: swagger-document
    where: $.definitions.Foo
    reason: Keeping it for legacy tooling
```
