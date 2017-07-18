# Samples

The samples in this folder cover a wide variety of AutoRest features in a tutorial fashion:
1) Common code generation scenarios
2) Validation
3) Advanced topics, e.g.
    - custom transformations
    - conditional configuration

## Running an example

To run any of these examples, call 
> `autorest <path to configuration file>`

For instance, if the current directory is *this* folder (`<repo>/Samples`), you may run 
> `autorest 1a-code-generation-minimal/readme.md`

Alternatively, you may run
> `autorest 1a-code-generation-minimal`

since AutoRest automatically searches folders for a configuration file.