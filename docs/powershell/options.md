# AutoRest PowerShell Specific Options

There are a couple of PowerShell specific things you may want to do:
- [Tweak The Way It Generates Cmdlets](#Tweak-The-Way-It-Generates-Cmdlets)
- [Control The Module Output Folder Layout](#Control-The-Module-Output-Folder-Layout)

## Tweak The Way It Generates Cmdlets

To change the way AutoRest generates cmdlets you can use one of the built-in directives outlined below, or you can [declare your own directives](https://github.com/Azure/autorest/blob/master/src/autorest-core/resources/default-configuration.md#directives). You may specify the directives you want to use at the top-level of the Literate Configuration document. For example:


```yaml 
directive:
  - where: 
      noun: Configuration
    set: 
      noun: ServiceConfiguration
```

### Built-in directives for PowerShell

The following directives cover the most common tweaking scenarios for cmdlet generation:

- [Cmdlet Rename](#Cmdlet-Rename)
- [Cmdlet Suppression (Removal and Hiding)](#Cmdlet-Suppression)
- [Parameter Rename](#Parameter-Rename)
- [Parameter Description](#Parameter-Description)
- [Model Rename](#Model-Rename)
- [Property Rename](#Property-Rename)

Note: If you have feedback about these directives, or you would like additional built-in directives, feel free to open an issue at https://github.com/Azure/autorest. 

#### Cmdlet Rename

To rename a cmdlet we support both string literals and **regex** patterns. Cmdlets can be selected and modified by noun, verb, and/or variant (i.e. parameter-set). For example:

```yaml 
# This will rename the cmdlet 'Get-Resource' (Parameter Set: XYZParamSet) to 'Get-ServiceResource'

directive:
  - where: 
      noun: Resource
      verb: Get
      variant: XYZParamSet
    set: 
      noun: ServiceResource
```

The following is a **Regex** example:

```yaml 
# This will rename every cmdlet that contains the verb Get and starts with the noun 'Configuration',
# to Get-VMConfiguration<rest-of-noun>

directive:
    - where:
            noun: (^Configuration.*) 
            verb: Get
      set:
            noun: VM$1
```

**Prefix:** Also, if you want to add a prefix to every cmdlet noun, simply provide 'prefix:\<custom-prefix\>' in the configuration:

```yaml 
# This will add a prefix at the beginning of every cmdlet noun
# Example: Get-Service ---> Get-MyPrefix Service, Update-XYZ ---> Update-MyPrefixXYZ 

prefix: MyPrefix
```

Note: Prefix is not a directive. Thus, it should not be added under a 'directive' node, but at the top level of the configuration file.

#### Cmdlet Suppression 

For cmdlet suppression you can either suppress it by **preventing it from being generated (removal), or by preventing it from being exported at module-export time (hiding).** 

##### Cmdlet Removal

To remove a cmdlet, you need to provide the noun, verb, and/or variant of the cmdlet; then, set the directive property 'remove: true'. For example:

```yaml false
directive:
  - where: 
      noun: Operation
    remove: true
```

(**Regex**) The following is a **Regex** example:

```yaml false
directive:
  - where: 
      noun: PetService.*
    remove: true
```

##### Cmdlet Hiding (Exportation Suppression)

To hide a cmdlet, you need to provide the noun, verb, and/or variant of the cmdlet; then set 'set.hide: true'. For example:

```yaml false
directive:
  - where: 
      verb: Update
      noun: Resource
    set: 
      hide: true
```

The following is a **Regex** example:

```yaml false
directive:
  - where: 
      noun: PetService.*
    set: 
      hide: true
```

#### Parameter Rename

To rename a parameter we support both string literals and **regex** patterns. To select a parameter you need to provide the 'parameter-name'. Furthermore, if you want to target specific cmdlets you can provide the noun, verb, and/or variant (i.e. parameter-set). For example:

```yaml false
# This will rename the parameter 'XYZName' from the cmdlet 'Get-Operation' to 'Name'.

directive:
  - where: 
      parameter-name: XYZName
      verb: Get 
      noun: Operation
    set:  
      parameter-name: Name
```

The following is a **Regex** example:

```yaml false
# This will rename every parameter that ends with 'Name' to just 'Name'.

directive:
  - where: 
      parameter-name: (.*)Name$
    set: 
      parameter-name: Name
```

#### Parameter Description

To add or modify a parameter description you can use a similar pattern to renaming the parameter, but you need to set 'parameter-description'. For example:

```yaml false
directive:
  - where: 
      parameter-name: Name
      verb: Get 
      noun: Operation
    set:  
      parameter-description: This is the name of the Operation you want to retrieve.
```

#### Model Rename

For model renaming we support both string literals and regex patterns. 

To rename a specific model, provide the name of the model at 'model-name' under 'where' node and the new model name at 'model-name' under the 'set' node. For example:

```yaml false
# This will rename the model name from 'Cat' to 'Gato'.

directive:
  - where:
     model-name: Cat
    set:
     model-name: Gato
```

The following is a **Regex** example:

```yaml false
# This will rename every model name that start with 'VirtualMachine' to start with 'VM'.

directive:
  - where:
     model-name: ^VirtualMachine(.*)
    set:
     model-name: VM$1
```

#### Property Rename

To rename a property we support both string literals and **regex** patterns. To select a property you need to provide the 'property-name'. Furthermore, if you want to target a specific model property, you can provide the 'model-name'. For example:

```yaml false
directive:
  - where: 
      property-name: VirtualMachineName
      model-name: VirtualMachine
    set:  
      property-name: Name
```

The following is a **Regex** example:

```yaml false
directive:
  - where: 
      property-name: (.*)Name
    set:  
      property-name: Name
```

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
