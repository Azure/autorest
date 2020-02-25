# Sample Configuration
> see https://aka.ms/autorest

## Notes:
This shows a set of swagger files that is processed as a merged unit by default, except for some languages

``` yaml

version: latest     # autorest version
azure-arm: false    # no special ARM consideratons 
input-file: 
  - myApi.md    # multiple swaggers 
  - yourApi.md 

output-folder: $(base-folder)/generated 

```

## CSharp settings
We want to treat this as one big swagger when we're done.

``` yaml
csharp: # pipeline def
  process: composite
  namespace: Microsoft.Azure.Example

```

## NodeJS Settings
We want each swagger processed independently to make two generated SDKs

``` yaml
javascript:
  namespace: Microsoft.Azure.Example
  process: single
  output-folder: $(base-folder)/js/generated/$(document:identity)

```

``` yaml
# during "azure-validtion"

directive:
  - suppress:                       # filter on event/messages
      - TOO_MANY_PARAMETERS         # I like parameters

  - from: MyAPI  # individual namespace
    suppress: 
      - TOO_MANY_PARAMETERS # I like parameters

  - from: YourAPI # individual namespace
    where:
      - $..paths[($..operationId["legacy_*"])] # restrict which paths this applies to based on operationId
    suppress-validations: 
      - NO_CAMEL_CASE 

  - suppress-validations: 
    - Details:
        code: FOO_BAR_BIN
        validationCategory: WHATVER
        providerNamespace: something 

```


Applying a directive:
Select
  - stage
  - document
  - nodes 
Apply
  - change
  - suppression
  - 


Pipeline stage:

- read swaggers
- merge swaggers
- validate model 
- generate model

- generate code 
- simplyfy code


[vscode] :: [autorest-as-a-library] :: [core]       :: [process] :: [plugin] 
                                      (suppress) 

message:
  location:
    - physical source location
    - what "node" in source doc this was?

  message:
  code:
  severity:
                                       
``` yaml

directive:
  - from: MyAPI # translate to the source file
    suppress-validations: 
      - TOO_MANY_PARAMETERS # I like parameters

  - from: YourAPI # translate to the source file
    where:
      - $..paths[($..operationId["legacy_*"])] # restrict which paths this applies to based on operationId
    suppress-validations: 
      - NO_CAMEL_CASE 

```