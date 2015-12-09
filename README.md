[![Repo Status](http://img.shields.io/travis/Azure/autorest/dev.svg?style=flat-square&label=build)](https://travis-ci.org/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/pr?style=flat-square)](http://issuestats.com/github/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/issue?style=flat-square)](http://issuestats.com/github/Azure/autorest)

# <img align="center" src="Documentation/images/autorest-small-flat.png">  AutoRest

The **AutoRest** tool generates client libraries for accessing RESTful web services. Input to *AutoRest* is a spec that describes the REST API using the [Swagger](http://github.com/swagger-api/swagger-spec) format.

##Getting AutoRest
The AutoRest tools can be installed with Nuget for use in a Visual Studio project:
[![AutoRest NuGet](https://img.shields.io/nuget/v/autorest.svg?style=flat-square)](https://www.nuget.org/packages/autorest/)

Alternatively it can be installed from [Chocolatey](https://chocolatey.org/) by running:
[![AutoRest Chocolatey](https://img.shields.io/chocolatey/v/autorest.svg?style=flat-square)](https://chocolatey.org/packages/AutoRest)

    choco install autorest
    
Nightlies are available via MyGet:
[![AutoRest MyGet](https://img.shields.io/myget/autorest/vpre/autorest.svg?style=flat-square)](https://www.myget.org/gallery/autorest)

## Build Prerequisites
AutoRest is developed primarily in C# but generates code for multiple languages. To build and test AutoRest requires a few things be installed locally.

### .Net
#### on Windows 
Install the [Microsoft Build Tools](http://go.microsoft.com/?linkid=9832060) or get them with [Visual Studio](https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx).
Ensure that msbuild is in your path by running vcvarsall.bat
>C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat

To compile the code in Visual Studio IDE, 
- Ensure you are using Visual Studio 2015
- Ensure "Nuget Package Manager For Visual Studio" is updated to a newer version, like "2.8.60723.765", which is needed to install xunit.
- Install [Task Runner Explorer](https://visualstudiogallery.msdn.microsoft.com/8e1b4368-4afb-467a-bc13-9650572db708) to run gulp tasks such as synchonize nuget version, assembly info, etc.

Install DNVM using [these steps](https://docs.asp.net/en/latest/getting-started/installing-on-windows.html) and configure DNX 1.0.0-rc1.

#### on Mac or Linux
Install Mono 4.3.0 (MonoFramework-MDK-4.3.0.372.macos10.xamarin.x86.pkg)

Install DNVM using [these steps](https://docs.asp.net/en/latest/getting-started/installing-on-mac.html).

### Node.js
Install the latest from [nodejs.org](https://nodejs.org/). Then from the project root run `npm install`.

### Java / Java Development Kit
Install the latest Java SE Development Kit from [Java SE Downloads](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
Ensure that the JDK binaries are in your `PATH`.
>set PATH=PATH;C:\Program Files\java\jdk1.8.0_45\bin

Ensure that your environment includes the `JAVA_HOME`.
>set JAVA_HOME=C:\Program Files\java\jdk1.8.0_45

#### Gradle
Install the `Gradle build system` from [Gradle downloads](http://gradle.org/gradle-download/).
Ensure Gradle is in your `PATH`.
>set PATH=PATH;C:\gradle-2.6\bin

Ensure that your environment includes the `GRADLE_HOME`.
>set GRADLE_HOME=C:\gradle-2.6

#### Java IDE
You may want a Java IDE.
- Install Jetbrains IntelliJ IDEA from [JetBrains downloads](https://www.jetbrains.com/idea/download/.)
 OR
- Install `Eclipse IDE for Java EE Developer` from [Eclipse downloads](http://eclipse.org/downloads/) 

### Ruby
[RubyInstaller](http://rubyinstaller.org/downloads/) version 2+ - 32-bit version.
By default, Ruby installs to C:\Ruby21 or Ruby22, etc. Ensure that C:\Ruby21\bin is in your `PATH`.
>set PATH=PATH;C:\Ruby21\bin

[RubyDevKit](http://rubyinstaller.org/downloads/) 32-bit version for use with Ruby 2.0 and above
The DevKit installer just unpacks files. Navigate to the directory and run the following:
```bash
ruby dk.rb init
ruby dk.rb install
gem install bundler
```
## Gulp
We use [gulp](http://gulpjs.com) and msbuild / xbuild to handle the builds. Install for global use with
>npm install gulp -g

If you would like to see what commands are available to you, run `gulp -T`. That will list all of the gulp tasks you can run. By default, just running `gulp` will run a build that will execute clean, build, code analysis, package and test.

### Output from gulp -T
```bash
[13:54:21] Using gulpfile ./autorest/gulpfile.js
[13:54:21] Tasks for ./autorest/gulpfile.js
[13:54:21] ├── regenerate:expected
[13:54:21] ├── regenerate:delete
[13:54:21] ├── regenerate:expected:csazure
[13:54:21] ├── regenerate:expected:cs
[13:54:21] ├── clean:build
[13:54:21] ├── clean:templates
[13:54:21] ├── clean:generatedTest
[13:54:21] ├─┬ clean
[13:54:21] │ ├── clean:build
[13:54:21] │ ├── clean:templates
[13:54:21] │ └── clean:generatedTest
[13:54:21] ├── syncNugetProjs
[13:54:21] ├── syncNuspecs
[13:54:21] ├─┬ syncDotNetDependencies
[13:54:21] │ ├── syncNugetProjs
[13:54:21] │ └── syncNuspecs
[13:54:21] ├── build
[13:54:21] ├── package
[13:54:21] ├── test
[13:54:21] ├── analysis
[13:54:21] └── default
```

### Running the tests
Prior to executing `gulp` to build and then test the code, make sure that the latest tools are setup for your build environment.

- run `bundle install` from the root directory

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
