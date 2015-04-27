#AutoRest Command-Line Documentation

##Syntax
```bash
AutoRest.exe -Input <value> -Namespace <value> 
            [-OutputDirectory <value>] 
            [-OutputFileName <value>] 
            [-CodeGenerator <value>] 
            [-Modeler <value>] 
            [-ClientName <value>] 
            [-Header <value>] 
            [-AddCredentials <value>] 
```

##Parameters
**-OutputDirectory** Output directory for generated files. Defaults to `.\Generated` directory.

**-OutputFileName** Output file name. If specified, all generated code is written into this single file. By default, AutoRest splits code by operations and models and writes individual files into *OutputDirectory*.

**-CodeGenerator** If not provided, defaults to CSharp. Specifies the name of the code generator to use. Available code generators are defined in the *AutoRest.json* settings file.

**-Modeler** If note provided, defaults to Swagger. Specifies the name of the modeler to use in processing the `Input`. Available modelers are defined in the the *AutoRest.json* settings file.

**-Input** Path to the input specification file.

**-Namespace** Namespace to use, where applicable, for the generated code

**-ClientName** Name of the generated client type. If not specified, the modeler will select a value from the specification. For Swagger specifications, the client name is taken from the **Title** field.

**-Header** Specifies header text to be included in each generated file as a comment. Pass `NONE` to suppress the default AutoRest header.

**-AddCredentials** If `true` the generated client includes a **Credentials** property. The constructors include a parameter for passing the credentials object. The credentials object includes a **ProcessHttpRequestAsync** method that is called for each HTTP requests. Custom authentication behaviors can be added to the generated client by providing a type that derives from [ServiceClientCredentials](../Microsoft.Rest/ClientRuntime/ServiceClientCredenetials.cs). 

##Examples
- Generate a C# client from a Swagger-formatted input  `swagger.json` in the `MyNamespace` namespace:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace
```

- Generate a C# client from a Swagger-formatted input `swagger.json` in the `MyNamespace` namespace:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace -Modeler Swagger -CodeGenerator CSharp  
```

- Generate a C# client from a Swagger-formatted input specification `swagger.json` with namespace `MyNamespace` into the `client.cs` file with custom header text:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace -OutputAsSingleFile client.cs -Modeler Swagger -CodeGenerator CSharp -Header "Copyright Contoso Ltd"
```

- Generate a C# client from a Swagger-formatted input specification `swagger.json` in the `MyNamespace` namespace and include a ServiceClientCredentials property:
```bash
AutoRest.exe -Input swagger.json -Namespace MyNamespace -Modeler Swagger -CodeGenerator CSharp -AddCredentials true
```
