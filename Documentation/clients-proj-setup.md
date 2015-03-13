#Project Setup

AutoRest generated code can currently work in a variety of .NET project types including:

  * Desktop applications (.NET 4.0 and .NET 4.5)
  * Web applications (.NET 4.0 and .NET 4.5)
  * Windows Phone (8.1)
  * Windows Store App (8.1)
  * Portable Class Libraries
 
Use the visual studio "Show All Files" button in the Solution Explorer to show your generated code.
![Show All Files](images/clients-proj-setup-showallfiles.png)

Right click on the generated folder and select "Include In Project" from the context menu.
![Include In Project](images/clients-proj-setup-include.png)

Add the *Microsoft.Rest.ClientRuntime* nuget package to the project. This package includes several dependent packages based on project profile such as *Newtonsoft Json.Net*.
![Nuget package manager](images/clients-proj-setup-nuget.png)

Use the client as follows:
```csharp
var client = new SwaggerPetstore();
var pets = client.FindPets(null, 10);
```
