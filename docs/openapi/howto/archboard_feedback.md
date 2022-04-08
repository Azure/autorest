IF you went to SDK archboard as a service team, you may have encounter feedback on modification that you have to apply to your Swagger going forward 
to generate your SDK using [DPG](https://aka.ms/azsdk/dpcodegena). This document tries to clarify some common patterns and well known modifications you need to
apply to your Swagger.

# Need for more/less SDK package(s)

If you got as a feedback that your API needs to split across several packages, or two packages should be merged into one, then
structure your Swaggers to have exactly one folder per package. Most of the work is re-organizing files and Readme. Example of hierarchy on 
the [RestAPI spec repo](https://github.com/Azure/azure-rest-api-specs):

```
specification/
├─ myservice/
│  ├─ data-plane/
│  │  ├─ package1/
│  │  │  ├─ readme.md
│  │  ├─ package2/
│  │  │  ├─ readme.md
```

# Rename an operation

Operation name are directly OperationID in Swagger. Just rename the OperationID directly.

Note: If your operation contains an `_`, just change the second part as the first is an operation group.

# Rename an operation group (or rename a sub-client)

Operation groups are the first part of an OperationID in Swagger, before the `_` character. To rename an operation group, you need to rename all OperationID that
starts with the operation group prefix (there is likely many of them).

# Need one client to have all operations directly on it (no sub-client)

Don't use operation groups in your OperationID (remove them if they exist). For any operation with an `_` character, remove the first part.

# Need one client/builder with sub-clients

-	Use operation groups, and name them as you want your subclients to be called. Operation group can be create in Swagger by using the `_` character in the OperationID 
(`OperationGroupName_OperationName`)
-	For C#:
  - Use `single-top-level-client: true`

# Need two or more service clients (regardless of if some needs subclients or not)

-	Make sure you don't have one Swagger with operations that are designed to be in two different clients.
  Split Swagger files in multiple swagger files if necessary: clients should correspond to a clear set of Swagger files.
-	Define tags in `Readme.md` for each client input files. Use the `batch` autorest option to create the two clients:-

```yaml
batch:
- tag-client1
- tag-client2
```

-	For each individual clients, follow the previous guidance on single clients. You may have options specific to only one tag for one client.

# Rename a model name

Just rename the model name directly in Swagger. Since this name is not use in JSON serialization, there is no need to use specific extensions.

# Rename a model attribute

Since attribute name are used in JSON serialization, we need to declare a mapping between the SDK name and the JSON name. It's achieved with the extensions 
`x-ms-client-name` :

``` json
    "ModelNAme": {
      "description": "This model is very helpful.",
      "properties": {
        "attributeName": {
          "x-ms-client-name": "betterSDKNameForThisAttribute,
          "type": "string"
        }
      }
    }
```
