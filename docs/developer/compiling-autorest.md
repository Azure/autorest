# <img align="center" src="../images/logo.png"> Compiling AutoRest

## Requirements 
Ensure that you've [setup your developer environment](./workstation.md)

## Check out the code 

``` powershell

# clone the repository
git clone https://github.com/azure/autorest 

# install node modules
cd autorest
npm install
```

## Using `gulp` 
The AutoRest build system has standardized on `gulp` for the following reasons:
  - it works very well cross-platform
  - excellent support for parallelism
  - using `IcedCoffeeScript` + `ShellJS` keeps the scripts very readable.

The main `gulpfile` is the file in the root of the folder called `gulpfile.iced`. You'll also find support modules for that in the `./src/gulp_modules` folder (see the `.iced` files there)

You can get a quick list of the available gulp commands by running `gulp` without arguments:

``` powershell
# list what gulp commands are available
gulp
```

#### Note: When merging from upstream
If you pull new code, and the `package.json` file has been updated, you will see a warning when you call `gulp`:

```
[13:50:53] Requiring external module iced-coffee-script/register

WARNING: package.json is newer than 'node_modules' - you might want to do an 'npm install'

[13:50:54] Using gulpfile C:\work\github\autorest\gulpfile.iced
```

#### Note: You can use gulp anywhere...

`gulp` is smart enough to find it's `gulpfile.iced` regardless where you are in the project hierarchy:

``` powershell
cd ./src/core/autorest
gulp clean

[13:55:16] Requiring external module iced-coffee-script/register
[13:55:16] Working directory changed to C:\work\github\autorest
[13:55:17] Using gulpfile C:\work\github\autorest\gulpfile.iced
[13:55:17] Starting 'clean/typescript'...
[13:55:17] Starting 'clean/dotnet'...
           C:\work\github\autorest :: dotnet clean C:\work\github\autorest/AutoRest.sln /nologo
[13:55:18] Finished 'clean/typescript' after 813 ms
[13:55:21] Finished 'clean/dotnet' after 3.95 s
[13:55:21] Starting 'clean'...
[13:55:21] Finished 'clean' after 19 μs
```

## Common `gulp` commands

### Build the whole project (c# and typescript bits)
`gulp build` - ensures that the dotnet-cli packages are restored, then compiles the typescript and c# projects in parallel.

### Clean out build artifacts from the project
`gulp clean` - cleans the build artifacts

### Shortcut to launch Visual Studio Code at the project root.
`gulp code` - launches vscode

### Fix up line endings for some files
`gulp fix-line-endings` - ensures that .ts files are LF not CRLF. Will be expanded in the future.

### Wiping the nuget package cache 
`gulp reset-dotnet-cache` - removes installed dotnet-packages so restore is from a perfectly clean state. WARNING: This will remove the files in `~/.nuget/*`

### Restore dotnet packages 
`gulp restore` - restores the dotnet packages for all the projects

### Restore npm packages for Typescript projects
`gulp npm-install` - restores packages for the typescript projects

### Build autorest and install it in the user's home folder (`~/.autorest/plugins/autorest/<VERSION>-<DATE>-<TIME>-private`) as a private build so you can run it with the `autorest` command anywhere.
`gulp install` - build and install the dev version of autorest

### Run AutoRest without installing it
`gulp autorest` - runs the autorest binary directly. You can pass regular command line parameters to it.
`gulp autorest-cli` - Runs AutoRest (via the `node` front-end. This will soon be the default.)

### Testing 
`gulp regenerate` - regenerate all expected code for tests (There are many fine-grained `regenerate-*` tasks, find them with `gulp -T` if you need them. )

`gulp test` - runs all tests<br>
`gulp test-dotnet` - runs dotnet tests<br>
`gulp test-go` - runs Go tests<br>
`gulp test-java` - runs Java tests<br>
`gulp test-node` - runs NodeJS tests<br>
`gulp test-python` - runs Python tests<br>
`gulp test-ruby` - runs Ruby tests<br>

## available switches

`--force`          specify when you want to force an action (restore, etc)<br>
`--configuration`  'debug' or 'release'<br>
`--release`        same as --configuration=release<br>
`--verbose`        enable verbose output<br>
`--threshold=nn`   set parallelism threshold - default = (# of cpus in system-1)<br>
