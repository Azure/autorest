# DRAFT - still editing

## Purpose
To provide additional context to code generators to make changes 
to the code generated based on supplemental information passed in a seperate file (instead 
of passed on the command line, or embedded in the swagger input file)

Like all content files, can be `json` or `yaml`.

Passing settings on the command line will be continue to be supported for continutity, the 
preference going forward would be to build an accompanying `autorest.<language>.yaml` file
to drive the execution.

##

``` yaml
Namespace: MyApp.MyNameSpace
Modeler : Swagger
OutputFolder : Foo
SpecFile: MySpec.json
Generators: 
  CSharp.Azure:
    Namespace: System.MyApp.MyNameSpace  # override the default/global setting above.
    OutputFolder : .\output\cs
    
    
  


```