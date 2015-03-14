#AutoRest Command Line Interface Documentation

##Syntax
AutoRest.exe -CodeGenerator <value> -Modeler <value> -Input <value> -BaseNamespace <value> [-OutputFolder <value>] [-OutputAsSingleFile <value>] [-Header <value>] [-AddCredentials <value>] 

##Parameters
**-OutputFolder** 
Output folder for generated files. Defaults to current directory.

**-OutputAsSingleFile** 
Output file name. If not specified, will split code by namespace and write individual files into OutputFolder.

**-CodeGenerator** 
Code generation language.

**-Modeler** 
Modeler for the input specification.

**-Input** 
Path to the input specification file

**-BaseNamespace** 
Base namespace for generated code

**-Header** 
Default file header contents.

**-AddCredentials** 
If set to true generated client will have ServiceClientCredentials in property and constructor.



##Examples
Generate C# client library from a Swagger formatted input specification swagger.json with namespace MyNamespace:
```bash
AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace
```

Generate C# client library from a Swagger formatted input specification swagger.json with namespace MyNamespace into one single file client.cs with a customized header:
```bash
AutoRest.exe -CodeGenerator CSharp -OutputAsSingleFile client.cs -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace -Header "Copyright Contoso Ltd"
```

Generate C# client library from a Swagger formatted input specification swagger.json with namespace MyNamespace with credential property added:
```bash
AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace -AddCredentials true
```
