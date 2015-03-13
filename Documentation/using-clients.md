#Using Generated Clients (C#)

##Contents

* Project Setup
* Initialization
* Authentication
* Error Handling
* Tracing
* Transient Fault Handling
* Customization via Http Handlers


##Project Setup
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
* Constructor that accepts the above parameters and a collection of delegated handlers (see [Custom Http Handlers](#Custom-Http-Handlers) section)

##Authentication
In order to support server side authentication (certificate, basic, OAuth, or custom), the client needs to be generated using [-AddCredentials](cli.md) flag. When this flag is used the the client will have a Credentials property of type [`ServiceClientCredentials`](../Microsoft.Rest/ClientRuntime/ServiceClientCredentials.cs). Microsoft.Rest.ClientRuntime package comes with two out-of-the-box Credentials: 

 * [`TokenCredentials`](../Microsoft.Rest/ClientRuntime/TokenCredentials.cs) - used for OAuth authentication
 * [`BasicAuthenticationCredentials`](../Microsoft.Rest/ClientRuntime/BasicAuthenticationCredentials.cs) - used for basic username/password authentication

In order to implement a custom Credentials type, create a class that inherits from [`ServiceClientCredentials`](../Microsoft.Rest/ClientRuntime/ServiceClientCredentials.cs) and implement a ProcessHttpRequestAsync() method.

##Error Handling

##Tracing

Clients generated with AutoRest come with an extensible tracing infrastructure. The following events are traced when the client is executed:

* EnterMethod - operation method is entered
* SendRequest - Http request is sent
* ReceiveResponse - Http response is received
* TraceError - error is raised
* ExitMethod - method is exited



##Transient Fault Handling

##Customization via Http Handlers

