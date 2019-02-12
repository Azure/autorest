# AutoRest PowerShell Specific Options

## Controlling the output folder layout

## Tweaking the way it generates cmdlets

To change the way AutoRest generates cmdlets you can use one of the built-in directives outlined below, or you can [declare your own directives](https://github.com/Azure/autorest/blob/new-documentation/src/autorest-core/resources/default-configuration.md#directives). You may specify the directives you want to use at the top-level of the Literate Configuration document. For example:


```yaml 
directive:
  - remove-command: Get-AzOperation.*
  - where-command: New-AzConfigurationStore
    set-name: New-AzConf

```

### Built-in directives for PowerShell

The following directives cover the most common tweaking scenarios for cmdlet generation:

- [Cmdlet Suppression](#Cmdlet-Suppression)
- [Cmdlet Rename](#Cmdlet-Rename)
- [Parameter Rename](#Parameter-Rename)
- [Model Rename](#Model-Rename)
- [Property Rename](#Property-Rename)

Note: If you have feedback about these directives, or you would like additional built-in directives, feel free to open an issue at https://github.com/Azure/autorest. 

#### Cmdlet Suppression 

For cmdlet suppression we support both string literals and regex patterns. 

To remove a specific cmdlet, provide the name of the cmdlet. For example:

```yaml false
directive:
  - remove-command: New-AzConfigurationStore
```
To remove all the cmdlets that match a specific pattern, provide the regex expression. For example:


```yaml false
# Suppress all cmdlets that start with Get-AzOperation
directive:
  - remove-command: Get-AzOperation.*
```
#### Cmdlet Rename

For cmdlet renaming we support both string literals and regex patterns. 

To rename a specific cmdlet, provide the name of the cmdlet at 'where-command' node and the new name at 'set-name' node. For example:

```yaml false
directive:
  - where-command: New-AzConfigurationStore
    set-name: New-AzConf
```

To rename all the cmdlets that match a specific pattern, provide the regex expression at 'where-command' node and the replacement string at 'set-name' node. In the following example, we target all cmdlets that contain 'ConfigurationStore', use parentheses to capture three groups in the cmdlet name, and use those groups to transform the cmdlet name:

```yaml 
# Examples:
# New-AzConfigurationStoreFoo --> New-AzCStoreFoo
# Get-AzConfigurationStoreBar --> Get-AzCStoreBar

directive:
  - where-command: (.*)(ConfigurationStore)(.*)
    set-name: $1CStore$3
```

#### Model Rename

For model renaming we support both string literals and regex patterns. 

To rename a specific model, provide the name of the model at 'where-model' node and the new model name at 'set-name' node. For example:

```yaml false
directive:
  - where-model: ConfigurationStore 
    set-name:  CS
```
To rename all models that match a specific pattern, provide the regex expression at 'where-model' node and the replacement string at 'set-name' node. In the following example we find every model that starts with 'Configuration', use parentheses to capture two groups in the model name, and use those groups to transform the model name:

```yaml false
# Example:
# ConfigurationStoreKey ---> ConfigStoreKey
# ConfigurationStore ---> ConfigStore
directive:
  - where-model: (^Configuration)(.*)
    set-name:  Config$2
```
#### Parameter Rename 

To rename a parameter provide the parameter name at 'where-parameter node and the new name at 'set-name' node. For example:

```yaml false
directive:
  - where-parameter: ResourceGroupName 
    set-name:  TheResourceGroup
```

#### Property Rename 

To rename a property provide the property name at 'where-property' node and the new name at 'set-name' node. For example:

```yaml false
directive:
  - where-property: Name 
    set-name:  Nombre
```

