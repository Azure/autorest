#AutoRest Command Line Interface Documentation

##Syntax
```bash
AutoRest.exe -Input <value> [-Namespace <value>] [-OutputDirectory <value>] [-CodeGenerator <value>] [-Modeler <value>] [-ClientName <value>] [-PayloadFlatteningThreshold <value>] [-Header <value>] [-AddCredentials <value>] [-OutputFileName <value>]
```

##Parameters
  **-Input** The location of the input specification. Aliases: -i, -input
  **-Namespace** The namespace to use for generated code. Aliases: -n
  **-OutputDirectory** The location for generated files. If not specified, uses "Generated" as the default. Aliases: -o, -output
  **-CodeGenerator** The code generator language. If not specified, defaults to CSharp. Aliases: -g
  **-Modeler** The Modeler to use on the input. If not specified, defaults to Swagger. Aliases: -m
  **-ClientName** Name to use for the generated client type. By default, uses the value of the 'Title' field from the Swagger input. Aliases: -name
  **-PayloadFlatteningThreshold** The maximum number of properties in the request body. If the number of properties in the request body is less than or equal to this value, these properties will be represented as method arguments. Aliases: -ft
  **-Header** Text to include as a header comment in generated files. Use NONE to suppress the default header. Aliases: -header
  **-AddCredentials** If true, the generated client includes a ServiceClientCredentials property and constructor parameter. Authentication behaviors are implemented by extending the ServiceClientCredentials type.
  **-OutputFileName** If set, will cause generated code to be output to a single file. Not supported by all code generators.


##Code Generators
  **-Ruby** Generic Ruby code generator.
  **-Azure.Ruby** Azure specific Ruby code generator.
  **-CSharp** Generic C# code generator.
  **-Azure.CSharp** Azure specific C# code generator.
  **-NodeJS** Generic NodeJS code generator.
  **-Azure.NodeJS** Azure specific NodeJS code generator.
  **-Java** Generic Java code generator.
  **-Azure.Java** Azure specific Java code generator.
  **-Python** Generic Python code generator.
  **-Azure.Python** Azure specific Python code generator.


##Examples
  - Generate C# client in MyNamespace from swagger.json input:
```bash
AutoRest.exe -Namespace MyNamespace -Input swagger.json
```

  - Generate C# client in MyNamespace including custom header from swagger.json input:
```bash
AutoRest.exe -Namespace MyNamespace -Header "Copyright Contoso Ltd" -Input swagger.json
```

  - Generate C# client with a credentials property in MyNamespace from swagger.json input:
```bash
AutoRest.exe -AddCredentials true -Namespace MyNamespace -CodeGenerator CSharp -Modeler Swagger -Input swagger.json
```
