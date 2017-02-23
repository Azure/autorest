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
Install 'vinyl'
Install 'os'
Install 'gulp'
Install 'util'
Install 'moment'
Install 'chalk'
Install 'yargs'
Install 'ghrelease', 'gulp-github-release'
Install 'eol', 'gulp-line-ending-corrector'
Install 'through', 'through2'
Install 'run', 'run-sequence'
Install 'except', './except.iced'

# do a bit of monkeypatching
_gulpStart = gulp.Gulp::start
_runTask = gulp.Gulp::_runTask

gulp.Gulp::start = (taskName) ->
  @currentStartTaskName = taskName
  _gulpStart.apply this, arguments
  return

gulp.Gulp::_runTask = (task) ->
  @currentRunTaskName = task.name
  _runTask.apply this, arguments
  return

#  echo 'this.currentStartTaskName: ' + this.currentStartTaskName
#  echo 'this.currentRunTaskName: ' + this.currentRunTaskName


# bring some gulp-Plugins along
Plugin 'filter',
  'zip'
  'unzip'
  'rename'

# force this into global namespace
global['argv'] = yargs.argv

Include './common'

configString = (s)->
  "#{s.charAt 0 .toUpperCase()}#{s.slice 1 .toLowerCase() }"


###############################################
# Global values
Import 
  versionsuffix: if argv["version-suffix"]? then "--version-suffix=#{argv["version-suffix"]}" else ""
  version: argv.version or cat "#{basefolder}/VERSION"
  configuration: configString( argv.configuration) if argv.configuration else (if argv.release then 'Release' else 'Debug')
  github_apikey: argv.github_apikey or process.env.GITHUB_APIKEY or null
  nuget_apikey: argv.nuget_apikey or process.env.NUGET_APIKEY or null
  myget_apikey: argv.myget_apikey or process.env.MYGET_APIKEY or null
  npm_apikey:  argv.npm_apikey or process.env.NPM_APIKEY or null
  today: moment().format('YYYYMMDD')
  now: moment().format('YYYYMMDD-HHmm')
  force: argv.force or false
  threshold: argv.threshold or ((os.cpus().length)-1 )
  verbose: argv.verbose or null
  tmpfolder: process.env.tmp || "#{basefolder}/tmp"
  workdir: "#{global.tmpfolder}/gulp/#{guid()}"

mkdir "#{tmpfolder}/gulp" if !test "-d", "#{tmpfolder}/gulp"
mkdir "-p", workdir if !test "-d", workdir

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
  error_message: chalk.bold.cyan
  warning: chalk.bold.yellow
  info: chalk.bold.green
  quiet_info: chalk.green

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
  *--release*        same as --configuration=release
  *--nightly*        generate label for package as 'YYYYMMDD-0000-nightly'
  *--preview*        generate label for package as 'YYYYMMDD-HHmm-preview'
  *--verbose*        enable verbose output
  *--threshold=nn*   set parallelism threshold (default = 10)

#{switches}
"""

task 'fix-line-endings', 'Fixes line endings to file-type appropriate values.', ->
  source "**/*.iced"
    .pipe eol {eolc: 'LF', encoding:'utf8'}
    .pipe destination '.'
