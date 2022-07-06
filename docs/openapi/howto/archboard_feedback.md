(This page can be linked as: https://aka.ms/azsdk/swagger-update)

# Archboard DPG/RLC feedback loop

If you went to SDK archboard as a service team, you may have encounter feedback on modification that you have to apply to your Swagger going forward
to generate your SDK using [DPG/RLC](https://aka.ms/azsdk/dpcodegen). This document tries to clarify some common patterns and well known modifications you need to
apply to your Swagger and/or Readme.

Content:

- [Need for more/less SDK package(s)](#need-for-moreless-sdk-packages)
- [Rename an operation](#rename-an-operation)
- [Rename an operation group (or rename a sub-client)](#rename-an-operation-group-or-rename-a-sub-client)
- [Need one client to have all operations directly on it (no sub-client)](#need-one-client-to-have-all-operations-directly-on-it-no-sub-client)
- [Need one client/builder with sub-clients](#need-one-clientbuilder-with-sub-clients)
- [Need two or more service clients (regardless of if some needs subclients or not)](#need-two-or-more-service-clients-regardless-of-if-some-needs-subclients-or-not)
- [Rename a model name](#rename-a-model-name)
- [Rename a model attribute](#rename-a-model-attribute)
- [Operation should be pageable](#operation-should-be-pageable)
- [Operation should be LRO](#operation-should-be-lro)

## Need for more/less SDK package(s)

If you got as a feedback that your API needs to split across several packages, or two packages should be merged into one, then
structure your Swaggers to have exactly one folder per package. Most of the work is re-organizing files and Readme. Example of hierarchy on
the [RestAPI spec repo](https://github.com/Azure/azure-rest-api-specs):

```
specification/
├─ myservice/
│  ├─ data-plane/
│  │  ├─ package1/
│  │  │  ├─ Microsoft.MyService/ (swaggers for package 1)
│  │  │  ├─ readme.md
│  │  ├─ package2/
│  │  │  ├─ Microsoft.MyService/ (swaggers for package 2)
│  │  │  ├─ readme.md
```

## Rename an operation

Operation name are directly OperationID in Swagger. Just rename the OperationID directly.

Note: If your operation contains an `_`, just change the second part as the first is an operation group.

```json
 "operationId": "SomethingToDoOperation",
 ...
 "operationId": "MyGroup_SomethingElseToDoOperation",
```

becomes

```json
 "operationId": "BuildTheThing",
 ...
 "operationId": "MyGroup_BuildSomethingElse",
```

## Rename an operation group (or rename a sub-client)

Operation groups are the first part of an OperationID in Swagger, before the `_` character. To rename an operation group, you need to rename all OperationID that
starts with the operation group prefix (there is likely many of them).

```json
 "operationId": "MyGroup_BuildSomethingElse",
```

becomes

```json
 "operationId": "NewGroup_BuildSomethingElse",
```

## Need one client to have all operations directly on it (no sub-client)

Don't use operation groups in your OperationID (remove them if they exist). For any operation with an `_` character, remove the first part.

```json
 "operationId": "MyGroup_BuildSomethingElse",
```

becomes

```json
 "operationId": "BuildSomethingElse",
```

## Need one client/builder with sub-clients

- Use operation groups, and name them as you want your subclients to be called. Operation group can be create in Swagger by using the `_` character in the OperationID
  (`OperationGroupName_OperationName`)
- For C#, use `single-top-level-client: true`

For instance, this:

```json
 "operationId": "MyGroup_BuildSomethingElse",
```

Will create a subclient for MyGroup, that will have an operation called BuildSomethingElse.
In various languages this could looks like (pseudo-code):

```
MyServiceClient(endpoint, credentials).MyGroup().BuildSomethingElse() // C#

MyServiceClient(endpoint, credentials).my_group.build_something_else() # Python
```

## Need two or more service clients (regardless of if some needs subclients or not)

- Make sure you don't have one Swagger with operations that are designed to be in two different clients.
  Split Swagger files in multiple swagger files if necessary: clients should correspond to a clear set of Swagger files.
- Define tags in `Readme.md` for each client input files. Use the `batch` autorest option to create the two clients:-

```yaml
batch:
  - tag-client1
  - tag-client2
```

- For each individual clients, follow the previous guidance on single clients. You may have options specific to only one tag for one client.

## Rename a model name

Just rename the model name directly in Swagger. Since this name is not use in JSON serialization, there is no need to use specific extensions.

## Rename a model attribute

Since attribute name are used in JSON serialization, the recommendation will vary depending on the status of your API.

- If you API is still in design or in preview, we encourage to update the RestAPI server implementation to the new name, and then update the Swagger accordingly.
- If you API is GA and changing the server name would be a breaking change, we need to declare a mapping between the SDK name and the JSON name. It's achieved with the extensions
  `x-ms-client-name` :

```json
    "ModelNAme": {
      "description": "This model is very helpful.",
      "properties": {
        "attributeName": {
          "x-ms-client-name": "betterSDKNameForThisAttribute",
          "type": "string"
        }
      }
    }
```

## Operation should be pageable

You will get this feedback if your operation is returning a list of objects. Contrary to a common misconception: you do not need to support paging on the server to design an operation as a pageable. Pageable is a design, not a server capability.

The full documentation for pageable is available here: https://github.com/Azure/autorest/blob/main/docs/extensions/readme.md#x-ms-pageable

At a glance:

- Add `x-ms-pageable` node to your operation definition.
- Make sure your return schema is an array of T (T could be anything).
- `nextLinkName` can be `null` if your service do not support paging yet, otherwise should be the JSON key where the next link is (usually `nextLink`).
- For more complex pageable (different verb than GET, complex URL building, etc.), please refer to x[-ms-pageable full doc](https://github.com/Azure/autorest/blob/main/docs/extensions/readme.md#x-ms-pageable).

```json
"/myservice/subscriptions" :
  "get": {
    "operationId": "GetMySubscription",
    "x-ms-pageable": {
       "nextLinkName": null
    }
```

## Operation should be LRO

You will get this feedback if your operation is a Long Running Operation (LRO), and follow the LRO protocol (usually using Location, Operation-Location, etc.). Those operations need to be tagged as LRO in the Swagger, as this makes SDK generates a specific return type as a poller. For this, use the ["x-ms-long-running-operation"](https://github.com/Azure/autorest/blob/main/docs/extensions/readme.md#x-ms-long-running-operation) option.

```json
"/myservice/subscriptions" :
  "put": {
    "operationId": "CreateVirtualMachine",
    "x-ms-long-running-operation": true
```

For most of the time, _there is no additional information to provide_ as the language runtime will auto-detect what polling mechanism to use.

Some options can be configured with the node ["x-ms-long-running-operation-options"](https://github.com/Azure/autorest/blob/main/docs/extensions/readme.md#x-ms-long-running-operation-options):

- "final-state-via": Is here to prematuraly stop the polling in case your service do not respect the LRO correctly. _Do not use this option if you think your service respects the LRO guidelines, as you could break SDK_. In doubt about this option, please talk to the RestAPI stewardship board.

Example:

```json
    "x-ms-long-running-operation": true,
    "x-ms-long-running-operation-options": {
      "final-state-via": "location"
    }
```
