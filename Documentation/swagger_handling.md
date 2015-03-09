
#AutoRest Swagger Handling

This documentation introduces the rules AutoRest users are suggested to follow in handling advanced scenarios in Swagger specifications. AutoRest handles Swagger specification input files according to [Swagger RESTful API Documentation Specification](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md) and this documentation clarifies the occasions that are not clearly defined there or might bring ambiguity.

## Contents
- [AutoRest Swagger Handling](#autorest-swagger-handling)
	- [Contents](#contents)
		- [Data Types](#data-types)
			- [Basic Data Types](#basic-data-types)
			- [`byte[]`, `DateTimeOffset`, `int`, `long`](#byte-datetimeoffset-int-long)
			- [Sequences and Dictionaries](#sequences-and-dictionaries)
				- [Sequences](#sequences)
				- [Dictionaries](#dictionaries)
			- [Inheritance and Polymorphism](#inheritance-and-polymorphism)
				- [Inheritance](#inheritance)
				- [Polymorphism](#polymorphism)
			- [Type Name Generation](#type-name-generation)
		- [Operations](#operations)
			- [Generating Operation Classes](#generating-operation-classes)
			- [Specifying required parameters and properties](#specifying-required-parameters-and-properties)
			- [Error Modeling](#error-modeling)

## Data Types
### Basic Data Types
Please follow https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#data-types for most specifying all the basic data types in the Swagger specification.

**Example:**
```json
"defitions": {
  "pet": {
    "properties": {
      "name": {
        "type": "string"
	  },
	  "age": {
	    "type": "integer"
	  }
	}
  }
}
```
will generate C# client model type:
```csharp
public partial class Pet
{
    private int? _age;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public int? Age
    {
        get { return this._age; }
        set { this._age = value; }
    }
    
    private string _name;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public string Name
    {
        get { return this._name; }
        set { this._name = value; }
    }
    
    /// <summary>
    /// Initializes a new instance of the Pet class.
    /// </summary>
    public Pet()
    {
    }
}
```

### `byte[]`, `DateTimeOffset`, `int`, `long`
- **`byte[]`**
In order to generated `byte` arrays in the generated code, the property of the Swagger definition should have `string` as its type and `byte` as its format.

- **`DateTimeOffset`**
AutoRest generate `DateTimeOffset` typed variables in generated C# code for Swagger properties that have `string` as the type and `date-time` as the format.

- **`int` / `long`**
Both `int` and `long` variables in the generated code correspond to `integer` types in Swagger properties. If the format of the Swagger property is `int32`, `int` will be generated; if the format is `int64`, `long` will be generated. If the format field of the Swagger property is not set, AutoRest will default the format to `int32`.

**Example:**
```json
"pet": {
  "properties": {
    "age": {
      "type": "integer",
      "format": "int32"
    },
    "number": {
      "type": "integer",
      "format": "int64"
    },
    "name": {
      "type": "string",
      "format": "byte"
    },
    "birthday": {
      "name": "dateTime",
      "type": "string",
      "format": "date-time"
    }
  }
}
```
will generate C# model type:
```csharp
public partial class Pet
{
    private int? _age;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public int? Age
    {
        get { return this._age; }
        set { this._age = value; }
    }
    
    private DateTime? _birthday;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public DateTime? Birthday
    {
        get { return this._birthday; }
        set { this._birthday = value; }
    }
    
    private byte[] _name;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public byte[] Name
    {
        get { return this._name; }
        set { this._name = value; }
    }
    
    private long? _number;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public long? Number
    {
        get { return this._number; }
        set { this._number = value; }
    }
    
    /// <summary>
    /// Initializes a new instance of the Pet class.
    /// </summary>
    public Pet()
    {
    }
}
```

### Sequences and Dictionaries
#### Sequences
AutoRest build sequences from `array` schema in Swagger specification. 
The following definition
```json
"pet": {
  "properties": {
    "names": {
      "type": "array",
      "items": { 
        "type": "string"
      }
    }
  }
}
```
will generate C# client library
```csharp
public partial class Pet
{
    private IList<string> _names;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public IList<string> Names
    {
        get { return this._names; }
        set { this._names = value; }
    }
    
    /// <summary>
    /// Initializes a new instance of the Pet class.
    /// </summary>
    public Pet()
    {
        this.Names = new LazyList<string>();
    }
}
```

#### Dictionaries
AutoRest generate dictionaries (or hash maps in some contexts) using `additionalProperites` from [JSON Schema v4](http://json-schema.org/latest/json-schema-validation.html#anchor64). However, AutoRest currently only support objects (Swagger schema) but not Boolean values. The key of the dictionary generated could only be `string`.

The following definition
```json
"StringDictionary": {
  "additionalProperties": {
    "type": "string"
  }
}
```
will generate C# client library
```csharp
public static partial class StringDictionary
{
    /// <summary>
    /// Deserialize the object
    /// </summary>
    public static IDictionary<string, string> DeserializeJson(JToken inputObject)
    {
        IDictionary<string, string> deserializedObject = new Dictionary<string, string>();
        foreach (JProperty property in inputObject)
        {
            deserializedObject.Add(((string)property.Name), ((string)property.Value));
        }
        return deserializedObject;
    }
}
```
Notice that in the example for Sequences, the `Pet` is a POCO model while in this example the `StringDictionary` only generates a static class helper for deserialization. Note that a model is generated if the corresponding Swagger scheme appears as a property of some other scheme, while a static helper class is generated if the corresponding Swagger scheme is the top-level object sent on the wire. This rule applies to all sequences and dictionaries in both requests and responses.

### Inheritance and Polymorphism
#### Inheritance
AutoRest build inheritance between types if an `AllOf` field is specified in a Swagger definition with ONLY one reference to another Swagger definition. The following example demonstrate a `Cat` type inheriting a `Pet` with its `AllOf` set to `[{"$ref": "Pet"}]`. 

> Note: Only `AllOf` fields with one reference will be treated as inheritance. If `AllOf` contains more than one schema that have `"$ref"` as the key the inheritance will not be built. However, inheritance will not be broken if there are other inline schema definitions in `AllOf` because their properties will only be merged into the current type's property list.

**Example:**
```json
"Pet": {
  "properties": {
    "name": {
      "type": "string"
    }
  }
},
"Cat": {
  "AllOf": [ { "$ref":  "Pet" } ],
  "properties": {
    "color": {
      "type": "string",
      "description": "cat color"
    }
  }
}
```
will generate C# model types
```csharp
public partial class Cat : Pet
{
    private string _color;
    
    /// <summary>
    /// Optional. cat color
    /// </summary>
    public string Color
    {
        get { return this._color; }
        set { this._color = value; }
    }
    
    /// <summary>
    /// Initializes a new instance of the Cat class.
    /// </summary>
    public Cat()
    {
    }
    
    /// <summary>
    /// Serialize the object
    /// </summary>
    /// <returns>
    /// Returns the json model for the type Cat
    /// </returns>
    public override JToken SerializeJson(JToken outputObject)
    {
        outputObject = base.SerializeJson(outputObject);
        if (outputObject == null)
        {
            outputObject = new JObject();
        }
        if (this.Color != null)
        {
            outputObject["color"] = this.Color;
        }
        return outputObject;
    }
    
    /// <summary>
    /// Deserialize the object
    /// </summary>
    public override void DeserializeJson(JToken inputObject)
    {
        base.DeserializeJson(inputObject);
        if (inputObject != null && inputObject.Type != JTokenType.Null)
        {
            JToken colorValue = inputObject["color"];
            if (colorValue != null && colorValue.Type != JTokenType.Null)
            {
                this.Color = ((string)colorValue);
            }
        }
    }
}

public partial class Pet
{
    private string _name;
    
    /// <summary>
    /// Optional.
    /// </summary>
    public string Name
    {
        get { return this._name; }
        set { this._name = value; }
    }
    
    /// <summary>
    /// Initializes a new instance of the Pet class.
    /// </summary>
    public Pet()
    {
    }
    
    /// <summary>
    /// Serialize the object
    /// </summary>
    /// <returns>
    /// Returns the json model for the type Pet
    /// </returns>
    public virtual JToken SerializeJson(JToken outputObject)
    {
        if (outputObject == null)
        {
            outputObject = new JObject();
        }
        if (this.Name != null)
        {
            outputObject["name"] = this.Name;
        }
        return outputObject;
    }
    
    /// <summary>
    /// Deserialize the object
    /// </summary>
    public virtual void DeserializeJson(JToken inputObject)
    {
        if (inputObject != null && inputObject.Type != JTokenType.Null)
        {
            JToken nameValue = inputObject["name"];
            if (nameValue != null && nameValue.Type != JTokenType.Null)
            {
                this.Name = ((string)nameValue);
            }
        }
    }
}
```
Notice that in `Cat`'s serialization and deserialization methods, `Pet`'s corresponding methods are called first to build all the properties of `Pet`.

#### Polymorphism
In order to describe polymorphic inheritance between types, AutoRest uses an extra "discriminator" field to determine what the exact type of an object is on the wire. Therefore on top of inheritance, polymorphism can be easily achieved with little effort by adding a discriminator field to the base class. In the example above, by adding a discriminator `$type` (commonly used by Web APIs) to `Pet` we have a following new `Pet`:
```json
"Pet": {
  "discriminator": "$type",
  "required": [
    "$type"
  ],
  "properties": {
    "name": {
      "type": "string"
    },
    "$type": {
      "type": "string"
    }
  }
}
```
The generated C# code looks exactly the same in the models but the base serialization and deserialization calls in the operations will look like:
```csharp
        public async Task<HttpOperationResponse<Pet>> GetPolymorphicPetsAsync(CancellationToken cancellationToken)
{

............

	// Serialize Request
	string requestContent = null;
	JToken requestDoc = petCreateOrUpdateParameter.SerializeJson(null);
	if (petCreateOrUpdateParameter is Cat)
	{
	    requestDoc["$type"] = "Cat";
	}
	else if (petCreateOrUpdateParameter is Dog)
	{
	    requestDoc["$type"] = "Dog";
	}
	else
	{
	    requestDoc["$type"] = "Pet";
	}
	
............

	// Deserialize Response
	if (statusCode == HttpStatusCode.OK)
	{
	    Pet resultModel = new Pet();
	    JToken responseDoc = null;
	    if (string.IsNullOrEmpty(responseContent) == false)
	    {
	        responseDoc = JToken.Parse(responseContent);
	    }
	    if (responseDoc != null)
	    {
	        string typeName = ((string)responseDoc["$type"]);
	        if (typeName == "Cat")
	        {
	            resultModel = new Cat();
	        }
	        else if (typeName == "Dog")
	        {
	            resultModel = new Dog();
	        }
	        else
	        {
	            resultModel = new Pet();
	        }
	        resultModel.DeserializeJson(responseDoc);
	    }
	    result.Body = resultModel;
	}
	
............
```

### Type Name Generation
Type name generation is simple and straightforward if a Swagger schema is defined in the "#/definitions" block. The name of the Swagger Schema will be respected, like the `Pet` model in the examples above. Unfriendly characters will be filtered but the generated model name should make sense if the one in the Swagger definitions list makes sense.

Type name generation becomes tricky in inline schema definitions. There are 3 scenarios that AutoRest generate a name on its own. The names are generated in the way that their context in the Swagger specification is easy to be found and developers can move them into "#/definitions" list if they'd like a different name.

- **Inline parameters**
*Schema defined inside a `body` parameter.* The parameter name will be used for the generated type name as it is required according to the definition [here](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameterObject).
The following example will generate a type `PetStyle`.
```json
"parameters": [
  {
    "in": "body",
    "name": "style",
    "schema": {
      "properties": {
        "name": {
          "type": "string"
        },
        "color": {
          "type": "string"
        }
      }
    }
  }
]
```

- **Inline responses**
*Responses with a schema definition inside.* The return type name will be `operationId` + `http status code` + "Response".
The following example will generate a type `AddPetOkResponse`.
```json
......
"operationId": "addPet",
......
"200": {
  "description": "pet response",
  "schema": {
    "properties": {
      "id": {
        "type": "integer",
        "format": "int64"
      },
      "name": {
        "type": "string"
      },
    }
  }
}
```

- **Inline properties**
*A property of a reference type contains an inline Swagger schema definition.* The parent class's type name concatenated with the property's name inside the parent class will be used as its type name.
The following example will generate a type `PetStyle`.
```json
"Pet": {
  "properties": {
    "style": {
      "properties": {
        "name": {
          "type": "string"
        },
        "color": {
          "type": "string"
        }
      }
    }
  }
}
```

- **Properties inside sequences / dictionaries**
*A property defined as the element of a sequence or the value of a dictionary.* Elements of a sequence are named as the parent class's name concatenated with "Item", and values of a dictionary are named as the parent class's name concatenated with "Value".
The following example will generate types `PetFavFoodItem` and `PetFavFoodBrandValue`.
```json
"Pet": {
  "properties": {
    "fav_food": {
	  "type": "array",
	  "items": {
	    "properties": {
	      "name": {
	        "type": "string"
	      },
	      "taste": {
	        "type": "string"
	      }
	    }
	  }
    },
    "fav_food_brand": {
      "additionalProperties": {
	    "properties": {
	      "manufacturer": {
	        "type": "string"
	      }
	    }
      }
    }
  }
}
```

## Operations
### Generating Operation Classes
In many cases, different operations are intended to put into different classes for better clarification and readability. AutoRest supports categorizing operations using `_` in `operationId` fields. The part appearing before `_` will be treated as the class name the method will be inside, and the part after it will be treated as the actual method name.

**Example:**
The following Swagger specification:
```json
"paths": {
  "/api/Values/{id}": {
    "get": {
      "tags": [
        "Values"
      ],
      "operationId": "Values_Get",
......
```
will generate a `Get` method inside `*.*.*.Values` namespace where `*.*.*` is the namespace passed in from the AutoRest Command Line Interface. This is a neat way of organizing methods if you have methods of same names in different namespaces from your API server side code.

If `-OutputAsSingleFile` parameter is not specified for AutoRest Command Line Interface, generated files will also be organized by namespaces. If you have `operationId`s `ns1` and `ns2`, you will have `ns1.cs` and `ns2.cs` generated for C# client library.

### Specifying required parameters and properties
Parameters and properties in Swagger schema use different notations to define if it's required or optional. 

Parameters use a `'required'` Boolean field as the example shown below.
```json
"parameters": [
  {
    "name": "subscriptionId",
    "in": "path",
    "required": true,
    "type": "integer"
  },
  {
    "name": "resourceGroupName",
    "in": "path",
    "type": "string"
  },
  {
    "name": "api-version",
    "in": "query",
    "required": false,
    "type": "integer"
  }
]
```
will generate C# client side method of
```csharp
public async Task<HttpOperationResponse<Product>> ListAsync(int subscriptionId, string resourceGroupName, int? apiVersion, CancellationToken cancellationToken)
{
    // Validate
    if (resourceGroupName == null)
    {
        throw new ArgumentNullException("resourceGroupName");
    }
............
```
where not-nullable types are changed into their nullable wrapper if it's optional and a validation is added if a nullable type is marked as required.

> Note that parameters that has field `in` as path are always required and it's `required` field will be ignored. 

Properties, however, doesn't not contain a required field since it's a list of Swagger schema and there is not placeholder for a `'required'` field. Instead, Each definition scheme can specify a `'required'` array that tells which ones in the property list are required. An example is shown below.
```json
"Product": {
  "required": [ 
    "product_id", "display_name"
  ],
  "properties": {
    "product_id": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "display_name": {
      "type": "string"
    },
    "capacity": {
      "type": "string"
    },
    "image": {
      "type": "string"
    }
  }
}
```

### Error Modeling
At the runtime of the client library, if the server returns an undesired status code or throws exceptions, the exception will be expected to be an `HttpOperationException`. The exception instance will contain the request of type `HttpRequestMessage` (in property `Request`), the response of type `HttpResponseMessage` (in property `Response`), and the error model if defined in Swagger specification (in property `Body`). The error model must be defined as the `default` response's scheme.
**Example:**
A response of 
```json
"default": {
  "description": "Unexpected error",
  "schema": {
    "$ref": "Error"
  }
}
```
together with its definition
```json
"Error": {
  "properties": {
    "code": {
      "type": "integer",
      "format": "int32"
    },
    "message": {
      "type": "string"
    },
    "fields": {
      "type": "string"
    }
  }
}
```
will generate the following error handling code:
```csharp
if (statusCode != HttpStatusCode.OK) // and more if more acceptable status codes
{
    Error errorModel = new Error();
    JToken responseDoc = null;
    if (string.IsNullOrEmpty(responseContent) == false)
    {
        responseDoc = JToken.Parse(responseContent);
    }
    if (responseDoc != null)
    {
        errorModel.DeserializeJson(responseDoc);
    }
    HttpOperationException<Error> ex = new HttpOperationException<Error>();
    ex.Request = httpRequest;
    ex.Response = httpResponse;
    ex.Body = errorModel;
    if (shouldTrace)
    {
        ServiceClientTracing.Error(invocationId, ex);
    }
    throw ex;
}
```