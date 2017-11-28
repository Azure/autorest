# AutoRest Extensions for OpenAPI 2.0

### Introduction
The following documents describes AutoRest specific vendor extensions for [OpenAPI 2.0](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md) schema. Some of the extensions are only applicable to Microsoft Azure and as such are only available in Azure code generators (e.g. Azure.CSharp, Azure.NodeJS, etc.).

### Generic Extensions
* [x-ms-code-generation-settings](#x-ms-code-generation-settings) - enables passing code generation settings via OpenAPI definition (*deprecated! Please use configuration files instead.*)
* [x-ms-skip-url-encoding](#x-ms-skip-url-encoding) - skips URL encoding for path and query parameters
* [x-ms-enum](#x-ms-enum) - additional metadata for enums
* [x-ms-parameter-grouping](#x-ms-parameter-grouping) - groups method parameters in generated clients
* [x-ms-parameter-location](#x-ms-parameter-location) - provides a mechanism to specify that the global parameter is actually a parameter on the operation and not a client property.
* [x-ms-paths](#x-ms-paths) - alternative to [Paths Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathsObject) that allows [Path Item Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathItemObject) to have query parameters for non pure REST APIs
* [x-ms-client-name](#x-ms-client-name) - allows control over identifier names used in client-side code generation for parameters and schema properties.
* [x-ms-external](#x-ms-external) - allows specific [Definition Objects](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject) to be excluded from code generation
* [x-ms-discriminator-value](#x-ms-discriminator-value) - maps discriminator value on the wire with the definition name.
* [x-ms-client-flatten](#x-ms-client-flatten) - flattens client model property or parameter.
* [x-ms-parameterized-host](#x-ms-parameterized-host) - replaces the fixed host with a host template that can be replaced with variable parameters.
* [x-ms-mutability](#x-ms-mutability) - provides insight to Autorest on how to generate code. It doesn't alter the modeling of what is actually sent on the wire.
* [x-ms-examples](#x-ms-examples) - describes the format for specifying examples for request and response of an operation in an OpenAPI definition.

### Microsoft Azure Extensions (available in most generators only when using `--azure-arm`)
* [x-ms-odata](#x-ms-odata) - indicates the operation includes one or more [OData](http://www.odata.org/) query parameters.
* [x-ms-pageable](#x-ms-pageable) - allows paging through lists of data.
* [x-ms-long-running-operation](#x-ms-long-running-operation) - indicates that the operation implemented Long Running Operation pattern as defined by the [Resource Managemer API](https://msdn.microsoft.com/en-us/library/azure/dn790568.aspx).
* [x-ms-azure-resource](#x-ms-azure-resource) - indicates that the [Definition Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject) is a resource as defined by the [Resource Managemer API](https://msdn.microsoft.com/en-us/library/azure/dn790568.aspx)
* [x-ms-request-id](#x-ms-request-id) - allows to overwrite the request id header name
* [x-ms-client-request-id](#x-ms-client-request-id) - allows to overwrite the client request id header name

# Generic Extensions

## x-ms-code-generation-settings
`x-ms-code-generation-settings` extension on `info` element enables passing code generation settings via the OpenAPI definition.

**Parent element**: [Info Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#infoObject)

**Schema**: 

Field Name | Type | Description
---|:---:|---
.*| `string` or `bool` | **Required**. Field name should be a valid autorest.exe parameter. Value should be a valid string value or boolean for flag parameters

**Example**:
```json5
"info": {
   "x-ms-code-generation-settings": {
      "header": "MIT",
      "internalConstructors": true,
      "useDateTimeOffset": true
   }
}
```

## x-ms-skip-url-encoding
By default, `path` parameters will be URL-encoded automatically. This is a good default choice for user-provided values. This is not a good choice when the parameter is provided from a source where the value is known to be URL-encoded. The URL encoding is NOT an idempotent operation. For example, the percent character "%" is URL-encoded as "%25". If the parameter is URL-encoded again, "%25" becomes "%2525". Mark parameters where the source is KNOWN to be URL-encoded to prevent the automatic encoding behavior.

**Parent element**: [Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject)

**Schema**: 
`true|false`

**Example**:
```json5
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
Enum definitions in OpenAPI indicate that only a particular set of values may be used for a property or parameter. When the property is represented on the wire as a string, it would be a natural choice to represent the property type in C# and Java as an enum. However, not all enumeration values should necessarily be represented as strongly typed enums - there are additional considerations, such as how often expected values might change, since adding a new value to a strongly typed enum is a breaking change requiring an updated API version. Additionally, there is some metadata that is required to create a useful enum, such as a descriptive name, which is not represented in vanilla OpenAPI. For this reason, enums are not automatically turned into strongly typed enum types - instead they are rendered in the documentation comments for the property or parameter to indicate allowed values. To indicate that an enum will rarely change and that C#/Java enum semantics are desired, use the `x-ms-enum` exension. Note that depending on the code generation language the behavior of this extension may differ.

In C# and Java, an enum type is generated and is declared as the type of the related request/response object. The enum is serialized as the string expected by the REST API.

**Parent element**: [Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject), [Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject), [Items Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#itemsObject), or [Header Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#headerObject)

**Schema**:

Field Name | Type | Description
---|:---:|---
name | `string` | **Required**. Specifies the name for the Enum.
modelAsString | `boolean` | **Default: false** When set to `true` the enum will be modeled as a string. No validation will happen. When set to `false`, it will be modeled as an enum if that language supports enums. Validation will happen, irrespective of support of enums in that language.
values | `[{ value: any, description?: string, name?: string }]` | **Default: undefined** When set, this will override the values specified with `enum`, while also enabling further customization. We recommend still specifying `enum` as a fallback for consumers that don't understand `x-ms-enum`. Each item in `x-ms-enum` corresponds to an enum item. Property `value` is mandatory and corresponds to the value one would also have specified using `enum`. Properties `description` and `name` are optional. `name` allows overriding the name of the enum value that would usually be derived from the value.

**Example**:
```yaml
accountType:
  type: string
  enum:
  - Standard_LRS
  - Standard_ZRS
  - Standard_GRS
  - Standard_RAGRS
  - Premium_LRS
  x-ms-enum:
    name: AccountType
    modelAsString: false
    values:
    - value: Standard_LRS
      description: Locally redundant storage.
      name: StandardLocalRedundancy
    - value: Standard_ZRS
      description: Zone-redundant storage.
    - value: Standard_GRS
      name: StandardGeoRedundancy
    - value: Standard_RAGRS
    - value: Premium_LRS
```

### Single value enum as a constant
- If the **single value** enum is a **required** model property or a **required** parameter then it is always treated as a constant. The `x-ms-enum` extension **is ignored**. 
  - Explanation: The above condition specifies that the server always expects the model property or the parameter and with a specific value. Hence, it makes sense to treat it as a constant. In the future, if more values are added to the enum then, it is a breaking change to the API provided by the client library.
- If the **single value** enum is an **optional** model property or an **optional** parameter and if `x-ms-enum` extension is provided then it will be honoured.

## x-ms-parameter-grouping
By default operation parameters are generated in the client as method arguments. This behavior can sometimes be undesirable when the number of parameters is high. `x-ms-parameter-grouping` extension is used to group multiple primitive parameters into a composite type to improve the API.

**Parent element**: [Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject)

**Schema**:

Field Name | Type | Description
---|:---:|---
name | `string` | When set, specifies the name for the composite type.
postfix | `string` | Alternative to `name` parameter. If specified the name of the composite type will be generated as follows `{MethodGroup}{Method}{Postfix}`.

If none of the parameters are set the name of the composite type is generated as follows `{MethodGroup}{Method}Parameters`.

**Example**:
```json5
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
Above OpenAPI definition will produce a type CustomParameterGroup with 3 properties (if applicable in the generator language).

## x-ms-parameter-location

By default Autorest processes global parameters as properties on the client. For example `subscriptionId` and `apiVersion` which are defined in the global parameters section end up being properties of the client. It would be natural to define resourceGroupName once in the global parameters section and then reference it everywhere, rather than repeating the same definition inline everywhere. One **may not** want resourceGroupName as a property on the client, just because it is defined in the global parameters section. This extension helps you achieve that. You can add this extension with value "method" 
`"x-ms-parameter-location": "method"` and resourceGroupName will not be a client property. 

Note:
- Valid values for this extension are: **"client", "method"**.
- **This extension can only be applied on global parameters. If this is applied on any parameter in an operation then it will be ignored.**

**Example:**
```json5
{
  "swagger": "2.0",
  "host": "management.azure.com",
  "info": {
    "title": "AwesomeClient",
    "version": "2015-05-01"
  },
  "paths": {
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}": {
      "put": {
        "operationId": "StorageAccounts_Create",
        . . .
        "parameters": [
          {
            "$ref": "#/parameters/ResourceGroupName"   <<<<<<<<<<<<<<<<<<<<
          },
          {
            "name": "accountName",
            "in": "path",
            "required": true,
            "type": "string",
            "description": "The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  "
          },
          {
            "name": "parameters",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/StorageAccountCreateParameters"
            },
            "description": "The parameters to provide for the created account."
          },
          {
            "$ref": "#/parameters/ApiVersionParameter"
          },
          {
            "$ref": "#/parameters/SubscriptionIdParameter"
          }
        ]
        . . .
      }
    }
  },
  . . .
  "parameters": {
    "SubscriptionIdParameter": {
      "name": "subscriptionId",
      "in": "path",
      "required": true,
      "type": "string",
      "description": "Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call."
    },
    "ApiVersionParameter": {
      "name": "api-version",
      "in": "query",
      "required": true,
      "type": "string",
      "description": "Client Api Version."
    },
    "ResourceGroupName": {
      "description": "The name of the resource group within the user’s subscription.",
      "in": "path",
      "name": "resourceGroupName",
      "required": true,
      "type": "string",
      "x-ms-parameter-location": "method" <<<<<<<<<<<<<<<<<<<<<<<<<<<
    }
  }
}
```

- After using the `"x-ms-parameter-location": "method"` extension the generated client will have a method that looks like this:
  - Notice that `resourceGroupName` is the method parameter and not a client property
```csharp
public static StorageAccount Create(this IStorageAccountsOperations operations, string resourceGroupName, string accountName, StorageAccountCreateParameters parameters);
```
- The client constructor looks like this:
```csharp
public partial class StorageManagementClient : ServiceClient<StorageManagementClient>, IStorageManagementClient, IAzureClient
{
    public string SubscriptionId { get; set; } //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    public string ApiVersion { get; private set; }  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    public StorageManagementClient(Uri baseUri, ServiceClientCredentials credentials, params DelegatingHandler[] handlers) : this(handlers)
    {
        if (baseUri == null)
        {
            throw new ArgumentNullException("baseUri");
        }
        if (credentials == null)
        {
            throw new ArgumentNullException("credentials");
        }
        this.Credentials = credentials;
        if (this.Credentials != null)
        {
            this.Credentials.InitializeServiceClient(this);
        }
    }

    private void Initialize()
    {
        this.StorageAccounts = new StorageAccountsOperations(this);
        this.Usage = new UsageOperations(this);
        this.BaseUri = new Uri("https://management.azure.com");
        this.ApiVersion = "2016-01-01";
        . . .
    }
}
```
## x-ms-paths

OpenAPI 2.0 has a built-in limitation on paths. Only one operation can be mapped to a path and http method. There are some APIs, however, where multiple distinct operations are mapped to the same path and same http method. For example `GET /mypath/query-drive?op=file` and `GET /mypath/query-drive?op=folder` may return two different model types (stream in the first example and JSON model representing Folder in the second). Since OpenAPI does not treat query parameters as part of the path the above 2 operations may not co-exist in the standard "paths" element.

To overcome this limitation an "x-ms-paths" extension was introduced parallel to "paths". URLs under "x-ms-paths" are allowed to have query parameters for disambiguation, however they are not actually used.


**Parent element**: [Swagger Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swaggerObject)

**Schema**:
The `x-ms-paths` extension has the same schema as [Paths Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathsObject) with exception that [Path Item Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathItemObject) can have query parameters.

**Example**:
```yaml
paths:
   "/pets":
        get:
            ...
x-ms-paths:
   "/pets?color={color}":
        get:
            parameters:
              - name: color
                in: query
                # Declaring this parameter is still necessary! 
                # The `?color={color}` part of the path is
                # completely ignored and only serves the purpose
                # of disambiguation and documentation.
            ...
```

As in the example above, there should be one "overload" of the operation in the `paths` section.
While technically this is not necessary (one could have put both `/pets` and `/pets?color={color}` into `x-ms-paths`), it makes sense to resort to `x-ms-paths` as little as possible in order to provide other OpenAPI tools with as much information as possible.
We recommend putting the most generic overload into the `paths` section.

## x-ms-client-name

In some situations, data passed by name, such as query parameters, entity headers, or elements of a JSON document body, are not suitable for use in client-side code.
For example, a header like 'x-ms-version' would turn out like xMsVersion, or x_ms_version, or XMsVersion, depending on the preferences of a particular code generator.
It may be better to allow a code generator to use 'version' as the name of the parameter in client code.

By using the 'x-ms-client-name' extension, a name can be defined for use specifically in code generation, separately from the name on the wire.
It can be used for query parameters and header parameters, as well as properties of schemas.  

**Parameter Example**:
```json5
  "parameters": {
    "ApiVersionParameter": {
      "name": "x-ms-version",
      "x-ms-client-name": "version",
      "in": "header",
      "required": false,
      "type": "string",
      "x-ms-global": true,
      "enum": [
        "2015-04-05",
        "2014-02-14",
        "2013-08-15",
        "2012-02-12",
        "2011-08-18",
        "2009-09-19",
        "2009-07-17",
        "2009-04-14"
      ],
      "default": "2015-04-05",
      "description": "Specifies the version of the operation to use for this request."
    }
```

**Property Example**:
```json5
{
  "definitions": {
    "Product": {
      "x-ms-external" : true,
      "properties": {
        "product_id": {
          "type": "string"
		  "x-ms-client-name": "SKU"          
        }
     }
  }
}        
```

## x-ms-external
To allow generated clients to share models via shared libraries an `x-ms-external` extension was introduced. When a [Definition Objects](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject) contains this extensions it's definition will be excluded from generated library. Note that in strongly typed languages the code will not compile unless the assembly containing the type is referenced with the project/library. 

**Parent element**: [Definition Objects](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject)

**Schema**:
`true|false`

**Example**:
```json5
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

## x-ms-discriminator-value
Swagger 2.0 specification requires that when used, the value of `discriminator` field MUST match the name of the schema or any schema that inherits it. To overcome this limitation `x-ms-discriminator-value` extension was introduced.

**Schema**:
`string` - the expected value of the `discriminator` field on the wire.

**Parent element**:  [Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject)

**Example**:
```json5
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

## x-ms-client-flatten
This extension allows to flatten deeply nested payloads into a more user friendly object. For example a payload that looks like this on the wire:
```json5
{
  "template": {
    "name": "some name",
    "properties": {
      "prop1": "value1",
      "prop2": "value2",
      "url": {
        "value": "http://myurl"
      }    
    } 
  }
}
```
can be transformed into the following client model:
```cs
public class Template 
{
    public string Name {get;set;}
    public string Prop1 {get;set;}
    public string Prop2 {get;set;}
    public string UrlValue {get;set;}
}
```
by using the following OpenAPI definition:
```json5
"definitions": {
  "template": {
    "properties": {
      "name": {
        "type": "string"
      },
      "properties": {
        "x-ms-client-flatten": true,
        "$ref": "#/definitions/templateProperties"
      } 
    }
  }
}
```
It's also possible to flatten body parameters so that the method will look like this:
```cs
client.DeployTemplate("some name", "value1", "value2", "http://myurl");
```
by using the following OpenAPI definition:
```json5
"post": {
  "operationId": "DeployTemplate",        
  "parameters": [
  {
     "name": "body",
     "in": "body",
     "x-ms-client-flatten": true,
     "schema": {
       "$ref": "#/definitions/template"
     }
    }
  ]
}
```

**Parent element**: [Parameter Objects](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#parameterObject) or [Property on the Schema Definition](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#schemaObject). In both cases the `type` of the parameter or property should be a complex schema with properties.

**Schema**:
`true|false`

**Example**:
```json5
"definitions": {
  "template": {
    "properties": {
      "name": {
        "type": "string"
      },
      "properties": {
        "x-ms-client-flatten": true,
        "$ref": "#/definitions/templateProperties"
	    } 
    }
  }
}
```
and
```json5
"post": {
  "operationId": "DeployTemplate",        
  "parameters": [
  {
     "name": "body",
     "in": "body",
     "x-ms-client-flatten": true,
     "schema": {
       "$ref": "#/definitions/template"
     }
    }
  ]
}
```

## x-ms-parameterized-host
When used, replaces the standard OpenAPI "host" attribute with a host that contains variables to be replaced as part of method execution or client construction, very similar to how path parameters work.

**Parent element**:  [Info Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#infoObject)

**Schema**: 

Field Name | Type | Description
---|:---:|---
hostTemplate | `string` | **Required**. Specifies the parameterized template for the host.
useSchemePrefix | `boolean` | **Optional, Default: true**. Specifes whether to prepend the default scheme a.k.a protocol to the base uri of client.
positionInOperation | `string` | **Optional, Default: first**. Specifies whether the list of parameters will appear in the beginning or in the end, in the method signature for every operation. The order within the parameters provided in the below mentioned array will be preserved. Either the array of parameters will be prepended or appended, based on the value provided over here. Valid values are **"first", "last"**. Every method/operation in any programming language has parameters categorized into two buckets **"required"** and **"optional"**. It is natural for optional parameters to appear in the end in a method signature. **This aspect will be preserved, while prepending(first) or appending(last) hostTemplate parameters .** 
parameters | [Array of Parameter Objects](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#parameterObject) | The list of parameters that are used within the hostTemplate. This can include both reference parameters as well as explicit parameters. Note that "in" is **required** and **must be** set to **"path"**. The reference parameters will be treated as **global parameters** and will end up as property of the client.

**Example**:
- Using both explicit and reference parameters.
   - Since "useSchemePrefix" is not specified, it's default value true will be applied. The user is expected to provide only the value of accountName. The generated code will fit it as a part of the url.
   - Since "positionInOperation" with value "last" is specified, "accountName" will be the last required parameter in every method. "adlaJobDnsSuffixInPath" will be a property on the client as it is defined in the global parameters section and is referenced here.

```json5
"x-ms-parameterized-host": {
    "hostTemplate": "{accountName}.{adlaJobDnsSuffix}",
    "positionInOperation": "last",
    "parameters": [
      {
        "name": "accountName",
        "description": "The Azure Data Lake Analytics account to execute job operations on.",
        "required": true,
        "type": "string",
        "in": "path",
        "x-ms-skip-url-encoding": true
      },
      {
        "$ref": "#/parameters/adlaJobDnsSuffixInPath"
      }
    ]
  }
...
"adlaJobDnsSuffixInPath": {
      "name": "adlaJobDnsSuffix",
      "in": "path",
      "required": true,
      "type": "string",
      "default": "azuredatalakeanalytics.net",
      "x-ms-skip-url-encoding": true,
      "description": "Gets the DNS suffix used as the base for all Azure Data Lake Analytics Job service requests."
    }
```
- Using explicit parameters and specifying the positionInOperation and schemePrefix. 
   - This means that accountName will be the first required parameter in all the methods and the user is expected to provide a url (protocol + accountName), since "useSchemePrfix" is set to false.
```json5
"x-ms-parameterized-host": {
    "hostTemplate": "{accountName}.mystaticsuffix.com",
    "useSchemePrefix": false,
    "positionInOperation": "first",
    "parameters": [
      {
        "name": "accountName",
        "description": "The Azure Data Lake Analytics account to execute job operations on.",
        "required": true,
        "type": "string",
        "in": "path",
        "x-ms-skip-url-encoding": true
      }
    ]
  }
```

## x-ms-mutability
This extension offers insight to Autorest on how to generate code (mutability of the property of the model classes being generated). It doesn't alter the modeling of the actual payload that is sent on the wire.

It is an array of strings with three possible values. The array cannot have repeatable values. Valid values are: **"create", "read", "update"**.

Field Name | Description
---|:---
**create** | Indicates that the value of the property can be set while creating/initializing/constructing the object
**read** | Indicates that the value of the property can be read
**update** | Indicates that value of the property can be updated anytime(even after the object is created)

### Rules:
- When the extension is applied with all the three values; `"x-ms-mutability": ["create", "read", "update"]` (order of the values is not important) **OR** when this extension is not applied on a model property; it has the same effect in both the cases. Thus applying this extension with all the three values on all the settable properties is not required. This will ensure the spec is visibly cleaner.
- When a property is modeled as `"readonly": true` then,
  - if the x-ms-mutability extension is applied then it can **only have "read" value in the array**. 
  - applying the extension as `"x-ms-mutability": ["read"]` or not applying it will have the same effect.
- When the property is modeled as **`"readonly": false`** then,
  - applying the extension as `"x-ms-mutability": ["read"]` is not allowed.
  - applying the extension as `"x-ms-mutability": ["create", "read", "update"]` or not applying it will have the same effect.
  - applying the extension with anyother **permissible valid combination** should be fine.
- When this extension is applied on a collection (array, dictionary) then this will have effects on the mutability (adding/removing elements) of the collection. Mutabiility of the collection cannot be applied on its elements. The mutability of the element will be governed based on the mutability defined in the element's definition.

Examples:
- Mutability on a model definition
```json5
"definitions": {
  "Resource": {
    "description": "The Resource Model definition.",
    "properties": {
      "id": {
        "readOnly": true,
        "type": "string",
        "description": "Resource Id",
        "x-ms-mutability": ["read"]
      },
      "name": {
        "type": "string",
        "description": "Resource name"
      },
      "type": {
        "type": "string",
        "description": "Resource type",
        "x-ms-mutability": ["read"]
      },
      "location": {
        "type": "string",
        "description": "Resource location",
        "x-ms-mutability": ["create", "read"]
      },
      "tags": {
        "type": "object",
        "additionalProperties": {
          "type": "string"
        },
        "description": "Resource tags",
        "x-ms-mutability": ["create", "read", "update"]
      }
    },
    "required": [
      "location"
    ],
    "x-ms-azure-resource": true
  }
}
```
- Mutability of the object property; which is a collection of items
```json5
"definitions": {
  "ResounceCollection": {
    "description": "Collection of Resource objects. Resource is defined in the above example.",
    "properties": {
      "value": {
        "type": "array",
        "description": "Array of Resource objects.",
        "x-ms-mutability": ["create", "read", "update"], //This means that the array is mutable
        "items": {
          "type": object,
          "x-ms-mutability": ["create", "read"] // X - Applying mutability on the itemType of the array or vauleType of the dictionary is not allowed.
          "schema": {
            "$ref": "#/definitions/Resource" // The mutability of the properties of the Resource object is governed by the mutability defined in it's model definition.
          }
        }
      }
    }
  }
}
```

## x-ms-examples
Describes the format for specifying examples for request and response of an operation in an OpenAPI definition. It is a **dictionary** of different variations of the examples for a given operation.

More information about this extension can be found [here](https://github.com/Azure/azure-rest-api-specs/tree/master/documentation/x-ms-examples.md).

# Microsoft Azure Extensions (available in most generators only when using `--azure-arm`)

## x-ms-odata
When present the `x-ms-odata` extensions indicates the operation includes one or more [OData](http://www.odata.org/) query parameters. These parameters inlude `$filter`, `$top`, `$orderby`,  `$skip`,  and `$expand`. In some languages the generated method will expose these parameters as strongly types OData type.

**Schema**:
[`ref`](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#referenceObject) to the definition that describes object used in filter.

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Example**:
```json5
"paths": {    
  "/subscriptions/resource": {
    "get": {
      "x-ms-odata": "#/definitions/Product"
    }
  }
}
```

## x-ms-pageable
The REST API guidelines define a common pattern for paging through lists of data. The operation response is modeled in OpenAPI as a list of items (a "page") and a link to the next page, effectively resembling a singly linked list. Tag the operation as `x-ms-pageable` and the generated code will include methods for navigating between pages.

**Schema**:

Field Name | Type | Description
---|:---:|---
itemName | `string` | Optional (default: `value`). Specifies the name of the property that provides the collection of pageable items.
nextLinkName| `string` | Required. Specifies the name of the property that provides the next link (common: `nextLink`). If the model does not have a next link property then specify `null`. This is useful for services that return an object that has an array referenced by `itemName`. The object is then flattened in a way that the array is *directly* returned, no paging is used. This provides a better client side API to the end user.
operationName | `string` | Optional (default: `<operationName>Next`). Specifies the name of the operation for retrieving the next page.

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Example 1: Canonical**

Basic use of `x-ms-pageable`:
```YAML
swagger: '2.0'
info:
  version: 1.0.0
  title: Simple API
produces:
  - application/json
paths:
  /getIntegers:
    get:
      operationId: list
      description: "Gets those integers."
      x-ms-pageable:                            # EXTENSION
        nextLinkName: nextLink                  # property name for next page URL
      responses:
        200:
          description: OK
          schema:
            $ref: '#/definitions/PagedIntegerCollection'
definitions:
  PagedIntegerCollection:
    description: "Page of integers."
    type: object
    properties:
      value:                                    # the current page
        type: array
        items:
          type: integer
      nextLink:                                 # next page URL (referred to by "nextLinkName")
        type: string
```
Generated signatures:
```C#
IPage<int?>       List(ISimpleAPIClient operations);
Task<IPage<int?>> ListAsync(ISimpleAPIClient operations, CancellationToken cancellationToken);
IPage<int?>       ListNext(ISimpleAPIClient operations, string nextPageLink);
Task<IPage<int?>> ListNextAsync(ISimpleAPIClient operations, string nextPageLink, CancellationToken cancellationToken);
```
Full code:
[example1.yaml](x-ms-pageable/example1.yaml),
[example1.cs](x-ms-pageable/example1.cs)

**Example 2: Customized**

Customizing code generation:
```YAML
swagger: '2.0'
info:
  version: 1.0.0
  title: Simple API
produces:
  - application/json
paths:
  /getIntegers:
    get:
      operationId: list
      description: "Gets those integers."
      x-ms-pageable:                            # EXTENSION
        nextLinkName: nextIntegersUrl           # property name for next page URL
        value: payload                          # property name for current page (overrides "value")
        operationName: listMore                 # method name for retrieving next page (overrides "listNext")
      responses:
        200:
          description: OK
          schema:
            $ref: '#/definitions/PagedIntegerCollection'
definitions:
  PagedIntegerCollection:
    description: "Page of integers."
    type: object
    properties:
      payload:                                  # the current page (referred to by "value")
        type: array
        items:
          type: integer
      nextIntegersUrl:                          # next page URL (referred to by "nextLinkName")
        type: string
```
Generated signatures:
```C#
IPage<int?>       List(ISimpleAPIClient operations);
Task<IPage<int?>> ListAsync(ISimpleAPIClient operations, CancellationToken cancellationToken);
IPage<int?>       ListMore(ISimpleAPIClient operations, string nextPageLink);
Task<IPage<int?>> ListMoreAsync(ISimpleAPIClient operations, string nextPageLink, CancellationToken cancellationToken);
```
Full code:
[example2.yaml](x-ms-pageable/example2.yaml),
[example2.cs](x-ms-pageable/example2.cs)

**Example 3: Single page result**

Providing a better user experience for single page response models:
```YAML
swagger: '2.0'
info:
  version: 1.0.0
  title: Simple API
produces:
  - application/json
paths:
  /getIntegers:
    get:
      operationId: list
      description: "Gets those integers."
      x-ms-pageable:
        nextLinkName: null                      # there are no further pages
        value: payload                          # property name for the "page" (overrides "value")
      responses:
        200:
          description: OK
          schema:
            $ref: '#/definitions/PagedIntegerCollection'
definitions:
  PagedIntegerCollection:
    description: "Page of integers."
    type: object
    properties:
      payload:                                  # the only "page" (referred to by "value")
        type: array
        items:
          type: integer
```
Generated signatures:
```C#
IEnumerable<int?>       List(ISimpleAPIClient operations);
Task<IEnumerable<int?>> ListAsync(ISimpleAPIClient operations, CancellationToken cancellationToken);
```
Full code:
[example3.yaml](x-ms-pageable/example3.yaml),
[example3.cs](x-ms-pageable/example3.cs)


## x-ms-long-running-operation
Some requests like creating/deleting a resource cannot be carried out immediately. In such a situation, the server sends a 201 (Created) or 202 (Accepted) and provides a link to monitor the status of the request. When such an operation is marked with extension `"x-ms-long-running-operation": true`, in OpenAPI, the generated code will know how to fetch the link to monitor the status. It will keep on polling at regular intervals till the request reaches one of the terminal states: Succeeded, Failed, or Canceled.

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Schema**: 
`true|false`

**Example**:
```json5
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

## x-ms-azure-resource
Resource types as defined by the [Resource Managemer API](https://msdn.microsoft.com/en-us/library/azure/dn790568.aspx) are tagged by using a `x-ms-azure-resource` extension.

**Parent element**:  [Schema Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject)

**Schema**: 
`true|false`

**Example**:
```json5
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

## x-ms-request-id
When set, allows to overwrite the `x-ms-request-id` response header (default is x-ms-request-id).

**Parent element**:  [Operation Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject)

**Schema**: 
`string` - the name of the request id header to use when setting Response.RequestId property.

**Example**:
```json5
"paths": {
  "/products/{name}": {
    "get": {
      "operationId": "products_create",
      "x-ms-request-id": "request-id"
    }
  }
}
```

## x-ms-client-request-id
When set, specifies the header parameter to be used instead of `x-ms-client-request-id` (default is x-ms-client-request-id).

**Parent element**:  [Header Parameter Object](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject)

**Schema**: 
`string` - the name of the client request id header to use when setting sending request.

**Example**:
```json5
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
