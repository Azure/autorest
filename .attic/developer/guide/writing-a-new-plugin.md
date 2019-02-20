# How to write a new plugin

## Register the plugin in default-configuration.md
Add an entry to the [default configuration file](https://github.com/Azure/autorest/blob/master/src/autorest-core/resources/default-configuration.md) that will load the plugin. Depending on the type of the plugin,
add the entry in the corresponding subsection (eg. validators should go in the ```Validators``` section)

The order of execution of the plugins can also be dictated with this configuration file. The ```input``` node indicates the pre-task for the execution of current plugin. 
The ```scope``` section can be used to pass input settings. We can simply create a section named as the scope and pass all necessary arguments to the scope.
Eg.:

```
swagger-document/individual/azure-validator:
    input: individual/transform
    scope: azure-validator-individual

azure-validator-individual:
  merge-state: individual
```

In the example above, ```swagger-document/individual/azure-validator``` is the plugin to run, ```individual/transform``` is the step before this plugin is executed or the input which this plugin would process and ```azure-validator-individual``` is its scope. The setting for this scope is ```merge-state``` which is defined in a different section.

## Add a plugin entry to the Configuration object
Add an entry to the [pipeline file](https://github.com/Azure/autorest/blob/master/src/autorest-core/lib/pipeline/pipeline.ts) map it to the actual process.
and the process to be loaded when the plugin is requested. This process need to be a node or C# process and is completely independent of the AutoRest process, the inputs to be provided to this process 
can also be specified in here.