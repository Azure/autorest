# AutoRest 

This is the autorest cmdline tool.

## Installation 

``` bash
# Install autorest globally
npm install -g autorest 

```

## Usage 

The `autorest` cmdline supports triple-dash options to control the installation of the dependent tools.
The code generation command line can be printed with `--help`

## __Output Verbosity__
`--verbose`            
  - show verbose output information

`--debug`              
  - show internal debug information

`--quiet`              
  - suppress output

## __Versions__
  `--list-installed`     
  - show all installed versions of AutoRest tools

  `--list-available=`__`nn`__  
  - lists the last nn releases available from github (defaults to 10)

## __Installation__
  `--version=`__`version`__    
  - uses __`version`__ of AutoRest, installing if necessary. 
  You can use a version label (see `--list-available`) or
    - `latest`         - get latest nightly build
    - `latest-release` - get latest release version

  `--reset`              
   - remove all installed versions of AutoRest toolsand install the latest (override with `--version`)

## Examples 


``` bash
# install latest autorest 
autorest --version=latest

# remove all installed versions of autorest
autorest --reset 

# install a specific nightly build 
autorest --version=1.0.1-20170222-2300-nightly

# generate c# client library for swagger.json
autorest --version=latest -input swagger.json 

```