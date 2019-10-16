## PowerShell Customizations

### What are customizations?

Customizations are a layer on top of the generated code that provide additional functionality that isn't directly exposed through the REST API specification used to generate the cmdlets. Customizations can be found in the `custom` folder at the root of every module folder, and are written in C# or PowerShell. Customizations can be brand new cmdlets, additional variants on top of existing cmdlets, and code that chains together multiple cmdlet calls within the module regardless of if the cmdlet is public or hidden.

### How are customizations used?

Customizations are bundled together in their own module, `MyModule.custom`, which is referenced by the module that users ultimately download, `MyModule`. Running the `build-modules.ps1` script will create this new custom module and ensure that each customization is called in some fashion through the exported cmdlets.

### Using the `PSBoundParameters` dictionary

When a cmdlet is executed, the mapping of parameters provided and their corresponding values are stored in a variable called `PSBoundParameters`, which should be used to determine which parameters were provided by the user and can be passed along to any additional cmdlet calls.

To determine if a parameter was provided by the user, the following check should be used:

**PowerShell**

```powershell
if ($PSBoundParameters.ContainsKey("ParameterA"))
{
    # The variable $ParameterA has a value that was provided by the user
}
```

The `PSBoundParameters` dictionary can also be passed to other cmdlets via splatting: rather than redefining all of the parameters and their values for the next cmdlet call, the cmdlet can use a special syntax to accept a dictionary, and all of the key-value pairs in the dictionary will be considered parameters and their corresponding values.

To provide a dictionary, specifically `PSBoundParameters`, to another cmdlet via splatting, the following should be used:

**PowerShell**

```powershell
MyModule\Get-Foo @PSBoundParameters
```

Before providing the `PSBoundParameters` dictionary to the next cmdlet, it should be verified that all of the parameters defined in this dictionary are available in the next cmdlet. If there is a parameter with a value in the dictionary, but it's not found in the next cmdlet, then it should be removed from the `PSBoundParameters` dictionary.

To remove a parameter from the `PSBoundParameters` dictionary, the following should be used:

**PowerShell**

```powershell
if ($PSBoundParameters.ContainsKey("Foo"))
{
    # The variable $Foo has a value that was provided by the user

    # The -Foo parameter is not found in the next cmdlet, so we should remove it once we're done using it
    $null = $PSBoundParameters.Remove("Foo")
}
```

_Note_: for PowerShell, the removal operation is assigned to a `$null` variable to prevent the returned `bool` from being written to the output stream from the cmdlet; this should be done for the removal operation on a dictionary, or any other command or call that returns a value.

If a parameter should be added to the `PSBoundParameters` dictionary before being passed to the next cmdlet, then the following should be used:

**PowerShell**

```powershell
$null = $PSBoundParameters.Add("Bar", $BarValue)
```

### Handling cmdlets that support `ShouldProcess` or `-AsJob`

When adding a variant or new cmdlet that requires supporting `ShouldProcess` or `-AsJob`, the contents of `PSBoundParameters` must be kept in mind if any additional cmdlet calls are made within the customization. These two scenarios could add `-Confirm`, `-WhatIf` and `-AsJob` to the `PSBoundParameters` dictionary, and attempting to send this set of parameters to a cmdlet that doesn't support `ShouldProcess` and/or `-AsJob` will result in an unusable scenario for the user. To avoid this case, the `PSBoundParameters` dictionary could be copied and stripped of these additional parameters in the case that the cmdlet they're being passed to don't support the scenarios.

<detail>
<summary>Click to expand PowerShell example</summary>

```powershell
function Update-Foo_SampleVariant {
    [OutputType('...')]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess)]
    [PowerShell.Cmdlets.MyModule.Description('...')]
    param(
        [Parameter(Mandatory, HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterA},

        [Parameter(HelpMessage='...')]
        [System.Management.Automation.SwitchParameter]
        # ...
        ${AsJob},

        # Common parameters omitted
    )

    process {
        $GetPSBoundParameters = $PSBoundParameters
        $null = $GetPSBoundParameters.Remove("Confirm")
        $null = $GetPSBoundParameters.Remove("WhatIf")
        $null = $GetPSBoundParameters.Remove("AsJob")
        $Foo = MyModule\Get-Foo @GetPSBoundParameters

        $Foo.ParameterA = $ParameterA
        $null = $PSBoundParameters.Remove("ParameterA")
        $null = $PSBoundParameters.Add("InputObject", $Foo)
        MyModule\Set-Foo @PSBoundParameters
    }
}
```

</detail>

### Examples

#### Making calls to other cmdlets

In a lot of cases, customizations will make calls to generated cmdlets; this can be to forward a set of parameters constructed in a variant to an existing cmdlet, add addiitonal properties to the return object, or to call hidden (internal) cmdlets.

In these cases, to call a cmdlet from an existing module, you will need to use the module-qualified cmdlet name:

```powershell
MyModule\Get-Foo @PSBoundParameters
```

_Note_: `MyModule` should be the name of the module that is currently being developed in as cross-module dependencies are not allowed.

Cmdlets that are hidden with directives are still accessible by the cmdlets defined in `custom`, but these hidden cmdlets are bundled into a separate module: `MyModule.internal`. To make a call to a hidden cmdlet, the module-qualified name will need to be updated to reflect this separate module:

```powershell
MyModule.internal\Get-FooDeleted @PSBoundParameters
```

Similarly, custom cmdlets can be accessed by other custom cmdlets, but these cmdlets are bundled into a separate module as well: `MyModule.custom`. To make a call to a custom cmdlet, the module-qualified name will need to be updated to reflect this separate module:

```powershell
MyModule.custom\Get-Foo_GetByResourceGroup @PSBoundParameters
```

#### Adding a single variant

**PowerShell**

To add a single variant to an existing cmdlet, create a new `.ps1` file in the `custom` folder for the module and call it `{CMDLET}_{VARIANT}.ps1`, where `{CMDLET}` is the name of the cmdlet that the variant is being added to, and `{VARIANT}` is the name of the variant (or parameter set). Inside of this file, define the function `{CMDLET}_{VARIANT}`, including all necessary cmdlet attributes, help information, new and existing parameters, and all of the common parameters.

Here are a few things to take into consideration when creating a single variant:

- The variant should have the same output type as the existing cmdlet, or have a type that derives from the existing output type
- If the variant is intended to be the default parameter set for the cmdlet, in the `CmdletBinding` attribute for the script, be sure to specify `DefaultParameterSetName='{VARIANT}'`
- Individual parameters won't need the property `ParameterSetName` as all of the parameters in this file will be considered to be in the parameter set named `{VARIANT}`
- If the parameters are being passed to another cmdlet, make sure to remove any parameters from `PSBoundParameters` that aren't defined in the next cmdlet

<details>
<summary>Click to expand PowerShell example</summary>

```powershell
function Get-Foo_SampleVariant {
    [OutputType('...')]
    [CmdletBinding(PositionalBinding=$false)]
    [PowerShell.Cmdlets.MyModule.Description('...')]
    param(
        [Parameter(Mandatory, HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterA},

        [Parameter(Mandatory, HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterB},

        # Common parameters omitted
    )

    process {
        if ($PSBoundParameters.ContainsKey("ParameterA"))
        {
            # Do something with the -ParameterA parameter

            # If necessary, remove the -ParameterA parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterA")
        }

        if ($PSBoundParameters.ContainsKey("ParameterB"))
        {
            # Do something with the -ParameterB parameter

            # If necessary, remove the -ParameterB parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterB")
        }

        # Perform action

        # If this variant should call back to the original cmdlet, use splatting to pass the existing set of parameters
        MyModule\Get-Foo @PSBoundParameters
    }
}
```

</details>

#### Adding multiple variants

To add multiple variants to an existing cmdlet, create a new `.ps1` file in the `custom` folder for the module and call it `{CMDLET}.ps1`, where `{CMDLET}` is the name of the cmdlet that the variants are being added to. Inside of this file, define the function `{CMDLET}`, including all necessary cmdlet attributes, help information, new and existing parameters, and all of the common parameters.

Here are a few things to take into consideration when creating multiple variants:

- The variants should have the same output type as the existing cmdlet, or have a type that derives from the existing output type
- If one of the variants is intended to be the default parameter set for the cmdlet, in the `CmdletBinding` attribute for the script, be sure to specify `DefaultParameterSetName='{VARIANT}'`
- Individual parameters should have the property `ParameterSetName` in each of their parameter attributes to mak sure they are placed in the correct variant(s)
- If the parameters are being passed to another cmdlet, make sure to remove any parameters from `PSBoundParameters` that aren't defined in the next cmdlet

<details>
<summary>Click to expand PowerShell example</summary>

```powershell
function Get-Foo {
    [OutputType('...')]
    [CmdletBinding(PositionalBinding=$false)]
    [PowerShell.Cmdlets.MyModule.Description('...')]
    param(
        [Parameter(ParameterSetName='GetByParameterA', Mandatory, HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterA},

        [Parameter(ParameterSetName='GetByParameterB', Mandatory, HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterB},

        # Common parameters omitted
    )

    process {
        if ($PSBoundParameters.ContainsKey("ParameterA"))
        {
            # Do something with the -ParameterA parameter

            # If necessary, remove the -ParameterA parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterA")
        }

        if ($PSBoundParameters.ContainsKey("ParameterB"))
        {
            # Do something with the -ParameterB parameter

            # If necessary, remove the -ParameterB parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterB")
        }

        # Perform action

        # If these variants should call back to the original cmdlet, use splatting to pass the existing set of parameters
        MyModule\Get-Foo @PSBoundParameters
    }
}
```

</details>

#### Creating a new cmdlet

Similar to adding multiple variants to an existing cmdlet, adding a new cmdlet requires creating a new `.ps1` file in the `custom` folder for the module and calling it `{CMDLET}.ps1`, where `{CMDLET}` is the name of the new cmdlet. Inside of this file, define the function `{CMDLET}`, including all necessary cmdlet attributes, help information, parameters and any necessary common parameters.

<details>
<summary>Click to expand PowerShell example</summary>

```powershell
# Since this API does not support easily adding a new Foo object to the existing list of Foo objects that
# the user has created, this cmdlet will make two calls to do so:
# (1) Get the list of existing Foo objects
# (2) Update the list to add a Foo object we've created with the parameters provided by the user
function Add-Foo {
    [OutputType('...')]
    [CmdletBinding(PositionalBinding=$false)]
    [PowerShell.Cmdlets.MyModule.Description('...')]
    param(
        [Parameter(Mandatory, HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterA},

        [Parameter(HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterB},

        [Parameter(HelpMessage='...')]
        [System.String]
        # ...
        ${ParameterC},

        # Common parameters omitted
    )

    process {
        if ($PSBoundParameters.ContainsKey("ParameterB"))
        {
            # Do something with the -ParameterB parameter

            # If necessary, remove the -ParameterB parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterB")
        }

        if ($PSBoundParameters.ContainsKey("ParameterC"))
        {
            # Do something with the -ParameterC parameter

            # If necessary, remove the -ParameterC parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterC")
        }

        $NewFoo = @{ ... } # Create some Foo object
        $ExistingFooList = MyModule\Get-Foo @{ ... } # Use custom set of parameters for this call
        $ExistingFooList.Add( $NewFoo )
        MyModule\Update-Foo @{ FooList = $ExistingFooList; ... } # Add any additional parameters needed
    }
}
```

</details>

#### Replacing existing parameters

In some cases, there are exposed parameters that require the user to have background information about what should be provided or provide lengthy strings that can be broken up into components. In these cases, it's beneficial to create a new variant that doesn't use these parameters, but rather introduces new parameters that are easy for the user to know the value of on the command line, and the customization will construct the original parameter for them.

For example, the `-Filter` parameter is often an [OData expression](https://docs.microsoft.com/en-us/dynamics-nav/using-filter-expressions-in-odata-uris) that can be used to filter the results of a list call. In most cases, this `-Filter` parameter expects a string following the expression pattern that knows about the different properties that can be filtered on, such as `properties/usageStart ge '2019-08-01' and properties/usageEnd le '2019-08-31' and properties/name eq 'myName'`. To make it easier for the user to use this `-Filter` parameter, we can introduce a new variant that has parameters for each of the properties that can be provided in this expression:

<details>
<summary>Click to expand PowerShell example</summary>

```powershell
function Get-Foo_ExpandFilter {
    # Header attributes omitted
    param(
        [Parameter(HelpMessage='...')]
        [System.DateTime]
        # ...
        ${StartDate},

        [Parameter(HelpMessage='...')]
        [System.DateTime]
        # ...
        ${EndDate},

        [Parameter(HelpMessage='...')]
        [System.String]
        # ...
        ${Name},

        # Common parameters omitted
    )

    process {
        $DateTimeFormat = 'yyyy-MM-dd'
        $Filter = $null
        if ($PSBoundParameters.ContainsKey('StartDate'))
        {
            $FromDate = $StartDate.ToString($DateTimeFormat)
            $Filter = "properties/usageStart ge '$FromDate'"
            $null = $PSBoundParameters.Remove("StartDate")
        }

        if ($PSBoundParameters.ContainsKey('EndDate'))
        {
            $ToDate = $EndDate.ToString($DateTimeFormat)
            if ($null -ne $Filter)
            {
                $Filter += " and "
            }

            $Filter += "properties/usageEnd le '$ToDate'"
            $null = $PSBoundParameters.Remove("EndDate")
        }

        if ($PSBoundParameters.ContainsKey('Name'))
        {
            if ($null -ne $Filter)
            {
                $Filter += " and "
            }

            $Filter += "properties/name eq '$Name'"
            $null = $PSBoundParameters.Remove("Name")
        }

        $null = $PSBoundParameters.Add("Filter", $Filter)
        MyModule\Get-Foo @PSBoundParameters
    }
}
```

</details>

Another example of replacing an existing parameter is when the user needs to provide a lengthy string that can be broken up into individual components. In Azure, a "scope" determines at what level an operation is going to occur on; this can include tenant level (_i.e._, `/` scope), subscription level (_i.e._, `/subscriptions/{SUBSCRIPTION_ID}` scope), resource group level (_i.e._, `/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP}`) or resource level (_i.e._, `/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP}/providers/{RESOURCE_TYPE}/{RESOURCE_NAME}`). Having the user construct these potentially lengthy strings can be difficult on the command line, so introducing variants that allow the user to provide individual components makes it easier for them to use the cmdlet:

<details>
<summary>Click to expand PowerShell example</summary>

```powershell
function Get-Foo {
    # Header attributes omitted
    param(
        [Parameter(ParameterSetName='ScopeBySubscription', Mandatory, HelpMessage='...')]
        [Parameter(ParameterSetName='ScopeByResourceGroupName', Mandatory, HelpMessage='...')]
        [Parameter(ParameterSetName='ScopeByResource', Mandatory, HelpMessage='...')]
        ${SubscriptionId},

        [Parameter(ParameterSetName='ScopeByResourceGroupName', Mandatory, HelpMessage='...')]
        [Parameter(ParameterSetName='ScopeByResource', Mandatory, HelpMessage='...')]
        ${ResourceGroupName},

        [Parameter(ParameterSetName='ScopeByResource', Mandatory, HelpMessage='...')]
        ${ResourceType},

        [Parameter(ParameterSetName='ScopeByResource', Mandatory, HelpMessage='...')]
        ${ResourceName},

        # Common parameters omitted
    )

    process {
        $Scope = "/"
        if ($PSBoundParameters.ContainsKey("SubscriptionId"))
        {
            $Scope += "subscriptions/$SubscriptionId"
            $null = $PSBoundParameters.Remove("SubscriptionId")
        }

        if ($PSBoundParameters.ContainsKey("ResourceGroupName"))
        {
            $Scope += "/resourceGroups/$ResourceGroupName"
            $null = $PSBoundParameters.Remove("ResourceGroupName")
        }

        if ($PSBoundParameters.ContainsKey("ResourceName"))
        {
            $Scope += "/providers/$ResourceType/$ResourceName"
            $null = $PSBoundParameters.Remove("ResourceType")
            $null = $PSBoundParameters.Remove("ResourceName")
        }

        $null = $PSBoundParameters.Add("Scope", $Scope)
        MyModule\Get-Foo @PSBoundParameters
    }
}
```

</details>

#### Removing an unnecessary parameter

If it's the case that a parameter in a generated variant should be removed (possibly to be given a constant value), the variant that uses this parameter should be hidden and a new variant should be created in its place that doesn't expose the parameter.

For example, if a variant exposes a `-Scope` parameter for the user to set, but the value of this parameter can only ever be `/`, and providing any other value will result in an exception from the server, then we should remove this parameter and set the value for the user in a new custom variant:

<details>
<summary>Click to expand PowerShell example</summary>

```powershell
function Get-Foo_ListAll {
    # Header attributes omitted
    param(
        # All parameters (except -Scope) from the hidden variant omitted

        # Common parameters omitted
    )

    process {
        $null = $PSBoundParameters.Add("Scope", "/")
        MyModule.internal\Get-Foo @PSBoundParameters # Call the hidden (internal) module
    }
}
```

</details>

#### Modifying model types

If additional properties need to be added to a model type, specifically those returned from cmdlets, then a new file should be created in the `custom` folder that is called `{MODEL}.cs`, where `{MODEL}` is the name of the model object that properties are being added to. Inside of this file, a partial class should be created that has the same namespace of the model object you're adding the properties to.

<details>
<summary>Click to expand C# example</summary>

```cs
using System;

namespace PowerShell.Cmdlets.MyModule.Models
{
    public partial class Foo
    {
        public string FullName
        {
            get
            {
                // This model doesn't have a FullName property, so we can construct its value from
                // the existing FirstName and LastName properties on the model
                return string.Format("{0} {1}", this.FirstName, this.LastName);
            }
        }
    }
}
```

</details>
