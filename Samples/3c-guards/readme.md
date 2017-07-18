# Scenario: Guards for conditional configuration

> see https://aka.ms/autorest

## Inputs

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
```

### Preview features (run with `--preview` to activate)

``` yaml $(preview)
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-dns/2015-05-04-preview/swagger/dns.json
```

## Generation

``` yaml
csharp:
  output-folder: Client
```

## More fun with guards

Defining custom flags...

``` yaml $(csharp["output-folder"] == "Client")
please-generate-java-too: true
```

...and depending on them:

``` yaml $(please-generate-java-too)
java:
  output-folder: OtherClient
```

``` yaml $(please-generate-go-too)
go:
  output-folder: YetAnotherClient
```
