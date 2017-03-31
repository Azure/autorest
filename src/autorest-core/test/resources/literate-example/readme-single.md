# MySample API

> see https://aka.ms/autorest

Some information about My Sample API. It's a great API, and it's mine.

## Common Settings
   ``` yaml 
   input-file:
    - swagger.md

   AutoRest: 
       includes: 
           - ../../#main.swagger.md
           - ../../#other.swagger.md
       version: <= 2.0 # requires autorest before 2.0
       modeler: standard
       base-folder : $ThisFileDirectory/outputfolder

   azure-arm: true
   ```

or you could have it in a JSON block:

``` json $(false)
{
  "Azure.NodeJS" : {
    "ouput-folder": "dnsManagement/lib",
    "source": "arm-dns/2016-04-01/swagger/dns.json"
  }
}
```

## CSharp Settings - Generates the c# version of the API

~~~ yaml  enabled: $longRunningTest, filename: foo.yaml 
cSharp:
    output-folder: csharp # relative to base-output 
    namespace: Microsoft.Api.Mysample

# some more settings...

~~~

## NodeJS Settings - Generates the javascript version of the API

``` yaml $(false)
nodejs:
    output-folder : javascript  # relative to base-output 
    namespace : Microsoft.Mysample

# some more settings...

```

## Python settings

    pythony: # spelled wrongly so it doesn't actually trigger code gen
        namespace: Microsoft.MyPyhtonSample

    # some more pythony settings...


## Release Notes
2016-11-27 - This release makes the whole world happy. You should use this one.

## Implementation notes:
- Don't forget to rebuild.