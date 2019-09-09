# Customization

## Examples

### Replacing a parameter with multiple ones

The parameter `-Filter` is used to filter the results that a GET operation will return. 
The parameter is defined as an String and follows a particular format of 

```
eventTimestamp <op> <value> [and <attribute> eq <value> [and <attribute> eq <value>] ... ]
```

Where `<op>` can be `ge` ("greater than or equal") or `le` ("less than or equal"), `<attribute>` a known attribute of the records that the GET operation returns and `<value>` a corresponding value of it.

This is a case where one would choose to have different powershell parameters to represent each attribute receiving its value for filtering.
For each `<attribute>` a parameter is added.
Now, since `eventTimestamp` can be `ge` or `le` two parameters are used: `-StartEventTimestamp` and `-EndEventTimestamp`.


```powershell
function Get-Records {
[CmdletBinding(DefaultParameterSetName='Get', PositionalBinding=$false)]
param(
    # ... Other parameters

    [Parameter(HelpMessage = "The start time filter for the events")]
    [ValidateNotNull()]
    [System.DateTime]
    ${StartEventTimestamp},

    [Parameter(HelpMessage = "The end time filter for the events")]
    [ValidateNotNull()]
    [System.DateTime]
    ${EndEventTimestamp},

    [Parameter(HelpMessage='The Status of the events to fetch')]
    [ValidateNotNull()]
    [System.String]
    ${Status},

    [Parameter(HelpMessage = "The Caller of the events to fetch")]
    [ValidateNotNull()]
    [System.String]
    ${Caller},

    # ...  Other new parameters
)

process {
    $filter = [Module.Cmdlets.FilterHelper]::ParseFilterParameters($PSBoundParameters)

    $null = $PSBoundParameters.Remove("StartEventTimestamp")
    $null = $PSBoundParameters.Remove("EndEventTimestamp")
    $null = $PSBoundParameters.Remove("Status")
    $null = $PSBoundParameters.Remove("Caller")
    # ... Other added parameters

    Module.internal\Get-Records @PSBouldParameters
}
}
```

Here, `ParseFilterParameters` is a static method written in C#. 
`AddFilterConditionIfExists` is a helper function that add the attribute condition (`<attirbute> eq <value>`) to the filter parameter if it exists in the parameter dicionary.

```csharp
namespace Module.Cmdlets
{
    public static class FilterHelper
    {
        public static string ParseFilterParameters(System.Collections.Generic.Dictionary<string, object> parameters)
        {
            string filterQuery = "";
            filterQuery = AddFilterConditionIfExists(parameters, filterQuery, "StartEventTimestamp");
            filterQuery = AddFilterConditionIfExists(parameters, filterQuery, "EndEventTimestamp");
            filterQuery = AddFilterConditionIfExists(parameters, filterQuery, "Status");
            filterQuery = AddFilterConditionIfExists(parameters, filterQuery, "Caller");
            // ... Other parameters

            return filterQuery;
        }
    }
}
```
