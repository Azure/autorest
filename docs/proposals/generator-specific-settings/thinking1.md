# Compute

To build this, install AutoRest and run:

> `Autorest.exe readme.md`

## Turn off some validations 

``` yaml
Suppress-validations:
  UniqueResourcePaths:
    reason: not appropriate for this swagger'
    in:
     - AppServicePlans API Client
     - SomeOther API Client

    location:
      - $..paths[($..operationId["blob_*"])]
      - $definitions.fooresource.properties.properties.provisioningState
      - $definitions($..@provisioningState)
      
      
      
      #
      #- $..foo[($..operationId["blob_*"])]
      #
    
```

# Options 
This are applied to all of the generators for this spec.

If you have a proble, call Amar

``` yaml
options:
  - from:
      - My Client API
    where:
      - $..paths[($..operationId["blob_*"])]
    set:
      method-group: Blobber
    suppress-validations:
      - UniqueResourcePaths

  - where:
    - definitions.myobject.properties.foo
    set:
      client-flatten: true
      x-ms-client-name: HELLO
      enum:
        name: MyEnum
        modelAsString: false
    

- from: My Client API
  where: $..[($info.version["2016-01-02"])]
  set:
    method-group: Blobber
  suppress-validation: UniqueResourcePaths




bar: 
  
```

c:\> AutoRest arm-storage.md 
c:\> AutoRest readme.md 



``` yaml
code-generation:
    in:
     - AppServicePlans API Client
     - SomeOther API Client

    paths:
      - *.get
    
```

``` yaml
somthign:
  title: MyAPI 
  operationId : get_blobs 

```


