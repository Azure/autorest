# AutoRest Core 

## 1/23/2020
- on secondary swagger files, schema schema validation is relaxed to be warnings.
- drop unreferenced requestBodies during merge
- supports v2 generators (and will by default, fall back to a v2 core unless overriden with `--version:`
- if a v3 generator is loaded via `--use:` , it should not attempt to load v2 generator  even if `--[generator]` is specified (ie, `--python` `--use:./python` ) should be perfectly fine 
- the v3 generator name in `package.json` should be `@autorest/[name]` - ie `@autorest/csharp` 
- it will only assume `--tag=all-api-versions`  if either `--profile:`... or `--api-version:`... is specified. 

## 1/13/2020
- rebuild to pick up newer extension library that supports python interpreter detection
