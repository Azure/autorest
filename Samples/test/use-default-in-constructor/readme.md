# Using property default values in constructors

> see https://aka.ms/autorest

``` yaml 
input-file: property-defaults.yaml
```

## Regular run

``` yaml
csharp:
  - output-folder: Client
```

## Run using property defaults in constructors

``` yaml
csharp:
  - output-folder: ClientFancy
    directive:
      from: code-model-v1
      where: $..*[?(@.$type == "CompositeType")].properties[*]
      transform: $.useDefaultInConstructor = true
```

The directive activates the `useDefaultInConstructor` for all properties.
Note that this granularity also allows activating the features only for some model classes or even some individual properties.