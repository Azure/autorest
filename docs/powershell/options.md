# AutoRest PowerShell Options
To change the way AutoRest generates, you can configure:
- [Name Sanitation](#Name-Sanitization)
- [Folder Layout](#Folder-Layout)
- [Built-In Directives](directives.md)
- [Custom Directives](../../autorest-core/resources/default-configuration.md#directives)

## Name Sanitization
Sometimes names from cmdlets or parameters contain redundant information. For example:
- A parameter called `VirtualMachineName` from the cmdlet `Get-VirtualMachine` is somewhat redundant. A better name for such parameter could be just `Name`.
- A cmdlet that has a verb `Get`, prefix `ContainerService` and subject `ContainerService`. The resulting cmdlet will then be `Get-ContainerServiceContainerService`. A better name for such cmdlet could just be `Get-ContainerService`.

For these cases you can provide the option `sanitize-names: true` in the configuration file or `--sanitize-names` from the command line. You can disable name sanitization with `sanitize-names: false`.

## Folder Layout
By default, AutoRest's PowerShell Generator will place all the files under [this directory layout](./default-directory-layout.md). The configuration for the default directories can be found in the [defaults.md](https://github.com/Azure/autorest.powershell/blob/master/extensions/powershell/defaults.md) for the PowerShell extension. However, if you want to customize the directory layout, you may specify those nodes at the top-level of your configuration. Here are descriptions for some of the folders/files:

### Output Folder
Contains all the code generated. By default, AutoRest will create a folder called 'generated' inside the current working directory. If you want to change the location use:
```yaml
output-folder: <path>
```

### Module Folder
Contains the low-level C# files and script cmdlets. By default, AutoRest will create a folder called 'generated' inside the output folder. If you want to change the location use:
```yaml
module-folder: <path>
```

### Cmdlets Folder
Contains the low-level C# cmdlet files. By default, AutoRest will create a folder called 'cmdlets' inside the module folder. If you want to change the location use:
```yaml
cmdlet-folder: <path>
```

### Custom Cmdlet Folder
Contains any cmdlet customized by you. Initially it will be empty. By default, AutoRest will create a folder called 'custom' at the top level of the output-folder. If you want to change the location use:
```yaml
custom-cmdlet-folder: <path>
```

### test folder
Contains Pester tests. By default, AutoRest will create a folder called 'test' at the top level of the output-folder. If you want to change the location use:
```yaml
test-folder: <path>
```

### Runtime and API Folders
Contain low level c# files. If you want to change their location, you can use respectively:
```yaml
runtime-folder: <path>
api-folder: <path>
```

### File Renames
In addition, if you desire to rename the module name or specific file names, you may use:
```yaml
module-name: <name>
csproj: <name> # C# project file
psd1: <name> # module manifest file
psm1: <name> # script module file
```
Note: By default these files will be named after the module-name. For example, the manifest file will be \<module-name>.psd1. You can see the full list of file names in the [defaults.md](https://github.com/Azure/autorest.powershell/blob/master/extensions/powershell/defaults.md) for the PowerShell extension.