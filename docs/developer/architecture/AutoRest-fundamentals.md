# AutoRest Fundamentals

The AutoRest core is written in TypeScript.
On `npm`, we publish only a bootstrapper (also written in TypeScript) that acquires whichever version of the AutoRest core is requested.

The bootstrapper exposes the same CLI and the same library "AAAL" (AutoRest as a library) as the actual core.
This way, both executing the bootstrapper or taking it as a dependency lets users transparently use AutoRest without having to worry about acquisition. 


## The Pipeline

When executed, the core constructs a graph of processing steps, the "pipeline", which is then scheduled.
When using the CLI, this graph is constructed using the CLI parameters and (potentially) a configuration file.
AAAL users may also use configuration files or construct configuration in memory.
Only the core handles disk access, individual pipeline steps are executed in isolation.

### Example

![Example Pipeline](./pipeline.svg)

### Predefined Pipeline Steps

AutoRest core contains with a predefined set of potential pipeline steps, including:
- *OpenAPI definition loader*: Loads and fully resolves all `input-file`s. For the CLI, they are loaded from disk or network. AAAL users may pass their own virtual file system.
- *transformer*: Independent of the document type (OpenAPI definition, generated soruces, intermediate representations, ...), it allows users to transform the data in the pipeline, e.g. rename operations in the Swagger, search and replace curse words in generated sources with "cowbell"
- *composer*: Composes all OpenAPI definitions of one AutoRest run to a single, logically equivalent OpenAPI definition. (This is what the current generation of code generators deals with best.)
- *emitter*: Emits successfully generated artifacts (assigning them URLs taking into account settings like the `output-folder`). For the CLI, they are written to disk. AAAL users may subscribe to a corresponding event and do with the data whatever they want.

Further typical pipeline steps like code generation and validation are not part of the core and instead acquired separately as extensions (see [extensibility](AutoRest-extension.md)).
