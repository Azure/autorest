# Scenario: Output artifacts as messages

> see https://aka.ms/autorest

To wire AutoRest together with other command line tools, it might be helpful to emit generated artifacts on the command line. That way, another tool can consume the artifacts without involving the disk.

``` yaml
input-file: tiny.yaml
output-folder: stdout://
message-format: json
csharp: true
output-artifact: configuration.yaml
```