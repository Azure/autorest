# AutoRest PowerShell Specific Options

There are a couple of PowerShell specific things you may want to do:
- [Tweak The Way It Generates Cmdlets](#Tweak-The-Way-It-Generates-Cmdlets)
- [Control The Module Output Folder Layout](#Control-The-Module-Output-Folder-Layout)

## Tweak The Way It Generates Cmdlets

To change the way AutoRest generates cmdlets you can:
- [use the built-in directives outlined below](#Built-In-Directives)
- [declare your own directives](https://github.com/Azure/autorest/blob/master/src/autorest-core/resources/default-configuration.md#directives)
- [automatically sanitize parameter and cmdlet names](#name-sanitization)



### Built-In Directives

- [Structure and Terminology](#Structure-And-Terminology)
- [Built-In Directives Scenarios](#Built-In-Directives-Scenarios)

### Structure And Terminology
The built-in directives for PowerShell consist of three parts: 

- Selector: denoted by the field `select`, contains the object-type where the modification is taking place. It can be either:
  - `command` 
  - `parameter` 
  - `model`
  - `property` 
  - `enum`

  **Note**: Depending of the filters, AutoRest infers the type of object that needs to be selected. For example:

  ```yaml $false
    # This selects the parameters 
    # ---> where the parameter-name is VirtualMachine, and the cmdlet verb is Get
    # ---> sets the parameter alias to VM
    directive:
      - where:
          parameter-name: Foo
          verb: Get
        set: 
          alias: Bar
  ```

  A reason to provide the selector would be to change the scope of selection. For example, this would select a :

  ```yaml $false
    # This selects the cmdlets 
    #  ---> where the verb is Get, and where a parameter called Foo exists
    #  ---> sets the parameter alias to VM
    directive:
      - select: command
        where:
          parameter-name: VirtualMachine
          verb: Get
        set: 
          alias: Get-VM
  ```


- Filter: denoted by the field `where`, contains the criteria to select the object.
  - A `command` can be filtered by:
    - `verb`
    - `subject`
    - `subject-prefix`
    - `parameter-name`
  - A `parameter` can be filtered by:
    - `parameter-name`
    
    and, optionally by:
    - `verb`
    - `subject`
    - `subject-prefix`
    
    from the cmdlet it belongs to.
  - A `model` can be filtered by:
    - `model-name`
    - `property-name`
  - A `model` can be filtered by:
    - `property-name`
    
    and, optionally by:
      - `model-name`
    

- Actions: denoted by the fields `set`, `hide`, `remove` and `remove-alias`. These fields contain the actions to be performed in the selected objects.

#### Terminology Notes

#### - prefix, subject-prefix and subject 

To increase the granularity of cmdlet-tweaking, we divided the cmdlet NOUN into three parts: prefix, subject-prefix and subject. Where:

[verb]-[noun] <-> [verb]-[prefix][subject-prefix][subject]

AutoRest allows you to:

- Modify the prefix (by default empty)
  - module-wide: using ```prefix: <value>``` at the top-level of the configuration document.
- Modify the subject-prefix (by default empty)
  - module-wide: using ```subject-prefix: <value>``` at the top-level of the configuration document.
  - per-cmdlet: using  ```subject-prefix: <value>``` inside a directive.
- Modify the subject
  - per-cmdlet: use ```subject: <value>```  inside a directive.

#### - variant 

A variant is the same thing as the parameter-set name.

#### - hidden cmdlet

When a cmdlet is set to ```hide: true```, the cmdlet will be generated; however, it won't be exported at module-export time.

### Built-In Directives Scenarios 

The following directives cover the most common tweaking scenarios for cmdlet generation:

- [Cmdlet Rename](#Cmdlet-Rename)
- [Cmdlet Aliasing](#Cmdlet-Aliasing)
- [Cmdlet Suppression (Removal and Hiding)](#Cmdlet-Suppression)
- [Parameter Rename](#Parameter-Rename)
- [Parameter Aliasing](#Parameter-Aliasing)
- [Parameter Description](#Parameter-Description)
- [Model Rename](#Model-Rename)
- [Enum Value Rename](#Property-Rename)
- [Alias Removal](#Alias-Removal)

Note: If you have feedback about these directives, or you would like additional configurations, feel free to open an issue at https://github.com/Azure/autorest.powershell. 

#### Cmdlet Rename

To rename a cmdlet we support both string literals and **regex** patterns. Cmdlets can be selected and modified by ```subject-prefix```, ```subject```, ```verb```, and/or ```variant```. For example:

```yaml $false
# This will rename the cmdlet 'Get-VirtualMachine' (Parameter Set: XYZParamSet) to 'Get-VM'

directive:
  - where: 
      subject: VirtualMachine
      verb: Get
      variant: XYZParamSet
    set: 
      subject: VM       
```

The following is a Regex example:

```yaml $false
# This will change every cmdlet where the subject starts with 'Configuration',
# to have the rest of the subject as Config<rest of the subject>

directive:
    - where:
            subject: (^Configuration)(.*) 
      set:
            subject: Config$2
```

Also, it is possible to select based in a parameter-name. However, to select by parameter, the selector `command` must be provided. For example,

```yaml $false
# This will rename the cmdlet 'Get-VirtualMachine' (Parameter Set: XYZParamSet) to 'Get-VM'

directive:
  - select: command
    where: 
      subject: VirtualMachine
      verb: Get
      parameter-name: Id
    set: 
      subject: VM       
```

#### Cmdlet Aliasing

To alias a cmdlet, select the cmdlet and provide an alias:

```yaml $false
directive:
  - where: 
      verb: Get
      subject: VirtualMachine
    set: 
      alias: Get-VM       
```

Or, multiple aliases:

```yaml $false
directive:
  - where: 
      verb: Get
      subject: VirtualMachine
    set: 
      alias: 
        - Get-VMachine
        - Get-VM     
```

#### Cmdlet Suppression 

For cmdlet suppression you can either:
 - hide it: by preventing it from being exported at module-export time
 - remove it: by preventing it from being generated 
 
Note: If a cmdlet is hidden, it still can be be used by custom cmdlets.

##### Cmdlet Hiding (Exportation Suppression)

To hide a cmdlet, you need to provide ```subject-prefix```, ```subject```, ```verb```, and/or ```variant``` of the cmdlet --> then set ```hide: true``` . For example:

```yaml false
directive:
  - where: 
      verb: Update
      subject: Resource
    hide: true
```

The following is a Regex example:

```yaml false
directive:
  - where: 
      subject: PetService.*
    hide: true
```

##### Cmdlet Removal

To remove a cmdlet, you need to provide the ```subject-prefix```, ```subject```, ```verb```, and/or ```variant``` of the cmdlet ---> then, set ```remove: true```. For example:

```yaml false
directive:
  - where: 
      verb: Get
      subject: Operation
    remove: true
```

The following is a Regex example:

```yaml false
directive:
  - where: 
      subject: Config.*
    remove: true
```

#### Parameter Rename

To select a parameter you need to provide the ```parameter-name```. Furthermore, if you want to target specific cmdlets you can provide the ```subject-prefix```, ```subject```, ```verb```, and/or ```variant``` (i.e. parameter-set). For example:

```yaml false
# This will rename the parameter 'XYZName' from the cmdlet 'Get-Operation' to 'Name'.

directive:
  - where: 
      parameter-name: XYZName
      verb: Get 
      subject: Operation
    set:  
      parameter-name: Name
```

The following is a Regex example:

```yaml false
# This will rename every parameter that ends with 'Name' to just 'Name'.

directive:
  - where: 
      parameter-name: (.*)Name$
    set: 
      parameter-name: Name
```

#### Parameter Aliasing

To alias a parameter, select the parameter and provide an alias:

```yaml $false
directive:
  - where: 
      parameter-name: VirtualMachine
    set: 
      alias: VM       
```

Or, multiple aliases:

```yaml $false
directive:
  - where: 
      parameter-name: VirtualMachine
    set: 
      alias: 
        - VM
        - VMachine    
```

#### Parameter Description

To add or modify a parameter description you can use a similar pattern to renaming the parameter, but you need to set ```parameter-description```. For example:

```yaml false
directive:
  - where: 
      parameter-name: Name
      verb: Get 
      subject: Operation
    set:  
      parameter-description: This is the name of the Operation you want to retrieve.
```

#### Model Rename

To rename a specific model, provide the name of the model at ```model-name``` under ```where``` node and the new model name at ```model-name``` under the ```set``` node. For example:

```yaml false
# This will rename the model name from 'Cat' to 'Gato'.

directive:
  - where:
     model-name: Cat
    set:
     model-name: Gato
```

The following is a Regex example:

```yaml false
# This will rename every model name that start with 'VirtualMachine' to start with 'VM'.

directive:
  - where:
     model-name: ^VirtualMachine(.*)
    set:
     model-name: VM$1
```

#### Property Rename

To select a property you need to provide the ```property-name```. Furthermore, if you want to target a specific model property, you can provide the ```model-name```. For example:

```yaml false
directive:
  - where: 
      property-name: VirtualMachineName
      model-name: VirtualMachine
    set:  
      property-name: Name
```

The following is a Regex example:

```yaml false
directive:
  - where: 
      property-name: (.*)Name
    set:  
      property-name: Name
```

#### Enum Value Rename

In some instances names can have conflicts with the enum-value-names that get generated for Enum fields. In this case, we can rename the name of the value. For example:

```yaml false
- where:
      enum-name: ComparisonOperationType
      enum-value-name: Equals
    set:
      enum-value-name: Equal 
```

#### Alias Removal

If the option `--sanitize-names` or `--azure` is provided, AutoRest will make renames to cmdlets and parameters to remove redundancies. For example in the command `Get-VirtualMachine`, the parameter `VirtualMachineName` will be renamed to `Name`, and aliased to VirtualMachineName. It is possible to eliminate that alias by providing the action `remove-alias: true`:

```yaml false
- where:
      parameter-name: ResourceGroupName
  remove-alias: true
```

The same can be done with cmdlets.

### Name Sanitization

Sometimes names from cmdlets or parameters contain redundant information. For example:
- A parameter called `VirtualMachineName` from the cmdlet `Get-VirtualMachine` is somewhat redundant. A better name for such parameter could be just `Name`. 
- A cmdlet that has a verb `Get`, prefix `ContainerService` and subject `ContainerService`. The resulting cmdlet will then be `Get-ContainerServiceContainerService`. A better name for such cmdlet could just be `Get-ContainerService`.

For these cases you can provide the option `sanitize-names: true` in the configuration file or `--sanitize-names` from the command line. 

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
