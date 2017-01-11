#AutoRest Command Line Interface Documentation

##Syntax
`AutoRest.exe -Input <value> [-Verbose] [-Namespace <value>] [-OutputDirectory <value>] [-CodeGenerator <value>] [-Modeler <value>] [-ClientName <value>] [-PayloadFlatteningThreshold <value>] [-Header <value>] [-AddCredentials <value>] [-OutputFileName <value>]`

##Parameters
  **-Input** The location of the input specification. Aliases: -i, -input . The input file may be either in JSON or YAML format. 
  
  **-Namespace** The namespace to use for generated code. Aliases: -n
  
  **-OutputDirectory** The location for generated files. If not specified, uses "Generated" as the default. Aliases: -o, -output
  
  **-CodeGenerator** The code generator language. If not specified, defaults to CSharp. Aliases: -g
  
  **-Modeler** The Modeler to use on the input. If not specified, defaults to Swagger. Aliases: -m
  
  **-ClientName** Name to use for the generated client type. By default, uses the value of the 'Title' field from the Swagger input. Aliases: -name

  **-ModelsName** Name to use for the generated client models namespace and folder name. By default, uses the value of 'Models'. This is not currently supported by all code generators. Aliases: -mname
  
  **-PayloadFlatteningThreshold** The maximum number of properties in the request body. If the number of properties in the request body is less than or equal to this value, these properties will be represented as method arguments. Aliases: -ft
  
  **-Header** Text to include as a header comment in generated files. Use NONE to suppress the default header. Aliases: -header
  
  **-AddCredentials** If true, the generated client includes a ServiceClientCredentials property and constructor parameter. Authentication behaviors are implemented by extending the ServiceClientCredentials type.
  
  **-OutputFileName** If set, will cause generated code to be output to a single file. Not supported by all code generators.
  
  **-Verbose** If set, will output verbose diagnostic messages.
  
  **-CodeGenSettings** Optionally specifies a JSON file that contains code generation settings equivalent to the swagger document containing the same content in the [x-ms-code-generation-settings] extension. Aliases: -cgs
##Code Generators
  **Ruby** Generic Ruby code generator.
  
  **Azure.Ruby** Azure specific Ruby code generator.
  
  **CSharp** Generic C# code generator.
  
  **Azure.CSharp** Azure specific C# code generator.
  
  **NodeJS** Generic NodeJS code generator.
  
  **Azure.NodeJS** Azure specific NodeJS code generator.
  
  **Java** Generic Java code generator.
  
  **Azure.Java** Azure specific Java code generator.
  
  **Python** Generic Python code generator.
  
  **Azure.Python** Azure specific Python code generator.

  **Go** Generic Go code generator.

##Code Generator Specific Settings
###CSharp

  **-SyncMethods** Specifies mode for generating sync wrappers. Supported value are `Essential` - generates only one sync returning body or header (default), `All` - generates one sync method for each async method, and `None` - does not generate any sync methods
  
  **-InternalConstructors** Indicates whether ctor needs to be generated with internal protection level.
  
  **-UseDateTimeOffset** Indicates whether to use DateTimeOffset instead of DateTime to model date-time types.
  

##Examples
  - Generate C# client in MyNamespace from swagger.json input:
```bash
AutoRest.exe -Namespace MyNamespace -Input swagger.json
```

  - Generate C# client in MyNamespace including custom header from swagger.json input:
```bash
AutoRest.exe -Namespace MyNamespace -Header "Copyright Contoso Ltd" -Input swagger.json
```

  - Generate C# client with a credentials property in MyNamespace from swagger.json input and with code generation settings specified by settings.json:
```bash
AutoRest.exe -AddCredentials true -Namespace MyNamespace -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -CodeGenSettings settings.json
```

  - Generate C# client in MyNamespace with custom Models name from swagger.json input:
```bash
AutoRest.exe -Namespace MyNamespace -ModelsName MyModels -CodeGenerator CSharp -Modeler Swagger -Input swagger.json
```

