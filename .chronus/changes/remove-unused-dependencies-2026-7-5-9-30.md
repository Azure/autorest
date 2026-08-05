---
changeKind: internal
packages:
  - "@autorest/core"
  - "@autorest/modelerfour"
  - "@autorest/openapi-to-typespec"
  - "@azure-tools/extension"
  - "@azure-tools/oai2-to-oai3"
  - "autorest"
---

Remove dependencies that are no longer referenced by any source, script or config, and drop `@types` packages made redundant by bundled type definitions.
