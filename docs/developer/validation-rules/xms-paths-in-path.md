# XmsPathsInPath
## Description
The `x-ms-paths` extension is a way to overcome an OpenAPI limitation that disallows query parameters in paths. This is not desirable when a query parameter value can determine the response model type. See the [`x-ms-paths` documentation](../../extensions/index.md#x-ms-paths) for more information on usage.

Paths defined in `x-ms-paths` should share a base path with a path defined in the regular paths section. If this regular path is omitted, then it is effectively invisible from other OpenAPI tools, since the `x-ms-paths` extension is a custom extension for AutoRest.
## How to fix
Add a path to the `paths` section in your spec that has the same path (without query parameters) for each path overload in `x-ms-paths`