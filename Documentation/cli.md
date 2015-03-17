#AutoRest Command Line Interface Documentation

##Syntax
```bash
AutoRest.exe -Input <value> -Namespace <value> [-OutputDirectory <value>] [-OutputFileName <value>] [-CodeGenerator <value>] [-Modeler <value>] [-ClientName <value>] [-Header <value>] [-AddCredentials <value>] 
```

##Parameters
**-OutputDirectory** Output directory for generated files. Defaults to Generated directory.

**-OutputFileName** Output file name. If specified, all the generated code is written into this single file. Otherwise, AutoRest will split code by operations and models and write individual files into OutputDirectory.

**-CodeGenerator** Code generation language. If not specified, will default to CSharp.

**-Modeler** Modeler for the input specification. If not specified, will default to Swagger.

**-Input** Path to the input specification file.

**-Namespace** Namespace for generated code

**-ClientName** Name of the generated client type. If not specified, will default to the value in the specification. For Swagger specifications, this is the value in the 'Title' field.

**-Header** Header to be included in each generated file as a comment. Use NONE if no header is required.

**-AddCredentials** If set to true the generated service client will have a ServiceClientCredentials property. The constructors will include a parameter for passing the credentials object. When processing HTTP requests, the ProcessHtppRequestAsync method of the credentials object will be invoked. Custom authentication behaviors can be added to the generated client by passing in types that derive from ServiceClientCredentials. 



##Examples
- Generate C# client library from a Swagger-formatted input specification `swagger.json` in the `MyNamespace` namespace:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace
```

- Generate C# client library from a Swagger-formatted input specification `swagger.json` in the `MyNamespace` namespace:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace -Modeler Swagger -CodeGenerator CSharp  
```

- Generate C# client library from a Swagger-formatted input specification `swagger.json` with namespace `MyNamespace` into the `client.cs` file with custom header text:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace -OutputAsSingleFile client.cs -Modeler Swagger -CodeGenerator CSharp -Header "Copyright Contoso Ltd"
```

- Generate C# client library from a Swagger-formatted input specification `swagger.json` in the `MyNamespace` namespace and include a credential property:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace -Modeler Swagger -CodeGenerator CSharp -AddCredentials true
```


