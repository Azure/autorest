# Sample Configuration

_note:the following line identifies this as an AutoRest configuration file_
> see https://aka.ms/autorest

## Notes:
This shows some examples of how to suppress messages from AutoRest


### Typical Settings
``` yaml
version: latest     # autorest version
azure-arm: true     # enable Azure validations and code generation features
input-file: 
  - myApi.md    # multiple swaggers 
  - yourApi.md 

output-folder: $(base-folder)/generated 
```

### Suppressions

#### Example: any expression of the message

This suppresses the `TOO_MANY_PARAMETERS`, no matter what causes it, in all swagger files included.

``` yaml
directive:
  - suppress:                       # filter on event/messages
      - TOO_MANY_PARAMETERS         # I like lots of parameters
``` 

#### Example: limit scope to the one document namespace (MyAPI) and filter message

This suppresses the `M1007`, message no matter what causes it, in a specific swagger document.

``` yaml
directive:
  - from: MyAPI  # individual namespace
    suppress: 
      - M1007    # No idea what message code that is.
```

#### Example: limit scope to the one document namespace (YourAPI) and apply the filter only to `operationId` where the name begins with `legacy_`  

This suppresses the `NO_CAMEL_CASE`, in the `legacy` method group


``` yaml
  - from: YourAPI # individual namespace
    where:
      - $..paths[($..operationId["legacy_*"])] # restrict which paths this applies to based on operationId
    suppress-validations: 
      - NO_CAMEL_CASE      # life's too short to ride camel-case identifiers.
```


#### Example: multiple messages to suppress, on a specific set of paths

This suppresses  `TOO_MANY_PARAMETERS` and `NO_CAMEL_CASE`, on the all operations that start with the path `/subscriptions/{subscriptionId}/resources/{resourceId}/SomeResource/*`.

``` yaml
directive:
  - where: 
      - $..paths["/subscriptions/{subscriptionId}/resources/{resourceId}/SomeResource/*"]
      # that's everything in 'SomeResource'
    suppress:                       # filter on event/messages
      - TOO_MANY_PARAMETERS         # I like lots of parameters
      - NO_CAMEL_CASE               # life's too short to ride camel-case identifiers.

    
```


#### Example: call listed in a single directive section:

If you want them all grouped together, we don't mind:

``` yaml
directive:
  # first one
  - suppress:                       # filter on event/messages
      - TOO_MANY_PARAMETERS         # I like lots of parameters

  # second one
  - from: MyAPI  # individual namespace
    suppress: 
      - M1007    # No idea what message code that is.

  # third one
  - from: YourAPI # individual namespace
    where:
      - $..paths[($..operationId["legacy_*"])] # restrict which paths this applies to based on operationId
    suppress-validations: 
      - NO_CAMEL_CASE      # life's too short to ride camel-case identifiers.      
      
  # fourth one
  - where: 
      - $..paths["/subscriptions/{subscriptionId}/resources/{resourceId}/SomeResource/*"]
      # that's everything in 'SomeResource'
    suppress:                       # filter on event/messages
      - TOO_MANY_PARAMETERS         # I like lots of parameters
      - NO_CAMEL_CASE               # life's too short to ride camel-case identifiers.


```

#### Example: Same thing, in JSON

If you want them all grouped together and you just can't get enough curly braces, we don't mind:

``` json
{
  "directive": [
    {
      "suppress": [ "TOO_MANY_PARAMETERS" ]
    },
    {
      "from": "MyAPI",
      "suppress": [ "M1007" ]
    },
    {
      "from": "YourAPI",
      "where": [ "$..paths[($..operationId[\"legacy_*\"])]" ],
      "suppress-validations": [ "NO_CAMEL_CASE" ]
    },
    {
      "where": [ "$..paths[\"/subscriptions/{subscriptionId}/resources/{resourceId}/SomeResource/*\"]" ],
      "suppress": [
        "TOO_MANY_PARAMETERS",
        "NO_CAMEL_CASE"
      ]
    }
  ]
}
```