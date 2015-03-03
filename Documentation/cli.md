#AutoRest Command Line Interface Documentation

##Contents

- [AutoRest Command Line Interface Documentation](#autorest-command-line-interface -documentation)
	- [Contents](#contents)
		- [Name](#name)
		- [Synopsis](#synopsis)
		- [Description](#description)
		- [Parameters](#parameters)
		- [Examples](#examples)


##Name
`AutoRest.exe` The **AutoRest** tool generates client libraries for accessing RESTful web services.

##Synopsis
```bash
'AutoRest.exe' -CodeGenerator <value> -Modeler <value> -Input <value> -BaseNamespace <value> [-OutputFolder <value>] [-OutputAsSingleFile <value>] [-Header <value>] [-AddCredentials <value>]
```
###Description
AutoRest is an extensible client library generator and can support multiple types of input and output. AutoRest.exe comes with the `AutoRest.json` configuration file that defines the available inputs (Modelers) and outputs (CodeGenerators). When invoking AutoRest.exe, you must specify the `-Modeler` and `-CodeGenerator` to use.

###Parameters
**-OutputFolder** 
Output folder for generated files. Defaults to current directory.

**-OutputAsSingleFile**
Output file name. If specified, all the code will be written into this single file. Otherwise, AutoRest will split code by operations and write individual files into OutputFolder. 

**-CodeGenerator**
Code generation language. So far we have the following languages supported (the list is growing):

 - C#

**-Modeler**
The input specification type. So far we only support [Swagger 2.0](https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md).

**-Input**
Path to the input specification file. The file must be a local standalone file.

**-BaseNamespace**
Base namespace for generated code. This is only needed by certain languages, which include C# and Java so far.

**-Header**
Default file header contents. Use `NONE` if no header is required.

**-AddCredentials**
If set to true generated client will have [ServiceClientCredentials](https://github.com/Azure/AutoRest/blob/master/Microsoft.Rest/ClientRuntime/ServiceClientCredentials.cs) in property and constructor.


#Examples
- Generate C# client library from a Swagger formatted input specification `swagger.json` with namespace `MyNamespace`:
```bash
AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace
```
This will generate all the C# files for corresponding operations in the current folder.

- Generate C# client library from a Swagger formatted input specification `swagger.json` with namespace `MyNamespace` into one single file `client.cs`  with a customized header:
```bash
AutoRest.exe -CodeGenerator CSharp -OutputAsSingleFile client.cs -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace -Header "Copyright Contoso Ltd"
```
This will generate one single file `client.cs` in the current folder.

- Generate C# client library from a Swagger formatted input specification `swagger.json` with namespace `MyNamespace` with credential property added:
```bash
AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace -AddCredentials true
```