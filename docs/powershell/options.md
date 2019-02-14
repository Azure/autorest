# AutoRest PowerShell Specific Options

There are a couple of PowerShell specific things you may want to do:
- [Control The Module Output Folder Layout](#Control-The-Module-Output-Folder-Layout)
- [Tweak The Way It Generates Cmdlets](#Tweak-The-Way-It-Generates-Cmdlets)

## Control The Module Output Folder Layout

By default, AutoRest's PowerShell Generator will place all the files under [this directory layout](./default-directory-layout.md). However, if you want to customize the directory layout, you may specify the following nodes at the top-level of the Literate Configuration document:

#### output folder 

Contains all the code generated. By default, AutoRest will create a folder called 'generated' inside the current working directory. If you want to tweak the location use:

```yaml
output-folder: <path> 
```

#### module folder

Contains the low-level c# files and script cmdlets. By default, AutoRest will create a folder called 'generated' inside the output folder. If you want to tweak the location use:

```yaml
module-folder: <path> 
```

#### cmdlets folder

Contains the low-level c# cmdlet files. By default, AutoRest will create a folder called 'cmdlets' inside the module folder. If you want to tweak the location use:

```yaml
cmdlet-folder: <path> 
```

#### models cmdlets folder

Contains the  low-level c# model-cmdlet files. By default, AutoRest will create a folder called 'model-cmdlet' inside the module folder. If you want to tweak the location use:

```yaml
model-cmdlet-folder: <path> 
```

#### custom cmdlet folder

Contains any cmdlet customized by you. Initially it will be empty. By default, AutoRest will create a folder called 'custom' at the top level of the output-folder. If you want to tweak the location use:

```yaml
custom-cmdlet-folder: <path> 
```

#### test folder

Contains example pester tests, and a http pipeline mocking script. By default, AutoRest will create a folder called 'test' at the top level of the output-folder. If you want to tweak the location use:

```yaml
test-folder: <path> 
```

#### runtime, api, and api-extensions folders

Contain low level c# files. If you want to tweak their location, you can use respectively:

```yaml
runtime-folder: <path>
api-folder: <path> 
api-extensions-folder: <path>  
```


#### file renames

In addition, if you desire to rename the module name or specific file names, you may use:

```yaml
module-name: <name>
csproj: <name> # c# project file
psd1: <name>  # manifest file
psm1: <name>  # module file
```

Note: By default these files will be named after the module-name. For example, the manifest file will be \<module-name>.psd1.


## Tweak The Way It Generates Cmdlets

To change the way AutoRest generates cmdlets you can use one of the built-in directives outlined below, or you can [declare your own directives](https://github.com/Azure/autorest/blob/master/src/autorest-core/resources/default-configuration.md#directives). You may specify the directives you want to use at the top-level of the Literate Configuration document. For example:


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

#### Cmdlet Generation Suppression 

For cmdlet generation suppression we support both string literals and regex patterns. 

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

