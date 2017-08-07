# AutoRest and ClientRuntimes
Individual clientruntimes were previously housed under src/client directory of the AutoRest repo. 
They were then referenced locally by other AutoRest projects (the generators). clientruntimes are now moved to their own repos.
Published packages from these repos are then referenced by dependent projects under AutoRest.

The new workflow for making changes to clientruntimes now involves the following:
- Make changes to the clientruntime from its own repo 
- Test these changes by locally publishing and consuming the packages under AutoRest, ensure the build and tests under AutoRest work as expected 
- Merge changes to clientruntime repo and publish corresponding packages to their public feeds
- Modify clientruntime references under AutoRest to refer to the published packages, ensure the CI builds pass successfully for the PRs and merge the changes

```
Please note that the clientruntime references under AutoRest are now set to specific versions rather than a range. 
This is to ensure latest packages do not affect the AutoRest nightly builds without proper testing.
```



Following is a list of the clientruntime libraries referenced under AutoRest :

1. **C#** [located here](https://github.com/Azure/azure-sdk-for-net/tree/AutoRest/src/ClientRuntime)
    and referenced via [nuget feeds](https://www.nuget.org/packages/Microsoft.Rest.ClientRuntime/)

2. **Node** [located here](https://github.com/Azure/azure-sdk-for-node/tree/master/runtime) and referenced via [npm feeds](https://www.npmjs.com/package/ms-rest)

4. **Ruby** [located here](https://github.com/Azure/azure-sdk-for-ruby/tree/master/runtime) and referenced via [pypi feeds](https://pypi.python.org/pypi/msrest)

3. **Java** clientruntime is currently unavailable as a package and hence needs to be built locally before being referenced by AutoRest. The code for Java clientruntime is located in [this repo](https://github.com/Azure/autorest-clientruntime-for-java).
    During the AutoRest build this gets cloned and built before being referenced
