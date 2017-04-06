# Scenario: Custom transformations

> see https://aka.ms/autorest

## Configuration

``` yaml 
input-file: https://github.com/Azure/azure-rest-api-specs/blob/master/arm-storage/2015-06-15/swagger/storage.json
azure-arm: true
output-artifact: swagger-document
csharp:
  output-folder: Client
```

## Transformations

### Swagger: Override a description

``` yaml 
directive:
  from: storage.json
  where: $.paths["/subscriptions/{subscriptionId}/providers/Microsoft.Storage/checkNameAvailability"].post.description
  # The description will be set to the following:
  set: Checks that the account name has sufficient cowbell (in order to prevent fevers).
  reason: We've experienced a lack of cowbell in storage account names.
```

### Swagger: Mutate descriptions

``` yaml 
directive:
- from: storage.json
  where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}"].put.description
  # The following can be an arbitrary JavaScript expression that will be evaluated to determine the new value.
  # The original value is accessible via variable "$".
  # Here: We append a string to the existing value.
  transform: >
    $ + " Make sure you add that extra cowbell."
  reason: Make sure people know.
- from: storage.json
  where: $.definitions.Usage.description
  transform: $.toUpperCase()
  reason: Our new guidelines require upper case descriptions here. Customers love it.
```

### CodeModel: Use endpoint URIs to determine operation group names

``` yaml 
directive:
  from: model
  where: $.operations[*]
  transform: >
    (() => {
      const url = $.methods[0]["#url"];
      const res = url.split("/Microsoft.Storage/")[1].split("/")[0];
      $["#name"] = res;
      $.summary = JSON.stringify($, null, 2);
      return $;
    })()
  reason: We wanna group methods by URI.
```