# Scenario: Include further configuration files (probing)

This file only gets include if you say `--csharp`

> see https://aka.ms/autorest

``` yaml
try-require: # can be a single relative/absolute path/URL or an array of such
  - ../1a-code-generation-minimal/readme.md
```

However, note that paths within included configuration files will be resolved relative to *this* file instead of the included one.
This becomes relevant for `input-file`s or further `require`s in referenced files.
Use `require` together with `batch` mode and `base-folder` if the intent is to invoke AutoRest on other, self-contained configuration files.

Common use cases for external configuration files include extracting and reusing:
- verbose code generation settings
- large numbers of directives
- declarations