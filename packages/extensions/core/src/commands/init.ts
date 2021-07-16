import { createFolderUri, makeRelativeUri } from "@azure-tools/uri";
import { resolve } from "path";

export async function autorestInit(title = "API-NAME", inputs: Array<string> = ["LIST INPUT FILES HERE"]) {
  const cwdUri = createFolderUri(resolve());

  inputs = inputs.map((x) => {
    try {
      return makeRelativeUri(cwdUri, x);
    } catch {
      return x;
    }
  });

  // eslint-disable-next-line no-console
  console.log(
    `# ${title}
> see https://aka.ms/autorest

This is the AutoRest configuration file for the ${title}.

---
## Getting Started
To build the SDK for ${title}, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> ~autorest~

To see additional help and options, run:

> ~autorest --help~
---

## Configuration for generating APIs

...insert-some-meanigful-notes-here...

---
#### Basic Information
These are the global settings for the API.

~~~ yaml
# list all the input OpenAPI files (may be YAML, JSON, or Literate- OpenAPI markdown)
input-file:
${inputs.map((x) => "  - " + x).join("\n")}
~~~

---
#### Language-specific settings: CSharp

These settings apply only when ~--csharp~ is specified on the command line.

~~~ yaml $(csharp)
csharp:
  # override the default output folder
  output-folder: generated/csharp
~~~
`.replace(/~/g, "`"),
  );
}
