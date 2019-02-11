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
[13:55:18] Finished 'clean/typescript' after 813 ms
[13:55:21] Starting 'clean'...
[13:55:21] Finished 'clean' after 19 μs
```

## Common `gulp` commands

### Build the whole project (c# and typescript bits)
`gulp build` - compiles the typescript projects.

### Clean out build artifacts from the project
`gulp clean` - cleans the build artifacts

### Shortcut to launch Visual Studio Code at the project root.
`gulp code` - launches vscode

### Fix up line endings for some files
`gulp fix-line-endings` - ensures that .ts files are LF not CRLF. Will be expanded in the future.

### Restore npm packages for Typescript projects
`gulp npm-install` - restores packages for the typescript projects

### Build autorest and install it in the user's home folder (`~/.autorest/plugins/autorest/<VERSION>-<DATE>-<TIME>-private`) as a private build so you can run it with the `autorest` command anywhere.
`gulp install` - build and install the dev version of autorest

### Run AutoRest without installing it
`gulp autorest` - runs AutoRest binary directly. You can pass regular command line parameters to it. Note: `gulp` may interpret arguments coming after `autorest` as further `gulp` tasks. To prevent this, pass `--foo` or similar as a first argument to `gulp autorest`.

### Testing 
`gulp regenerate` - regenerate all expected code for tests

`gulp test` - runs all tests<br>

## available switches

`--force`          specify when you want to force an action (update dependencies, etc)<br>
`--verbose`        enable verbose output<br>
`--threshold=nn`   set parallelism threshold - default = (# of cpus in system-1)<br>
