#AutoRest Command Line Interface Documentation

##Syntax
```bash
AutoRest.exe -Input <value> -Namespace <value> [-OutputDirectory <value>] [-OutputFileName <value>] [-CodeGenerator <value>] [-Modeler <value>] [-ClientName <value>] [-Header <value>] [-AddCredentials <value>] 
```

##Parameters
**-OutputDirectory** Output directory for generated files. Defaults to Generated directory.

**-OutputFileName** Output file name. If specified, all the code will be written into this single file. Otherwise, AutoRest will split code by operations and write individual files into OutputFolder.

**-CodeGenerator** Code generation language. If not specified, will default to CSharp.

**-Modeler** Modeler for the input specification. If not specified, will default to Swagger.

**-Input** Path to the input specification file.

**-Namespace** Base namespace for generated code

**-ClientName** Name of the generated client type. If not specified, will default to the value in the specification. For Swagger specifications, this is the value in the 'Title' field.

**-Header** Header to be included in each generated file as a comment. Use NONE if no header is required.

**-AddCredentials** If set to true the generated service client will have ServiceClientCredentials property. A set of corresponding constructors will be generated and its ProcessHtppRequestAsync method will be called on the http requests. Users can derive from this class to add their customized authentication behaviors.



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


