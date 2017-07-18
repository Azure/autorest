# Scenario: Custom validation rules

> see https://aka.ms/autorest

## Standard

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
csharp:
  output-folder: Client
```

## Check StorageAccounts.cs (expecting success)

``` yaml
directive:
  from: StorageAccounts.cs
  where: $
  test:
    # boolean expression (false => failure, true => success)
    - $.indexOf("partial class StorageAccounts") !== -1
    # generator body, yielding booleans
    - |-
      const validationCount = $.split("new ValidationException").length - 1;
      yield validationCount > 0;     // we want some validations
      yield validationCount < 1000;  // but not too many
    # generator body, yielding message text
    - |-
      const validationCount = $.split("new ValidationException").length - 1;
      if (validationCount == 0)
        yield "we want some validations - found none";
      if (validationCount >= 1000)
        yield "too many validations";
    # generator body, yielding full blown messages
    - |-
      const validationCount = $.split("new ValidationException").length - 1;
      if (validationCount == 0)
        yield { Channel: "error", Text: "we want some validations - found none" };
      if (validationCount >= 1000)
        yield { Channel: "warning", Text: "too many validations" };
```

## Check StorageAccounts.cs (expecting failure, to demonstrate effects)

``` yaml
directive:
  from: StorageAccounts.cs
  where: $
  test:
    # boolean expression (false => failure, true => success)
    - $.indexOf("cowbell") !== -1
    # generator body, yielding booleans
    - |-
      const cowbellCount = $.split("cowbell").length - 1;
      yield cowbellCount > 0;     // we want some cowbell
    # generator body, yielding message text
    - |-
      const cowbellCount = $.split("cowbell").length - 1;
      if (cowbellCount == 0)
        yield "we want some cowbell - found none";
    # generator body, yielding full blown messages
    - |-
      const cowbellCount = $.split("cowbell").length - 1;
      if (cowbellCount == 0)
        yield { Channel: "error", Text: "we want some cowbell - found none" };
```

