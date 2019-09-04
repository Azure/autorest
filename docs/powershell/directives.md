# Built-In Directives
- [Structure and Terminology](#Structure-and-Terminology)
- [Directive Scenarios](#Directive-Scenarios)

## Structure and Terminology
The built-in directives for PowerShell consist of three parts:
- **Selector**: denoted by the field `select`, contains the object-type where the modification is taking place. It can be either:
  - `command`
  - `parameter`
  - `model`
  - `property`
  - `enum`

  *Note*: Depending of the filters, AutoRest infers the type of object that needs to be selected. For example:
  ```yaml $false
    # This selects the parameters
    # ---> where the parameter-name is VirtualMachine, and the cmdlet verb is Get
    # ---> sets the parameter alias to VM
    directive:
      - where:
          verb: Get
          parameter-name: Foo
        set:
          alias: Bar
  ```

  A reason to provide the selector would be to change the scope of selection. For example, this would select a command:
  ```yaml $false
    # This selects the cmdlets 
    #  ---> where the verb is Get, and where a parameter called Foo exists
    #  ---> sets the parameter alias to VM
    directive:
      - select: command
        where:
          verb: Get
          parameter-name: VirtualMachine
        set:
          alias: Get-VM
  ```

- **Filter**: denoted by the field `where`, contains the criteria to select the object.
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

- **Actions**: denoted by the fields `set`, `hide`, `remove` and `clear-alias`. These fields contain the actions to be performed in the selected objects.

### Terminology Notes
#### prefix, subject-prefix and subject
To increase the granularity of cmdlet-tweaking, we divided the cmdlet NOUN into three parts: *prefix*, *subject-prefix* and *subject*. Where:
```
[verb]-[noun] <-> [verb]-[prefix][subject-prefix][subject]
```

AutoRest allows you to:
- Modify the prefix (by default empty)
  - module-wide: using `prefix: <value>` at the top-level of the configuration document.
- Modify the subject-prefix (by default empty)
  - module-wide: using `subject-prefix: <value>` at the top-level of the configuration document.
  - per-cmdlet: using  `subject-prefix: <value>` inside a directive.
- Modify the subject
  - per-cmdlet: use `subject: <value>` inside a directive.

#### variant
A variant is the same thing as the parameter-set name.

#### hidden cmdlet
When a cmdlet is set to `hide: true`, the cmdlet will be generated; however, it won't be exported at module-export time.

## Directive Scenarios
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
- [Table Formatting](#Table-Formatting)
- [Argument Completers](#Argument-Completers)
- [Default Values](#Default-Values)

*Note*: If you have feedback about these directives, or you would like additional configurations, feel free to open an issue at https://github.com/Azure/autorest.powershell/issues.

### Cmdlet Rename
To rename a cmdlet we support both string literals and **regex** patterns. Cmdlets can be selected and modified by `subject-prefix`, `subject`, `verb`, and/or `variant`. For example:
```yaml $false
# This will rename the cmdlet 'Get-VirtualMachine' (Parameter Set: XYZParamSet) to 'Get-VM'
directive:
  - where:
      verb: Get
      subject: VirtualMachine
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

Also, it is possible to select based in a parameter-name. However, to select by parameter, the selector `command` must be provided. For example:
```yaml $false
# This will rename the cmdlet 'Get-VirtualMachine' (Parameter Set: XYZParamSet) to 'Get-VM'
directive:
  - select: command
    where:
      verb: Get
      subject: VirtualMachine
      parameter-name: Id
    set: 
      subject: VM
```

### Cmdlet Aliasing
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

### Cmdlet Suppression 
For cmdlet suppression you can either:
  - *hide it*: by preventing it from being exported at module-export time
  - *remove it*: by preventing it from being generated

*Note*: If a cmdlet is hidden, it still can be be used by custom cmdlets.

#### Cmdlet Hiding (Exportation Suppression)
To hide a cmdlet, you need to provide `subject-prefix`, `subject`, `verb`, and/or `variant` of the cmdlet --> then set `hide: true`. For example:
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

#### Cmdlet Removal
To remove a cmdlet, you need to provide the `subject-prefix`, `subject`, `verb`, and/or `variant` of the cmdlet ---> then, set `remove: true`. For example:
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

### Parameter Rename
To select a parameter you need to provide the `parameter-name`. Furthermore, if you want to target specific cmdlets you can provide the `subject-prefix`, `subject`, `verb`, and/or `variant` (i.e. parameter-set). For example:
```yaml false
# This will rename the parameter 'XYZName' from the cmdlet 'Get-Operation' to 'Name'.
directive:
  - where:
      verb: Get
      subject: Operation
      parameter-name: XYZName
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

### Parameter Aliasing
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

### Parameter Description
To add or modify a parameter description you can use a similar pattern to renaming the parameter, but you need to set `parameter-description`. For example:
```yaml $false
directive:
  - where:
      parameter-name: Name
      verb: Get
      subject: Operation
    set:
      parameter-description: This is the name of the Operation you want to retrieve.
```

### Model Rename
To rename a specific model, provide the name of the model at `model-name` under `where` node and the new model name at `model-name` under the `set` node. For example:
```yaml $false
# This will rename the model name from 'Cat' to 'Gato'.
directive:
  - where:
      model-name: Cat
    set:
      model-name: Gato
```

The following is a Regex example:
```yaml $false
# This will rename every model name that start with 'VirtualMachine' to start with 'VM'.
directive:
  - where:
      model-name: ^VirtualMachine(.*)
    set:
      model-name: VM$1
```

### Property Rename
To select a property you need to provide the `property-name`. Furthermore, if you want to target a specific model property, you can provide the `model-name`. For example:
```yaml $false
directive:
  - where:
      model-name: VirtualMachine
      property-name: VirtualMachineName
    set:
      property-name: Name
```

The following is a Regex example:
```yaml $false
directive:
  - where:
      property-name: (.*)Name
    set:
      property-name: Name
```

### Enum Value Rename
In some instances names can have conflicts with the enum-value-names that get generated for Enum fields. In this case, we can rename the name of the value. For example:
```yaml $false
directive:
  - where:
      enum-name: ComparisonOperationType
      enum-value-name: Equals
    set:
      enum-value-name: Equal
```

### Alias Removal
If the option `--sanitize-names` or `--azure` is provided, AutoRest will make renames to cmdlets and parameters to remove redundancies. For example in the command `Get-VirtualMachine`, the parameter `VirtualMachineName` will be renamed to `Name`, and aliased to VirtualMachineName. It is possible to eliminate that alias by providing the action `clear-alias: true`:
```yaml $false
directive:
  - where:
      parameter-name: ResourceGroupName
    clear-alias: true
```
The same can be done with cmdlets.

### Table Formatting
This allows you to set the *table format* for a model. This updates the `.format.ps1xml` to have the format described below as opposed to the automatic table format that is created at build-time. For example, we are updating the format for a VirtualMachine model to only show the Name and ResourceGroup properties. It updates the column label for ResourceGroup to Resource Group and sets the columns widths for Name and ResourceGroup:
```yaml $false
directive:
  - where:
      model-name: VirtualMachine
    set:
      format-table:
        properties:
          - Name
          - ResourceGroup
        labels:
          ResourceGroup: Resource Group
        width:
          Name: 60
          ResourceGroup: 80
```

Instead of defining an entirely new format for the model, if you'd simply like to remove some properties from the automatic format, you can use:
```yaml $false
directive:
  - where:
      model-name: VirtualMachine
    set:
      format-table:
        exclude-properties:
          - Location
```
This *will not work* in conjuction with the `properties` declaration described prior. They are mutually exclusive.

Lastly, if you wish to disable all formatting for the model (remove the automatic format from the `.format.ps1xml`), you can use:
```yaml $false
directive:
  - where:
      model-name: VirtualMachine
    set:
      suppress-format: true
```

### Argument Completers
For parameters, you can declare argument completers that will allow you to tab through the values when entering that parameter interactively. This allows you to declare a PowerShell script that will run to get the values for the completer. For example:
```yaml $false
# The script should return a list of values.
directive:
  - where:
      parameter-name: Location
    set:
      completer:
        name: Location Completer
        description: Gets the list of locations available for this resource.
        script: "'westus2', 'centralus', 'global'"
```
The name and description are optional. They are currently unused properties that may be used in documentation generation in the future.

### Default Values
For parameters, you can declare a default value script that will run to set the value for the parameter if it is not provided. Once this is declared for a parameter, that parameter will be made optional at build-time. For example:
```yaml $false
# The script should return a value for the parameter.
directive:
  - where:
      parameter-name: SubscriptionId
    set:
      default:
        name: SubscriptionId Default
        description: Gets the SubscriptionId from the current context.
        script: '(Get-AzContext).Subscription.Id'
```
The name and description are optional. They are currently unused properties that may be used in documentation generation in the future.