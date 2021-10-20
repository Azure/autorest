# Default Configuration - Help Configuration

This contains the definitions for the command line help.

#### Help

```yaml $(help)
input-file: dummy # trick "no input file" checks... may wanna refactor at some point

pipeline:
  help:
    scope: help

output-artifact:
  - help
```

Note: We don't load anything if `--help` is specified.
