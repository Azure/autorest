# Scenario: Custom transformations

> see https://aka.ms/autorest

## Configuration

``` yaml 
input-file: https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
azure-arm: true
azure-validator: true
output-artifact:
 - swagger-document.json
 - code-model-v1.yaml
 - pipeline.yaml
csharp:
  output-folder: Client
```

## Transformations

### OpenAPI definition: Override a description

``` yaml 
directive:
  from: storage.json
  where: $.paths["/subscriptions/{subscriptionId}/providers/Microsoft.Storage/checkNameAvailability"].post.description
  # The description will be set to the following:
  set: Checks that the account name has sufficient cowbell (in order to prevent fevers).
  reason: We've experienced a lack of cowbell in storage account names.
```

### OpenAPI definition: Mutate descriptions

``` yaml 
directive:
- from: storage.json
  where: $.paths["/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}"].put.description
  # The following can be arbitrary JavaScript code that will be evaluated to determine the new value.
  # The original value is accessible via variable "$".
  # Here: We append a string to the existing value.
  transform: $ += " Make sure you add that extra cowbell."
  reason: Make sure people know.
- from: storage.json
  where: $.definitions.Usage.description
  transform: return $.toUpperCase()
  reason: Our new guidelines require upper case descriptions here. Customers love it.
```

### OpenAPI definition: Rename methods

``` yaml 
directive:
  from: swagger-document # do it globally (in case there are multiple input OpenAPI definitions)
  where: $.paths..operationId
  # Replace operation IDs ending in "...ies" with "...y", because that's the safest way to make stuff singular.
  transform: return $.replace(/ies$/, "y")
  reason: I don't like plural.
```

### CodeModel: Use endpoint URIs to determine operation group names

By default (without an explicit return statement), `$` is considered the result of the transformation.

``` yaml 
directive:
  from: code-model-v1
  where: $.operations[*]
  transform: >
      const url = $.methods[0]["#url"];
      const res = url.split("/Microsoft.Storage/")[1].split("/")[0];
      $["#name"] = res;
      $.summary = JSON.stringify($, null, 2);
  reason: We wanna group methods by URI.
```
