# Release Notes for the AutoRest PowerShell Beta [2/11/2019]

# Contents:

- [What's New](#New) in the PowerShell generator
- [Caveats](#upgrading) And known issues
- [Upgrading](#upgrading) the AutoRest PowerShell Generator

## New
- All runtime code is now generated in the same namespace as the project itself (no more `Carbon.Json` and `Microsoft.Rest.ClientRuntime` namespaces) -- this will make it so you can have multiple generated code sets in the same project if necessary. 
- runtime code is a marked lot more `internal` than it was; `public` is  only used where it must.
- `additionalProperties` in models should generate far better code that it was. (still one outstanding case where it's not good.)
-  you can use npm to install powershell cross platform: `npm install -g pwsh`, then you can just run `pwsh` !


# CAVEATS, AND KNOWN ISSUES:

- BE KIND! This is a first beta release of a really large amount of code! It was designed to handle APIs crafted for azure services (where we have pretty consistent standards). If it breaks, we'll see what we can do!

- support for streams may be broken.
- operations must have unique `operationId` values.
  <br>they should be in the form `Noun_Action` (not a powershell noun-verb, but something meaningful)
  <br>like 
  <br>&nbsp;&nbsp;`operationId: MyResource_Get` or 
  <br>&nbsp;&nbsp;`operationId: SomeAPI_List`
  <br>if there are tags, we try to guess something useful, but no guarantees.
- If something doesn't work, try to trim down the OpenAPI file to narrow down what it doesn't like, and post an issue back to https://github.com/azure/autorest with a clear example and tag it with the `powershell` label.
- Http testing/mocking support works, see example  however, it has primitive scrubbing, so be careful with storing API keys, etc.
- Documentation/Deep Knowledge is coming as soon as I can get around to it. 
- Feel Free to poke around, and help out!



## Upgrading 

If you've been using an earlier build of the `PowerShell` generator (or the earlier `Incubator` builds...), you want to make sure you're using nodejs LTS (v10.15) 

``` powershell
> node -v 

v10.15.0
```

After that, you can upgrade pretty easily:

``` powershell
    # Install the latest autorest beta
    > npm install -g autorest@beta 

    # remove old autorest extensions
    > autorest --reset 

    # nudge autorest into installing the latest version of the generator 
    > autorest --powershell --help
```
Which should show output like:

``` text 

AutoRest code generation utility [version: 3.0.5141; node: v10.15.0]
(C) 2018 Microsoft Corporation.
https://aka.ms/autorest
   Loading AutoRest core      'C:\Users\garretts\.autorest\@microsoft.azure_autorest-core@3.0.5336\node_modules\@microsoft.azure\autorest-core\dist' (3.0.5336)

C:\> autorest --powershell --help                                                                                                                                                                            AutoRest code generation utility [version: 3.0.5141; node: v10.15.0]
(C) 2018 Microsoft Corporation.

https://aka.ms/autorest
   Loading AutoRest core      'C:\Users\garretts\.autorest\@microsoft.azure_autorest-core@3.0.5336\node_modules\@microsoft.azure\autorest-core\dist' (3.0.5336)
   Installing AutoRest extension '@microsoft.azure/autorest.powershell' (beta)
   Installed AutoRest extension '@microsoft.azure/autorest.powershell' (beta->1.0.111)
   Installing AutoRest extension '@microsoft.azure/autorest.remodeler' (beta)
   Installed AutoRest extension '@microsoft.azure/autorest.remodeler' (beta->1.0.95)
   Installing AutoRest extension '@microsoft.azure/autorest.csharp-v2' (beta)
   Installed AutoRest extension '@microsoft.azure/autorest.csharp-v2' (beta->1.0.97)

... etc

``` powershell
    # verify the version you have
    > autorest --info 
```

Which should show output like:

``` text 
AutoRest code generation utility [version: 3.0.5141; node: v10.15.0]
(C) 2018 Microsoft Corporation.
https://aka.ms/autorest


Showing All Installed Extensions

 Type       Extension Name                           Version      Location
 core       @microsoft.azure/autorest-core           3.0.5336     C:\Users\garretts\.autorest\@microsoft.azure_autorest-core@3.0.5336
 extension  @microsoft.azure/autorest.csharp-v2      1.0.97       C:\Users\garretts\.autorest\@microsoft.azure_autorest.csharp-v2@1.0.97
 extension  @microsoft.azure/autorest.powershell     1.0.111      C:\Users\garretts\.autorest\@microsoft.azure_autorest.powershell@1.0.111
 extension  @microsoft.azure/autorest.remodeler      1.0.95       C:\Users\garretts\.autorest\@microsoft.azure_autorest.remodeler@1.0.95
```
