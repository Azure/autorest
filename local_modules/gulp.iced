require 'shelljs/global'
gulp = require('gulp')
fs = require('fs')

global['marked'] = require('marked')
TerminalRenderer = require('marked-terminal')

# make things global for simplicity.
global['filter'] = require('gulp-filter')
global['util'] = require 'util'
global['gulp'] = gulp
global['dotnet'] = require './dotnet.iced'
global['signBinaries'] = require './sign-binaries.iced'
global['signPackages'] = require './sign-nupkgs.iced'
global['policheck'] = require './policheck.iced'
global['publishPackages'] = require './publish-nupkgs.iced'

global['except'] = require './except.iced'
global['chalk'] = require 'chalk'
global['run'] = require 'run-sequence'
global['zip'] = require 'gulp-zip'
global['unzip'] = require 'gulp-unzip'
global['through'] = require 'through2'
global['argv'] = require('yargs').argv
global['rename'] = require('gulp-rename')

# tools
csu = "c:/ci-signing/adxsdk/tools/csu/csu.exe"

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

# lets us just handle each item in a stream easily.
global['foreach'] = (delegate) -> 
  through.obj ( each, enc, done ) -> 
    delegate each, done

global['toArray'] = (result,passthru) => 
  foreach (each,done) => 
    result.push(each)
    if passthru 
      done null, each
    else
      done null

global['showFiles'] = () ->
 foreach (each,done) ->
   echo info each.path
   done null, each


global['source'] = (globs, options ) -> 
  gulp.src( globs, options) 

global['destination'] = (globs, options ) -> 
  gulp.dest( globs, options) 

global['task'] = (name, deps, fn) ->
  if typeof deps == 'function'
    fn = deps
    deps = []
  if name of gulp.tasks
    prev = gulp.tasks[name]
    while prev.name of gulp.tasks
      prev.name = 'before:(' + prev.name + ')'
    deps.unshift prev.name
    gulp.tasks[prev.name] = prev
  gulp.task name, deps, fn
  return

set '+e'

global['error'] = chalk.bold.red 
global['warning'] = chalk.bold.yellow
global['info'] = chalk.bold.green

# global['exec'] = 
# project.assets.json

global['where'] = (predicate) -> 
  foreach (each,done) ->
   return done null, each if predicate each 
   done null

global['splitPath'] = (path) ->
  s = path.match /^(.+)[\\\/]([^\/]+)$/  or [path, '',path]
  f = s[2].match(/^(.*)([\\.].*)$/ ) or [s[2],s[2],'']
  d = path.match /^(.:)[\\\/]?(.*)$/ or ['',path]
  return {
    fullname : path
    folder : s[1]
    filename : s[2]
    basename : f[1]
    extension : f[2]
    drive:  d[1]
    folders: d[2].split /[\\\/]/
  }

global['folder'] = (path) ->
  return '' if not path 
  return (splitPath path).folder

global['split'] = (path) ->
  return '' if not path 
  return (splitPath path).folders

global['filename'] = (path) ->
  return '' if not path 
  p = splitPath path
  return p.filename

global['extension'] = (path) ->
  return '' if not path 
  p = splitPath path
  return p.extension

global['basename'] = (path) ->
  return '' if not path 
  p = splitPath path
  return p.basename

global['exists'] = (path) ->
  return test '-f', path 

global['newer'] = (first,second) ->

  f = fs.statSync(first).mtime
  s = fs.statSync(second).mtime
  
  return f > s 

global['guid'] = ->
  x = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
  "#{x()}#{x()}-#{x()}-#{x()}-#{x()}-#{x()}#{x()}#{x()}"

global['codesign'] = (description, keywords, input, output, certificate1, certificate2, done)-> 
  done = if not done? then done else if not certificate2? then certificate2 else if not certificate1? then certificate1 else ()->
  certificate1 = if typeof certificate1 is 'number' then certificate1 else 72
  certificate2 = if typeof certificate2 is 'number' then certificate2 else 401

  throw "Description Required" if not description?
  throw "Keywords Required" if not keywords?
  throw "Input Required (folder)" if not input?
  throw "Output Required (folder)" if  not output?

  echo "#{csu} 
    /c1=#{certificate1}
    /c2=#{certificate2}
    \"/d=#{description}\"
    \"/kw=#{keywords}\"
    \"/i=#{input}\"
    \"/o=#{output}\"
    \"/clean=False\"
  "

  exec "#{csu} 
    /c1=#{certificate1}
    /c2=#{certificate2}
    \"/d=#{description}\"
    \"/kw=#{keywords}\"
    \"/i=#{input}\"
    \"/o=#{output}\"
    \"/clean=False\"
  " , (code, stdout, stderr) ->
    if code 
      throw error "Code Signing Failed."
    echo "done codesigning"
    done();

  