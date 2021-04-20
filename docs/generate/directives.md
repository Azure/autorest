# <img align="center" src="../images/logo.png"> Directives

Directives are used to tweak the generated code prior to generation, and are included in your configuration file (usually a README file). For example, if you want to change a property's name from the name defined in the OpenAPI definition, you can add a directive in your readme to accomplish this.

We usually recommend changing the swagger before going the directive route, but if you'd like the original swagger to remain untouched (for example, you want to rename the generated model in the Python SDK, but not in other SDKs), directives are the route for you.

> Stylistic note: we recommend annotating your directives in your config file with a header about what the directive is doing.

## Structure and Terminology

Directives consist of three parts:

- **Location**: denoted by the field `from`, which document are we trying to transform. For swagger transformations, it's always `from: swagger-document`.

- **Filter**: denoted by the field `where`, contains the criteria to select the object.

  - An `operation` is filtered by
    - its path in the swagger's [`paths`][paths] object AND
    - it's HTTP verb
  - A `parameter` is filtered by:
    - its location in its `operation` (see above) OR
    - its name in the swagger's `parameters` object, if it's defined as a common parameter there (see the Common Parameters for Various Paths section [here][parameters] for more information)
  - A `model` can be filtered by:
    - its name in the [components or definitions][components] section OR
    - its location in its outer object, if defined within another object OR
    - its location in an operation, if defined within an operation
  - A `property` can be filtered by:
    - its location within its parent object

- **Transform**: denoted by the field `transform`, the actions we would like to be applied on the specified objects. The list of available variables and functions can be found in [eval.ts](https://github.com/Azure/autorest/blob/master/packages/extensions/core/src/lib/plugins/transformer/eval.ts)

## Built-in Directives

[See built in directives here](./built-in-directives.md)

## Directive Scenarios

The following directives cover the most common tweaking scenarios for generation. Most of those have a `built-in` [directive](./built-in-directives.md) helper and are shown here as examples.

- [Operation Rename](#operation-rename "Operation Rename")
- [Parameter Rename](#parameter-rename "Parameter Rename")
- [Model Rename](#model-rename "Model Rename")
- [Property Rename](#property-rename "Property Rename")
- [Enum Value Rename](#enum-value-rename "Enum Value Rename")
- [Change Description](#change-description "Change Description")

### Operation Rename

A common use case is renaming an operation. Say you have the following operation in your swagger:

```yaml
...
"paths": {
    "/vm": {
        "get": {
            "operationId": "getVirtualMachine",
            ...
        }
    }
    ...
}
```

and you'd like to rename it from `getVirtualMachine` to `getVM`. You would refer to this operation with the combination of its `path` and its http `verb`.
As always, you use `from: swagger-document` to specify you're changing your swagger document. Finally, what you're transforming is the `"operationId"`.
Putting this together, your directive looks like:

```yaml
### Directive renaming operation from "getVirtualMachine" to "getVM"
directive:
  from: swagger-document
  where: '$.paths["/vm"].get'
  transform: >
    $["operationId"] = "getVM";
```

### Parameter Rename

To select the parameter, you either refer to its location inside the operation it's defined within, or its name in the [common `parameters` section][parameters].
We'll go over both in this example. In both cases, we'll be looking to rename parameter `id` to `identifier`.

#### Parameter defined in operation

```yaml
...
"paths": {
    "/vm": {
        "get": {
            "operationId": "getVirtualMachine"
            "parameters": [
                {
                    "name": "id",
                    ...
                }
            ]
        }
    }
    ...
}
```

Referring to the parameter's location in the operation, our filter would be `where: '$.paths["/vm"].get.parameters[0]'`. We're changing the name of the parameter,
so you could apply your transform to the `name` field. However, it's better to change the [`x-ms-client-name`][x_ms_client_name] field instead, since there could be
this field defined for your parameter, and this field overrides the `name` field. This becomes

```yaml
### Directive renaming "getVirtualMachine"'s parameter "id" to "identifier".
directive:
  from: swagger-document
  where: '$.paths["/vm"].get.parameters[0]'
  transform: >
    $["x-ms-client-name"] = "identifier";
```

#### Parameter defined in the "Parameters" section

```yaml
---
"parameters": { "Id": { "name": "id", ... } }
```

Now, we refer to the parameters location within the swagger's `parameters` object. This changes our filter to `where: '$.parameters["Id"]'`, and leads us
to the following directive:

```yaml
### Directive renaming "getVirtualMachine"'s parameter "id" to "identifier".
directive:
  from: swagger-document
  where: '$.parameters["Id"]'
  transform: >
    $["x-ms-client-name"] = "identifier";
```

### Model Rename

We have the following swagger:

```yaml
...
"definitions": {
    "VM": {
        "type": "object"
        ...
    }
    ...
}
```

and we'd like to rename the model `VM` to `VirtualMachine`. We refer to the model with filter `where: #.definitions.VM`. Since the location we're trying to transform
is listed as a key in the swagger dictionary and not a field, we change the model's name by adding in field [`x-ms-client-name`][x_ms_client_name]. Thus, our directive looks like

```yaml
### Directive renaming "VM" model to "VirtualMachine"
directive:
  from: swagger-document
  where: "$.definitions.VM"
  transform: >
    $["x-ms-client-name"] = "VirtualMachine";
```

### Property Rename

Let's say we want to rename the following property from `id` to `identifier`.

```yaml
...
"definitions": {
    "VM": {
        "type": "object"
        "properties": {
            "id": {
                ...
            }
        }
    }
    ...
}
```

We refer to the property based on its location in its parent object, giving us filter `where: #.definitions.VM.properties.id`. Similar to a [model](#model-rename "model"), we have to use
[`x-ms-client-name`][x_ms_client_name] since there's no `name` field to change. This gives us

```yaml
### Directive renaming "id" property to "identifier"
directive:
  from: swagger-document
  where: "$.definitions.VM.properties.id"
  transform: >
    $["x-ms-client-name"] = "identifier";
```

### Enum Value Rename

Renaming an enum requires referencing the [`x-ms-enum`][x_ms_enum] used to define the enum. In this scenario, we're looking to change the name of an enum value from `AzureVM` to `AzureVirtualMachine`.
As you can see from the swagger:

```yaml
...
"definitions": {
    "VM": {
        "type": "object"
        "properties": {
            "virtualMachineType": {
                "type": "string",
                "enum": [
                    "Azure_VM",
                    ...
                ],
                "x-ms-enum": {
                    "name": "VirtualMachineTypes",
                    "values": [
                        {
                            "value": "Azure_VM"
                            "name": "AzureVM"
                            ...
                        },
                        ...
                    ]
                }
            }
        }
    }
    ...
}
```

This gives us directive

```yaml
### Directive renaming enum AzureVM to AzureVirtualMachine
directive:
  from: swagger-document
  where: "$.definitions.VM.properties.virtualMachineType.x-ms-enum.values[0]"
  transform: >
    $["x-ms-client-name"] = "AzureVirtualMachine";
```

Now, we would access the enum through `VirtualMachineTypes.AzureVirtualMachine` instead of `VirtualMachineTypes.AzureVM`.

### Change Description

Changing a description is very similar whether you're changing an operation's description or a model's description etc. The only thing that varies is how to refer to the object whose description your changing. Since this is covered in the previous examples, we won't do separate sections for this. Instead, we will show you how to change a property's description, which can be easily extended to another object, i.e. an operation.

Let's say we [renamed the property](#property-rename "Property Rename") from `id` to `identifier`, and we want to change all references in the description of `id` to `identifier`:

```yaml
...
"definitions": {
    "VM": {
        "type": "object"
        "properties": {
            "id": {
                "description": "The 'id' property is used to identify your VM instance.
            }
        }
    }
    ...
}
```

We once again refer to the property's location as `where: #.definitions.VM.properties.id`, and we want to change the `description` field in the property. This gives uss

```yaml
### Directive changing references of 'id' to 'identifier' in the 'identifier' property's description
directive:
  from: swagger-document
  where: "$.definitions.VM.properties.id"
  transform: >
    $["description"] = $["description].replace("'id'", "'identifier'");
```

For language-specific directives, see the ones for:

- [Python][python]

<!-- LINKS -->

[python]: https://github.com/Azure/autorest.python/blob/autorestv3/docs/generate/directives.md
[paths]: https://swagger.io/docs/specification/paths-and-operations/
[parameters]: https://swagger.io/docs/specification/describing-parameters/
[components]: https://swagger.io/docs/specification/components/
[x_ms_client_name]: https://github.com/Azure/autorest/blob/master/docs/extensions/readme.md#x-ms-client-name
[x_ms_enum]: https://github.com/Azure/autorest/blob/master/docs/extensions/readme.md#x-ms-enum
