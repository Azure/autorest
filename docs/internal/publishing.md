# Autorest publishing

This is the instruction to publish a new autorest package.

## Track changes

Autorest pull request validation will check that changes are being documented using `rush change --verify`.
This means that if the pull request include some changes to any packages you will have to run `rush change` to interactively describe what the changes are and how they affect the package(Major, minor, patch).

## Release

If you want to release an update you will then have to run `rush publish -a`. This will take all pending change files created with `rush change`, update the changelog and bump the package(s) version.

Then in the Pull Request make sure to add the `Publish` label to tell the validation that this is meant to publish and it will ignore the change check above.
