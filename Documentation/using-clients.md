#Using Generated Clients (C#)

##Contents

TODO


##Overview
AutoRest generated code can currently work in a variety of .NET project types including:

  * Desktop applications (.NET 4.0 and .NET 4.5)
  * Web applications (.NET 4.0 and .NET 4.5)
  * Windows Phone (8.1)
  * Windows Store App (8.1)
  * Portable Class Libraries

Before being able to compile generated code *Microsoft.Rest.ClientRuntime* nuget package needs to be added to the project. This package will include several dependent packages based on project profile such as Newtonsoft Json.Net.

After that, the client can be used as such:
```
var myClient = new MyClient();
var salutation = myClient.GetGreeting();
Console.WriteLine(salutation);
```

##Initialization
AutoRest generates a client type based on a name defined in the specification (see [swagger specification parsing](swagger.md) overview). The generated client inherits from [`ServiceClient<T>`](../Microsoft.Rest/ClientRuntime/ServiceClient.cs) base type available in *Microsoft.Rest.ClientRuntime* nuget package. 

Client is generated with a number of constructors: 

* Default constructor that sets Base URL of the client to the one specified in the specification and configures the client to use anonymous authentication
* Constructor that accepts Base URL
* Constructor that accepts Credentials object (see [authentication](#Authentication) section)

##Authentication
The client will support authentication if it was generated using [-AddCredentials](cli.md) flag. 

##Tracing