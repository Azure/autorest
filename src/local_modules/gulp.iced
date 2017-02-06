# place an object into global namespace 
global['Import'] = (object) -> 
  for key, value of object
    global[key] = value 

Import
  # require into the global namespace (modulename = module)
  Install: (modulename, module) -> 
    global[modulename] = require module or modulename 

  # require a gulp-Plugin into the global namespace 
  Plugin: () ->
    Install module,"gulp-#{module}" for module in arguments

  # require a module, placing exports into global namespace
  Include: () -> 
    Import require module  for module in arguments

  Tasks: () -> 
    require "#{__dirname}/#{module}" for module in arguments

###############################################
# force-global a bunch of stuff.
require 'shelljs/global'
Install 'marked'
Install 'gulp'
Install 'util'
Install 'chalk'
Install 'yargs'
Install 'through', 'through2'
Install 'run', 'run-sequence'
Install 'except', './except.iced'

# bring some gulp-Plugins along
Plugin 'filter',
  'zip'
  'unzip'
  'rename'

# force this into global namespace
global['argv'] = yargs.argv

# global['dotnet'] = require './dotnet.iced'
# global['signBinaries'] = require './sign-binaries.iced'
# global['signPackages'] = require './sign-nupkgs.iced'
# global['policheck'] = require './policheck.iced'
# global['publishPackages'] = require './publish-nupkgs.iced'

Include './common'

###############################################
# Global values
Import 
  versionsuffix: if argv["version-suffix"]? then "--version-suffix=#{argv["version-suffix"]}" else ""
  version: argv.version or cat "#{basefolder}/VERSION"
  configuration: argv.configuration or "debug"
  force: argv.force or false

###############################################
# UI stuff
TerminalRenderer = require('marked-terminal')
marked.setOptions {
  renderer: new TerminalRenderer({
    heading: chalk.green.bold,
    firstHeading: chalk.green.bold,
    showSectionPrefix: false,
    strong: chalk.bold.cyan,
    em: chalk.cyan,
    blockquote: chalk.magenta,
    tab: 2
  })
}

set '+e'

Import 
  error: chalk.bold.red
  warning: chalk.bold.yellow
  info: chalk.bold.green

###############################################
task 'default','', ->
  cmds = ""

  for name, t of gulp.tasks 
    cmds += "\n  gulp **#{name}** - #{t.description}" if t.description? and t.description.length
  switches = ""

  echo marked  """

# Usage

## gulp commands  
#{cmds}

## available switches  
  *--force*          specify when you want to force an action (restore, etc)
  *--configuration*  'debug' or 'release'
#{switches}
"""