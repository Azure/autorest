#AutoRest Command Line Interface Documentation

##Syntax
```bash
AutoRest.exe -CodeGenerator <value> -Modeler <value> -Input <value> -BaseNamespace <value> [-OutputFolder <value>] [-OutputAsSingleFile <value>] [-Header <value>] [-AddCredentials <value>] 
```

##Parameters
**-OutputFolder** Output folder for generated files. Defaults to Generated directory.
**-OutputAsSingleFile** Output file name. If specified, all the code will be written into this single file. Otherwise, AutoRest will split code by operations and write individual files into OutputFolder.
**-CodeGenerator** Code generation language.
**-Modeler** Modeler for the input specification.
**-Input** Path to the input specification file. URLs are not supported at this moment.
**-BaseNamespace** Base namespace for generated code
**-Header** Default file header contents. Use NONE if no header is required.
**-AddCredentials** If set to true the generated client will have ServiceClientCredentials property. A set of corresponding constructors will be generated and its ProcessHtppRequestAsync method will be called on the http requests. Users can derive from this class to add their customized authentication behaviors.


##Examples
- Generate C# client library from a Swagger formatted input specification swagger.json with namespace MyNamespace:
```bash
AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace
```
- Generate C# client library from a Swagger formatted input specification swagger.json with namespace MyNamespace into one single file client.cs with a customized header:
```bash
AutoRest.exe -CodeGenerator CSharp -OutputAsSingleFile client.cs -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace -Header "Copyright Contoso Ltd"
```
- Generate C# client library from a Swagger formatted input specification swagger.json with namespace MyNamespace with credential property added:
```bash
AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -BaseNamespace MyNamespace -AddCredentials true
```
