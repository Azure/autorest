# Scenario: Custom transformations

> see https://aka.ms/autorest

## Inputs

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/master/arm-storage/2015-06-15/swagger/storage.json
```

### Preview features (run with `--preview` to activate)

``` yaml $(preview)
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/master/arm-dns/2015-05-04-preview/swagger/dns.json
```

## Generation

``` yaml
csharp:
  output-folder: Client
```

## More fun with guards

``` yaml $(csharp["output-folder"] == "Client")
please-generate-java-too: true
```

``` yaml $(please-generate-java-too)
java:
  output-folder: OtherClient
```