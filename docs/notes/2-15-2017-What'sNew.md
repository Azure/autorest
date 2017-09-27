As we mentioned, we've migrated our build system to the latest dotnet-cli build tools. 

It took several weeks of effort to make this possible, and during this time we were constantly trying to keep in sync with the master branch. 

It is remotely possible there are some regressions or glitches, if you find something that isn’t right, ping @fearthecowboy or @olydis asap, and we can look into it.


The nuget nightly builds are no longer being built, and they won’t be coming back (although, the existing builds will remain in perpetuity)

Going forward, we’re going to be publishing a tool in npm and you’ll need nodejs (7.10.0 or later) to use AutoRest .

This drastically simplifies installation across the board, and we’re supporting AutoRest on Windows, MacOS and Linux (many flavors)

By Friday, 2/17/2017 - you will be able to install AutoRest via npm:

``` powershell 
# make sure you have node 7.10.0 or greater installed!
npm install -g AutoRest
```

After this, autorest will manage the installation of the required binaries on its own, and you can select which version you want at any time, and it will install missing bits on the fly.

Once you have the node package for autorest installed you can specify the version to use on the command line via the 

``` powershell

# the --version can be used to set the exact version
# or, use labels:
#  latest         - ensures the latest nightly build is installed and uses that.
#  latest-stable  - ensures the latest stable build is installed and uses that.

# The default would be to use the latest version currently installed. 
# or if it's not installed, grabbing the latest bits.

# examples:

# update to latest and run 
autorest --version=latest <...args>

# update to latest stable and run
autorest --version=latest-stable   <...args>

# use a specific version
autorest --version=1.0.1-nightly20170217  <...args>

# go with what's already installed
autorest <...args>

```

Soon, I'll publish more docs on how to manage what's installed. 
