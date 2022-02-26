# Configuration

Instead of putting all the switches on the command line, AutoRest can use a _configuration file_.

The format of this file can be one of three formats:

- (.yaml) YAML - a yaml file with configuration in it
- (.json) JSON - a json file with configuration in it.
- (.md) markdown -- a _literate configuration_ file, with triple-backtick YAML or JSON code blocks.
  Literate configuration files have the advantage of being able to mix documentation and settings easily,
  and code blocks can be turned on and off with your own switches.<br>We use a lot of literate
  configuration files both internally in AutoRest and in the Azure Rest API specs repository as well.

## Configuration file examples

The options available in a configuration file are the same as the ones on the command line. (with the exception of `--debug` and `--verbose`, which are only activated on the command line)

Just remove the double-dash and format appropriately.

For more advanced configuration scenarios, see

### YAML

`sample.yaml` configuration file:

```yaml
---
# it's the same options as command line options, just drop the double-dash!
input-file: myswagger.json
namespace: MyCompany.Rest
output-folder: output
```

Usage:

```powershell
> autorest sample.yaml

```

### JSON

`sample.json` configuration file:

```json
{
  "input-file": "myswagger.json",
  "namespace": "MyCompany.Rest",
  "output-folder": "output"
}
```

Usage:

```powershell
> autorest sample.yaml

```

### Markdown - Literate Configuration

Since literate configuration files offer a lot more flexibility, AutoRest offers a bit more support for them.

If your file is named `readme.md`, autorest will find it automatically when run from the folder where the `readme.md` file is

AutoRest identifies a markdown file as a literate configuration file when it contains the magic string `> see https://aka.ms/autorest` on a line by itself.

`readme.md` configuration file:

````markdown
# My API

This file contains the configuration for generating My API from the OpenAPI specification.

> see https://aka.ms/autorest

```yaml
# it's the same options as command line options, just drop the double-dash!
input-file: myswagger.json
namespace: MyCompany.Rest
output-folder: output
```

## Alternate settings

This section is only activated if the `--make-it-rain` switch is added to the command line

```yaml $(make-it-rain)
namespace: MyCompany.Special.Rest
```
````

For more details, see [Literate File Formats](./literate-file-formats/readme.md) and [autorest configuration files](literate-file-formats/configuration.md) (Note: documentation needs updating...)
