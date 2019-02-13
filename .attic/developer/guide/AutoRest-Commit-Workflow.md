## Overview

In order to make AutoRest development a bit less cumbersome, we're splitting
out the individual Client Runtime code into seperate repositories.

Since each language has individual needs and workflows when it comes to handling
their client runtime, each language has some flexibility on how they would like
to manage it, but it really boils down to one of a couple scenarios:

- Put the client runtimes into a repository seperate from everything else
- Put the client runtimes in the same repository as the rest of their
  generated SDKs

## Workflow Priorities

The top priority is to ensure that `AutoRest/master` is kept in a **shippable** state.
This means:

- code builds cleanly
- tests run on all platforms and languages without failure
- nightly builds are usable for any language that is checked in ( this includes
  the ability for someone to use the generated code with a publicly published
  client runtime packages. )

It turns out that in the past, the client runtime packages have not always been
published prior to generator code that produced code that required the newer
packages. This has inadvertently left the nightly build in an non-consumable
state for some languages.

## Keeping `AutoRest/master` shippable

Simply stated, to keep `AutoRest/master` in a shippable state, any generator changes
that produce code that will require newer client runtime, the runtime packages must
be published before commiting that code to `AutoRest/master`.

AutoRest CI builds on the `master` branch will be changed to not pull the client
runtime libraries from source control, but instead will pull public packages from
the appropriate package repository.

## When updates to client runtimes are required, but code needs to be checked in

Lanaguge teams that need to commit code into the `AutoRest` repository but are not
prepared to publish a new client runtime package, can check into a temporary branch
specific for their language, and we can configure the CI build for branches other
than `master` to pull client runtime code from a git repository, and use that.

ie, branches simply named like  `AutoRest\Ruby` or `AutoRest\Node`, etc.

This may require a bit more configuration in build scripts, but it will ensure that
when code is built and tested in CI that the master branch doesn't rely on client
runtimes that are not published and available to customers.

Ideally, these branches should not be expected to be long-lived -- once a the updated
client runtime package is published, the code from the branch can be merged back
into `AutoRest\master` and the branch deleted.

And, as long as the code is properly code-reviewed in the language branch, it can
be merged into `master` without an additional code-review. This should ensure that
the overhead of the seperate branch is kept to an absolute minimum.


