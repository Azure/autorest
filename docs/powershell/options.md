# AutoRest PowerShell Specific Options


## Controlling the output folder layout

## Tweaking the way it generates cmdlets

#### Command-Removal (regex)
```yaml false
directive:
  - remove-command: Get-AzOperation.*
```

#### Command-Removal (string literal)
```yaml false
directive:
  - remove-command: New-AzConfigurationStore
```

#### Command-Rename (regex)
```yaml 
directive:
  - where-command: (.*)(ConfigurationStore)(.*)
    set-name: $1CStore$3
```

#### Command-Rename (string literal)
```yaml false
directive:
  - where-command: New-AzConfigurationStore
    set-name: New-AzConf
```

#### Model Raname (regex)
```yaml false
directive:
  - where-model: (^Configuration)(.*)
    set-name:  Config$2
```

#### Model Rename (string literal)
```yaml false
directive:
  - where-model: ConfigurationStore 
    set-name:  CS
```

#### Parameter Rename and Aliasing
```yaml false
directive:
  - where-parameter: ResourceGroupName 
    set-name:  TheResourceGroup
```

#### Property Rename and Aliasing
```yaml false
directive:
  - where-property: Name 
    set-name:  Nombre
```

