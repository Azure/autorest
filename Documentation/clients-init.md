#Initialization
AutoRest generates a client type based on a name defined in the specification (see [swagger specification parsing](swagger.md) overview). The generated client inherits from [`ServiceClient<T>`](../Microsoft.Rest/ClientRuntime/ServiceClient.cs) base type available in *Microsoft.Rest.ClientRuntime* nuget package. 

The client is generated with a number of constructors: 

* A default constructor that sets Base URL of the client to the one specified in the specification and configures the client to use anonymous authentication
```csharp
var myClient = new SwaggerPetstore();
```
* A constructor that accepts Base URL
```csharp
var myClient = new SwaggerPetstore(new Uri("https://contoso.org/myclient"));
```
* A constructor that accepts Credentials object (see [Authentication](clients-auth.md))
```csharp
var myClient = new SwaggerPetstore(new BasicAuthenticationCredentials
	{
		UserName = "ContosoUser",
		Password = "P@$$w0rd"
	});
```
* A constructor that accepts the above parameters and a collection of delegating handlers (see [Custom Http Handlers](clients-handlers.md))
```csharp
var myClient = new SwaggerPetstore(new MyCustomDelegatingHandler());
```