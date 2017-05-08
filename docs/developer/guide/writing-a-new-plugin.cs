# How to write a new plugin

## Register the plugin in default-configuration.md
Add an entry to the (configuration file)[https://github.com/Azure/autorest/blob/master/src/autorest-core/resources/default-configuration.md] that will load the plugin. Depending on the type of the plugin,
add the entry in the corresponding subsection (eg. validators should go in the ```Validators``` section)
Please note that the ```transform``` step is pre-cursor to most plugins since it transforms the raw json into a usable model. 
The order of execution of the plugins can also be dictated with this configuration file. The ```input``` node indicates the pre-task for the execution of current plugin. 
The ```scope``` section indicates the input settings for the execution of given plugin.

## Add a plugin entry to the Configuration object
Add an entry to the (Configuration object)[https://github.com/Azure/autorest/blob/master/src/autorest-core/lib/configuration.ts]. This entry determines the input flag that will enable/disable the plugin 
and the prcoess to be loaded when the plugin is requested. This process need to be a node or C# process and is completely independent of the AutoRest process, the inputs to be provided to this process 
can also be specified in here.