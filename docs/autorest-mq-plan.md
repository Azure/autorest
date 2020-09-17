# AutoRest MQ Improvements

This document lays out a plan for improvements to be made to AutoRest v3 in the
MQ 2020 milestone.  The overall goal is to **make AutoRest faster, more robust,
more well documented, and easier to maintain.**

## 1. Consolidate Core AutoRest Components into `Azure/autorest`

AutoRest v3 is comprised of a variety of `npm` packages that provide different
aspects of its behavior.  Currently these `npm` packages are spread out across 3
different repositories:

- https://github.com/Azure/autorest
- https://github.com/Azure/perks
- https://github.com/Azure/autorest.modelerfour

The aim is to consolidate the following frequently-updated AutoRest components
into the main `Azure/autorest` repository:

- `autorest` (in `Azure/autorest`) - the CLI interface
- `@autorest/core` (in `Azure/autorest`) - AutoRest v3 Core
- `@autorest/modelerfour` (in `Azure/autorest.modelerfour`) - The 4th-generation modeler for v3
- `@autorest/codemodel` (in `Azure/perks`) - The code model definition used by `@autorest/modelerfour`
- `@azure-tools/oai2-to-oai3` (in `Azure/perks`) - The Swagger to OpenAPI v3 converter

There are other AutoRest packages from `Azure/perks` that *could* be moved but
are less frequently updated and could be postponed until later:

- `@azure-tools/autorest-extension-base` - Provides a starting point for TypeScript-based extensions and generators
- `@azure-tools/codegen` - Utility code for AutoRest, used by AutoRest Core and Modelerfour
- `@azure-tools/datastore` - Virtual filesystem and JSON reference resolver, used by AutoRest Core
- `@azure-tools/deduplication` - Deduplication algorithm for OpenAPI 3 documents, used by AutoRest Core
- `@azure-tools/extension` - Handles installation and loading of AutoRest extensions, used by AutoRest CLI and Core

We'll use some of the CI and monorepo patterns from the `Azure/azure-sdk-for-js`
repository and apply them to the `Azure/autorest` repository so that we can
independently build, test, and release the individual packages in a reliable
way.  This also implies that we will follow Azure SDK repository organization
best practices where appropriate so that ramp-up is easier for those familiar
with other Azure SDK repositories.

The following benefits will be derived from making this change:

- One repository for AutoRest generator authors and partners to file issues
- One repository to clone for making improvements to the AutoRest v3 pipeline
- Much easier to make cross-cutting changes to AutoRest libraries (we sometimes make PRs to 2-3 repos for a single improvement or fix)
- Enables consistent and improved build and release automation for core packages

**GOAL:** All critical AutoRest packages have been centralized into the main
monorepo and release automation has been updated to accomodate them.  We are
also able to produce PR test packages for `@autorest/core` and
`@autorest/modelerfour` as we've been doing in the `Azure/autorest.modelerfour`
repo.

## 2. Improve AutoRest Performance via Profiling

One important area of improvement for AutoRest v3 is runtime performance.
AutoRest can complete end-to-end processing and generation of simple Swagger
specs in a short amount of time, but larger specs with multiple input files
across different API versions can result in long runtimes (multiple minutes).

One fairly reliable way to find low-hanging fruit for performance improvements
would be to use the Chrome Developer Tools to profile execution of the different
phases of AutoRest's pipeline to find obvious hot spots.  We could identify 3-5
obvious performance issues and attempt to fix them in this timeframe.

Because some performance improvements might require large changes or
refactorings, we'll have to focus on improvements that have the highest possible
benefit with the lowest likelihood of introducing regressions.

**GOAL:** Achieve a 20% reduction in runtime for generating the ARM Network
specs.

## 3. Document AutoRest v3 Architecture

Currently the AutoRest repository contains documentation for how to use AutoRest
to generate code from Swagger and OpenAPI 3 specs, but there is sparse
documentation on how AutoRest v3 works.  Some other important advanced concepts,
like transforms, aren't covered at all.

Here is a list of areas where improved documentation is needed:

- How the AutoRest v3 pipeline works
- Transforms and directives: how they work and how to write them
- Expand on AutoRest extension authoring documentation to cover more possibilities (TypeScript extension, config-only extension)
- Reorganize existing documentation for effectiveness and fix broken links
- Put together an initial FAQ that cross-references full documentation pages

**GOAL:** Produce a more coherent documentation section that explains the
important aspects of AutoRest v3 and links to individual pages (existing or new)
to provide detailed information.  Ensure that the most critical partner-facing
elements of AutoRest v3 are documented well enough to reduce support burden on
the core AutoRest team.

## 4. Improve Error Messages

There are a lot of places where AutoRest can display errors or warnings to users
during its operation.  Many of these errors prevent code generation from
completing successfully without giving the necessary information to help the
user resolve the issue.

Here are some areas where errors can be improved:

- Extension installation failure (for example, when Python extension fails to complete installation)
- Modelerfour errors

To identify the least helpful error messages, we can start by gathering feedback
from our own code generator teams and partners (ARM, PowerShell generator folks)
and then find others by looking at the issue backlogs for AutoRest and
Modelerfour.  The aim would be to identify at least 3-5 error messages in need
of improvement.

**GOAL:** Improve 3-5 of the most commonly encountered error messages which have
been identified as unhelpful.
