[![Repo Status](http://img.shields.io/travis/Azure/autorest/dev.svg?style=flat-square&label=build)](https://travis-ci.org/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/pr?style=flat-square)](http://issuestats.com/github/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/issue?style=flat-square)](http://issuestats.com/github/Azure/autorest)

# <img align="center" src="https://raw.githubusercontent.com/Azure/autorest/master/Documentation/images/autorest-small-flat.png">  AutoRest

The **AutoRest** tool generates client libraries for accessing RESTful web services. Input to *AutoRest* is a spec that describes the REST API using the [Swagger](http://github.com/swagger-api/swagger-spec) format.

##Getting AutoRest
The AutoRest tools can be installed with Nuget for use in a Visual Studio project:
[![AutoRest NuGet](https://img.shields.io/nuget/v/autorest.svg?style=flat-square)](https://www.nuget.org/packages/autorest/)

Alternatively it can be installed from [Chocolatey](https://chocolatey.org/) by running:
[![AutoRest Chocolatey](https://img.shields.io/chocolatey/v/autorest.svg?style=flat-square)](https://chocolatey.org/packages/AutoRest)

    choco install autorest
    
Nightlies are available via MyGet:
[![AutoRest MyGet](https://img.shields.io/myget/autorest/vpre/autorest.svg?style=flat-square)](https://www.myget.org/gallery/autorest)

AutoRest can be run on OSX and Unix using Mono or by running Docker container:
	
	docker pull azuresdk/autorest:latest

## Building AutoRest
AutoRest is developed primarily in C# but generates code for multiple languages. See [this link](Documentation/building-code.md) to build and test AutoRest.

> Hint: There is a powershell script (`verify-settings.ps1`) in the `Tools` folder that can verify that you have the required compilers/tools/libraries installed on your development system before trying to build.

## Hello World
For this version  of Hello World, we will use **AutoRest** to generate a client library and use it to call a web service. The trivial web service that just returns a string is defined as follows:
```
public class HelloWorldController : ApiController
{
    // GET: api/HelloWorld
    public string Get()
    {
        return "Hello via AutoRest.";
    }
}
```
By convention, Swagger documents are exposed by web services with the name `swagger.json`.  The `title` property of the `info` object is used by **AutoRest**  as the name of the client object in the generated library. The `host` + `path` of the operation corresponds to the URL of the operation endpoint. The `operationId` is used as the method name. The spec declares that a `GET` request will return an HTTP 200 status code with content of mime-type `application/json` and the body will be a string. For a more in-depth overview of swagger processing, refer to [Defining Clients With Swagger](Documentation/defining-clients-swagger.md) section of the [documentation](Documentation).

```
{
  "swagger": "2.0",
  "info": {
    "title": "MyClient",
    "version": "1.0.0"
  },
  "host": "swaggersample.azurewebsites.net",
  "paths": {
    "/api/HelloWorld": {
      "get": {
        "operationId": "GetGreeting",
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "GETs a greeting.",
            "schema": {
              "type": "string"
            }
          }
        }
      }
    }
  }
}
```
Next, we invoke **AutoRest.exe** with this swagger document to generate client library code (see [Command Line Interface documentation](Documentation/cli.md) for details).

**AutoRest** is extensible and can support multiple types of input and output. *AutoRest.exe* comes with the *AutoRest.json* configuration file that defines the available inputs (*Modelers*) and outputs (*CodeGenerators*). When invoking *AutoRest.exe*, if you don't specify the `-Modeler` then Swagger is assumed and if you don't specify `-CodeGenerator` then CSharp is used.

The Swagger schema is language agnostic and doesn't include the notion of namespace, but for generating code, AutoRest requires `-Namespace` be specified.  By default, the CodeGenerator will place output in a directory named *Generated*. This can be overridden by providing the `-OutputDirectory` parameter.

>AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -Namespace MyNamespace

Now, we will use the generated code to call the web service.

Create a console application called *HelloWorld*. Add the generated files to it. They won't compile until you add the NuGet package the generated code depends on: `Microsoft.Rest.ClientRuntime`.

You can add it to the Visual Studio project using the NuGet package manager or in the Package Manager Console with this command:
> Install-Package Microsoft.Rest.ClientRuntime

Add the namespace that was given to AutoRest.
```
using MyNamespace;
```
Access the REST API with very little code (see [Client Initialization](Documentation/clients-init.md) and [Client Operations](Documentation/clients-ops.md) for details).
```
var myClient = new MyClient();
var salutation = myClient.GetGreeting();
Console.WriteLine(salutation);
```
Running the console app shows the greeting retrieved from the service API.
```
C:\>HelloWorld.exe
Hello via AutoRest.
```

With that same basic pattern in place, you can now explore how different REST API operations and payloads are described in Swagger and exposed in the code generated by **AutoRest**.
