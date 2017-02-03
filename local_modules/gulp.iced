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

global.versionsuffix = if argv["version-suffix"]? then "--version-suffix=#{argv["version-suffix"]}" else ""

global.version = argv.version or cat "#{basefolder}/VERSION"
global.configuration = argv.configuration or "debug"
global.force = argv.force or false

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

global['task'] = (name, description, deps, fn) ->
  throw "Invalid task name " if typeof name isnt 'string' 
  throw "Invalid task description #{name} " if typeof description isnt 'string' 

  if typeof deps == 'function'
    fn = deps
    deps = []

  # chain the task if it's a repeat
  if name of gulp.tasks
    prev = gulp.tasks[name]
    while prev.name of gulp.tasks
      prev.name = 'before:(' + prev.name + ')'
    deps.unshift prev.name
    gulp.tasks[prev.name] = prev
  
  # add the new task.
  gulp.task name, deps, fn
  
  # set the description
  gulp.tasks[name].description = description

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

global['flattenEncode'] = (path) ->
  path.basename = "#{ path.dirname.replace(/[\/\\]/g, '_') }_#{path.basename}" 
  path.dirname = ""

global['flattenDecode'] = (path) ->
  f = path.basename.match(/^(.*)_(.*)$/ )
  path.basename = "#{f[1].replace(/[_]/g, '/') }/#{f[2]}"
  path.dirname = ""

global['guid'] = ->
  x = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
  "#{x()}#{x()}-#{x()}-#{x()}-#{x()}-#{x()}#{x()}#{x()}"

global['codesign'] = (description, keywords, input, output, certificate1, certificate2, done)-> 
  done = if done? then done else if certificate2? then certificate2 else if certificate1? then certificate1 else ()->
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


###############################################
# Common Tasks

###############################################
task 'clean-packages', 'cleans out the contents of the packages folder', ->  
  rm '-rf', packages
  mkdir packages 

###############################################
task 'clean','calls dotnet-clean on the solution', ['clean-packages'], -> 
  exec "dotnet clean #{solution} /nologo"


###############################################
task 'build','builds the project',['restore'], (done) ->
  exec "dotnet build -c #{configuration} #{solution} /nologo /m:1", (code, stdout, stderr) ->
    if code 
      throw error "Build Failed #{ stderr }"
    echo "done build"
    done();

###############################################
task 'policheck-assemblies','', -> 
  source 'src/**/*.dll'
    .pipe except /install|testapp|tests/ig 
    .pipe policheck()

###############################################
task 'sign-packages','' ,(done) ->
  return done() # if configuration isnt "release"

###############################################  
task 'publish-packages','Publishes the packages to the NuGet Repository', (done) ->
  return done() if configuration isnt "release"
  source "#{packages}/*.nupkg"
    .pipe publishPackages()

############################################### 
task 'sign-assemblies','', (done) -> 
  # skip signing if we're not doing a release build
  return done() if configuration isnt "release"
  
  workdir = "#{process.env.tmp}/gulp/#{guid()}"
  echo warning workdir
  mkdir workdir 

  unsigned  = "#{workdir}/unsigned"
  mkdir unsigned 
  echo warning unsigned

  signed  = "#{workdir}/signed"
  mkdir signed
  echo warning signed

  assemblies() 
    # rename the files to flatten folder names out of the way.
    .pipe rename (path) -> 
      flattenEncode path
    
    # copy the files to the destination before signing 
    .pipe destination(unsigned)

    .on 'end', () =>
      # after the files are in the folder, we can call the signing utility
      codesign "Microsoft Azure SDK (Perks)",
        "Microsoft Azure .NET SDK"
        unsigned,
        signed,
        () ->
          # after signing, files are in the signed directory
          source "#{signed}/*"
            .pipe rename (path) -> 
              flattenDecode path 
            .pipe destination "#{__dirname}/src"            
            .on 'end', () => 
              # cleanup!
              echo warning workdir
              rm '-rf', workdir
              done()
    
    return;

############################################### 
task 'restore','restores the dotnet packages for the projects', -> 
  projects()
    .pipe where (each) ->  # check for project.assets.json files are up to date  
      return true if force
      assets = "#{folder each.path}/obj/project.assets.json"
      return false if (exists assets) and (newer assets, each.path)
      return true
    .pipe dotnet "restore"

############################################### 
task 'pack', '', ['clean-packages'] , ->
  # package the projects
  pkgs()
    .pipe dotnet "pack -c #{configuration} --no-build --output #{packages} #{versionsuffix}"

############################################### 
task 'package','From scratch build, sign, and package ', (done) -> 
  run 'clean',
    'restore'
    'build'
    'sign-assemblies'
    'pack' 
    'sign-packages'
    -> done()

############################################### 
task 'test', 'runs dotnet tests',['restore'] , (done) ->
  tests()
    .pipe dotnet "test"

############################################### 
task 'increment-version', 'increments the version and updates the project files', ->
  newversion = version.split '.'
  newversion[newversion.length-1]++
  newversion = newversion.join '.' 
  global.version = newversion
  run 'set-version'

############################################### 
task 'set-version', 'updates version in the the project files', ->
  # write the version number to the version file
  version .to "#{global.basefolder}/VERSION"
  
  # update src/common/common.proj
  packageinfo = cat "#{basefolder}/src/common/common.proj"
  packageinfo = packageinfo.replace /.VersionPrefix.*..VersionPrefix./,"<VersionPrefix>#{version}</VersionPrefix>" 
  packageinfo .to "#{basefolder}/src/common/common.proj"

  # we have to clean, because version references between projects have changed.
  run 'clean'

###############################################
task 'default','', ->
  cmds = ""

  for name, t of gulp.tasks 
    cmds += "\n  gulp **#{name}** - #{t.description}" if t.description? and t.description.length
  switches = ""

  echo marked  """
# Usage
# =======

## gulp commands  
#{cmds}

## available switches  
  *--force*          specify when you want to force an action (restore, etc)
  *--configuration*  'debug' or 'release'
#{switches}
"""