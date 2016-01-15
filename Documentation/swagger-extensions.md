# AutoRest Extensions for Swagger 2.0

## Introduction
The following documents describes AutoRest specific vendor extensions for [Swagger 2.0](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md) schema. Some of the extensions are only applicable to Microsoft Azure and as such are only available in Azure code generators (e.g. Azure.CSharp, Azure.NodeJS, etc.).

## Generic Extensions
* [x-ms-code-generation-settings](#x-ms-code-generation-settings) - enables passing code generation settings via swagger document
* [x-ms-skip-url-encoding](#x-ms-skip-url-encoding) - skips URL encoding for path and query parameters
* [x-ms-enum](#x-ms-enum) - additional metadata for enums
* [x-ms-parameter-grouping](#x-ms-parameter-grouping) - groups method parameters in generated clients
* [x-ms-paths](#x-ms-paths) - alternative to [Paths Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathsObject) that allows [Path Item Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathItemObject) to have query parameters for non pure REST APIs
* x-ms-client-name - *not currently implemented*
* [x-ms-external](#x-ms-external) - allows specific [Definition Objects](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject) to be excluded from code generation
* [x-ms-discriminator-value](#x-ms-discriminator-value) - maps discriminator value on the wire with the definition name.

## Microsoft Azure Extensions
* [x-ms-odata](#x-ms-odata) - indicates the operation includes one or more [OData](http://www.odata.org/) query parameters.
* [x-ms-pageable](#x-ms-pageable) - allows paging through lists of data.
* [x-ms-long-running-operation](#x-ms-long-running-operation) - indicates that the operation implemented Long Running Operation pattern as defined by the [Resource Managemer API](https://msdn.microsoft.com/en-us/library/azure/dn790568.aspx).
* [x-ms-azure-resource](#x-ms-azure-resource) - indicates that the [Definition Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject) is a resource as defined by the [Resource Managemer API](https://msdn.microsoft.com/en-us/library/azure/dn790568.aspx)
* [x-ms-request-id](#x-ms-request-id) - allows to overwrite the request id header name
* [x-ms-client-request-id](#x-ms-client-request-id) - allows to overwrite the client request id header name

##x-ms-code-generation-settings
`x-ms-code-generation-settings` extension on `info` element enables passing code generation settings via swagger document.

**Parent element**: [Info Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#infoObject)

**Schema**: 
Field Name | Type | Description
---|:---:|---
.*| `string` or `bool` | **Required**. Field name should be a valid autorest.exe parameter. Value should be a valid string value or boolean for flag parameters

**Example**:
```js
"info": {
   "x-ms-code-generation-settings": {
      "header": "MIT",
      "internalConstructors": true
   }
}
```

## x-ms-skip-url-encoding
By default, `path` parameters will be URL-encoded automatically. This is a good default choice for user-provided values. This is not a good choice when the parameter is provided from a source where the value is known to be URL-encoded. The URL encoding is NOT an idempotent operation. For example, the percent character "%" is URL-encoded as "%25". If the parameter is URL-encoded again, "%25" becomes "%2525". Mark parameters where the source is KNOWN to be URL-encoded to prevent the automatic encoding behavior.

**Parent element**: [Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject)

**Schema**: 
`true|false`

**Example**:
```js
"parameters": [
  {
    "name": "databaseName",
    "in": "path",
    "type": "string",
    "required": true,
    "x-ms-skip-url-encoding": true
  }
]
```

## x-ms-enum
Enum definitions in Swagger indicate that only a particular set of values may be used for a property or parameter. When the property is represented on the wire as a string, it would be a natural choice to represent the property type in C# and Java as an enum. However, not all enumeration values should necessarily be represented as strongly typed enums - there are additional considerations, such as how often expected values might change, since adding a new value to a strongly typed enum is a breaking change requiring an updated API version. Additionally, there is some metadata that is required to create a useful enum, such as a descriptive name, which is not represented in swagger. For this reason, enums are not automatically turned into strongly typed enum types - instead they are rendered in the documentation comments for the property or parameter to indicate allowed values. To indicate that an enum will rarely change and that C#/Java enum semantics are desired, use the `x-ms-enum` exension. Note that depending on the code generation language the behavior of this extension may differ.

In C# and Java, an enum type is generated and is declared as the type of the related request/response object. The enum is serialized as the string expected by the REST API.

**Parent element**: [Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject), [Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject), [Items Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#itemsObject), or [Header Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#headerObject)

**Schema**:

Field Name | Type | Description
---|:---:|---
name | `string` | **Required**. Specifies the name for the Enum.
modelAsString | `boolean` | When set to `true` the enum will be modeled as a string. No validation will happen. When set to `false`, it will be modeled as an enum if that language supports enums. Validation will happen, irrespective of support of enums in that language.

**Example**:
```js
  "accountType": {
    "type": "string",
    "enum": [
      "Standard_LRS",
      "Standard_ZRS",
      "Standard_GRS",
      "Standard_RAGRS",
      "Premium_LRS"
    ],
    "x-ms-enum": {
      "name": "AccountType",
      "modelAsString": false
    }
  }
```

##x-ms-parameter-grouping
By default operation parameters are generated in the client as method arguments. This behavior can sometimes be undesirable when the number of parameters is high. `x-ms-parameter-grouping` extension is used to group multiple primitive parameters into a composite type to improve the API.

**Parent element**: [Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject)

**Schema**:

Field Name | Type | Description
---|:---:|---
name | `string` | When set, specifies the name for the composite type.
postfix | `string` | Alternative to `name` parameter. If specified the name of the composite type will be generated as follows `{MethodGroup}{Method}{Postfix}`.

If none of the parameters are set the name of the composite type is generated as follows `{MethodGroup}{Method}Parameters`.

**Example**:
```js
"/some/{pathParam1}/{pathParam2}": {
  "operationId": "Update",
  "post": {
    "parameters": [
    {
        "name": "headerParam",
        "in": "header",
        "type": "string",
        "required": false,
        "x-ms-parameter-grouping": {
          "name": "custom-parameter-group"
        }
    },
    {
        "name": "pathParam1",
        "in": "path",
        "type": "string",
        "required": true,
        "x-ms-parameter-grouping": {
          "name": "custom-parameter-group"
        }
    },
    {
        "name": "pathParam2",
        "in": "path",
        "type": "string",
        "required": true,
        "x-ms-parameter-grouping": {
          "name": "custom-parameter-group"
        }
    }]
  }
}
```
Above Swagger schema will produce a type CustomParameterGroup with 3 properties (if applicable in the generator language).

## x-ms-paths

Swagger 2.0 has a built-in limitation on paths. Only one operation can be mapped to a path and http method. There are some APIs, however, where multiple distinct operations are mapped to the same path and same http method. For example `GET /mypath/query-drive?op=file` and `GET /mypath/query-drive?op=folder` may return two different model types (stream in the first example and JSON model representing Folder in the second). Since Swagger does not treat query parameters as part of the path the above 2 operations may not co-exist in the standard "paths" element.

To overcome this limitation an "x-ms-paths" extension was introduced parallel to "paths". Urls under "x-ms-paths" are allowed to have query parameters for disambiguation, however they are removed during model parsing.

**Parent element**: [Swagger Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swaggerObject)

**Schema**:
The `x-ms-paths` extension has the same schema as [Paths Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathsObject) with exception that [Path Item Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathItemObject) can have query parameters.

**Example**:
```js
"paths":{
   "/pets": {
        "get": {
            "parameters": [
                {
                     "name": "name",
                     "required": true
                }
            ]
        }
   }
},
"x-ms-paths":{   
   "/pets?color={color}": {
        "get": {}
   },
}
```

##x-ms-external
To allow generated clients to share models via shared libraries an `x-ms-external` extension was introduced. When a [Definition Objects](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject) contains this extensions it's definition will be excluded from generated library. Note that in strongly typed languages the code will not compile unless the assembly containing the type is referenced with the project/library. 

**Parent element**: [Definition Objects](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject)

**Schema**:
`true|false`

**Example**:
```js
{
  "definitions": {
    "Product": {
      "x-ms-external" : true,
      "properties": {
        "product_id": {
          "type": "string"          
        }
     }
  }
}        
```

##x-ms-discriminator-value
Swagger 2.0 specification requires that when used, the value of `discriminator` field MUST match the name of the schema or any schema that inherits it. To overcome this limitation `x-ms-discriminator-value` extension was introduced.

**Schema**:
`string` - the expected value of the `discriminator` field on the wire.

**Parent element**:  [Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject)

**Example**:
```js
"definitions": {
  "SqlDefinition": {
      "x-ms-discriminator-value": "USql",
      "allOf": [
        {
          "$ref": "#/definitions/SqlProperties"
        }
      ]
   }
}
```

##x-ms-odata
When present the `x-ms-odata` extensions indicates the operation includes one or more [OData](http://www.odata.org/) query parameters. These parameters inlude `$filter`, `$top`, `$orderby`,  `$skip`,  and `$expand`. In some languages the generated method will expose these parameters as strongly types OData type.

**Schema**:
[`ref`](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#referenceObject) to the definition that describes object used in filter.

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Example**:
```js
"paths": {    
  "/subscriptions/resource": {
    "get": {
      "x-ms-odata": "#/definitions/Product"
    }
  }
}
```

##x-ms-pageable
The REST API guidelines define a common pattern for paging through lists of data. The operation response is modeled in Swagger as the list of items and the nextLink. Tag the operation as `x-ms-pageable` and the generated code will include methods for navigating between pages.

**Schema**:

Field Name | Type | Description
---|:---:|---
nextLinkName| `string` | Specifies the name of the property that provides the nextLink. If the model does not have the nextLink property then specify null.
itemName | `string` | Specifies the name of the property that provides the collection of pageable items. Default value is 'value'.{Postfix}`.
operationName | `string` | Specifies the name of the Next operation. Default value is 'XXXNext' where XXX is the name of the operation

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Example**:
x-ms-pageable operation definition
```js
"paths": {
  "/products": {
    "get": {
      "x-ms-pageable": {
        "nextLinkName": "nextLink"
      },
      "operationId": "products_list",
      "description": "A pageable list of Products.",
      "responses": {
        "200": {
          "schema": {
            "$ref": "#/definitions/ProductListResult"
          }
        }
      }
    }
  }
}
```
x-ms-pageable model definition
```js
"ProductListResult": {
  "properties": {
    "value": {
      "type": "array",
      "items": {
        "$ref": "#/definitions/Product"
      }
    },
    "nextLink": {
      "type": "string"
    }
  }
}
```

##x-ms-long-running-operation
Some requests like creating/deleting a resource cannot be carried out immediately. In such a situation, the server sends a 201 (Created) or 202 (Accepted) and provides a link to monitor the status of the request. When such an operation is marked with extension `"x-ms-long-running-operation": true`, in Swagger, the generated code will know how to fetch the link to monitor the status. It will keep on polling at regular intervals till the request reaches one of the terminal states: Succeeded, Failed, or Canceled.

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Schema**: 
`true|false`

**Example**:
```js
"paths": {
  "/products/{name}": {
    "put": {
      "operationId": "products_create",
      "x-ms-long-running-operation": true,
      "description": "A pageable list of Products."
    }
  }
}
```

##x-ms-azure-resource
Resource types as defined by the [Resource Managemer API](https://msdn.microsoft.com/en-us/library/azure/dn790568.aspx) are tagged by using a `x-ms-azure-resource` extension.

**Parent element**:  [Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject)

**Schema**: 
`true|false`

**Example**:
```js
"Resource": {
  "x-ms-azure-resource": true,
  "properties": {
    "id": {
      "type": "string",
      "readOnly": true,
      "description": "Resource Id"
    }
  }
}
```

##x-ms-request-id
When set, allows to overwrite the `x-ms-request-id` response header (default is x-ms-request-id).

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Schema**: 
`string` - the name of the request id header to use when setting Response.RequestId property.

**Example**:
```js
"paths": {
  "/products/{name}": {
    "get": {
      "operationId": "products_create",
      "x-ms-request-id": "request-id"
    }
  }
}
```

##x-ms-client-request-id
When set, specifies the header parameter to be used instead of `x-ms-client-request-id` (default is x-ms-client-request-id).

**Parent element**:  [Header Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject)

**Schema**: 
`string` - the name of the client request id header to use when setting sending request.

**Example**:
```js
"paths": {
  "/products/{name}": {
    "get": {
      "operationId": "products_create",
      "parameters": [{
        "name": "x-ms-client-request-id",
        "in": "header",
        "type": "string",
        "required": false,
        "x-ms-client-request-id": true
      }]
    }
  }
}
```
