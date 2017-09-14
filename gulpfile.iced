# set the base folder of this project
global.basefolder = "#{__dirname}"

# use our tweaked version of gulp with iced coffee.
require './.gulp/gulp.iced'
semver = require 'semver'

# tasks required for this build 
Tasks "typescript",  # compiling typescript
  "regeneration" # regenerating expected files
  "publishing"   # signing/publishing binaries to github and npm registry

# Settings
Import
  initialized: false
  packages: "#{basefolder}/packages"
  release_name: if argv.nightly then "#{version}-#{today}-2300-nightly"              else if argv.preview then "#{version}-#{now}-preview"              else "#{version}"
  package_name: if argv.nightly then "autorest-#{version}-#{today}-2300-nightly.zip" else if argv.preview then "autorest-#{version}-#{now}-preview.zip" else "autorest-#{version}.zip"
  autorest: (args,done,ignoreexitcode) ->
    # Run AutoRest from the original current directory.
    echo info "Queuing up: AutoRest #{args.join(' ')}"
    execute "node #{basefolder}/src/autorest/dist/app.js #{args.map((a) -> "\"#{a}\"").join(' ')} --clear-output-folder  \"--version=#{basefolder}/src/autorest-core\" " , {silent:true, ignoreexitcode: ignoreexitcode || false}, (code,stdout,stderr) ->
      return done(code,stdout,stderr)
  
  typescriptProjectFolders: ()->
    source ["src/autorest-core", "src/autorest" ]

  npminstalls: ()->
    source ["src/autorest-core", 
      "src/autorest"
    ]

  typescriptProjects: () -> 
    typescriptProjectFolders()
      .pipe foreach (each,next,more)=>
        source "#{each.path}/tsconfig.json"
          .on 'end', -> 
            next null
          .pipe foreach (e,n)->
            more.push e
            n null

  generatedFiles: () -> 
    typescriptProjectFolders()
      .pipe foreach (each,next,more)=>
        source(["#{each.path}/**/*.js","#{each.path}/**/*.d.ts" ,"#{each.path}/**/*.js.map", "!**/node_modules/**","!**/*min.js"])
          .on 'end', -> 
            next null
          .pipe foreach (e,n)->
            more.push e
            n null
        
  typescriptFiles: () -> 
    typescriptProjectFolders()
      .pipe foreach (each,next,more)=>
        source(["#{each.path}/**/*.ts", "#{each.path}/**/*.json", "!#{each.path}/node_modules/**"])
          .on 'end', -> 
            next null
          .pipe foreach (e,n)->
            e.base = each.base
            more.push e
            n null

  Dependencies:
    "autorest" : ['autorest-core']

task 'install/binaries', '', (done)->
  done()

task 'install/bootstrapper', 'Build and install the bootstrapper into the global node.js', (done) ->
  run [ 'build/typescript' ],
    ->
      execute "npm version patch", {cwd:"#{basefolder}/src/autorest"}, (c,o,e) -> 
        execute "npm install -g .", {cwd:"#{basefolder}/src/autorest"}, (c,o,e) -> 
          done()

task 'install', 'build and install the dev version of autorest',(done)->
  run [ 'build/typescript' ],
    'install/binaries',
    -> done()

task 'nuke' , '' , (done)->
  # remove the copied dts files
  rm "#{basefolder}/package-lock.json"
  rmdir  "#{basefolder}/src/autorest/lib/core", ->
    rmdir "#{basefolder}/node_modules", done

task 'init-deps', '', (done) ->
  done()

task 'autorest', 'Runs AutoRest', (done)-> 
  node = process.argv.shift()
  main = process.argv.shift()
  main = "#{basefolder}/src/autorest/dist/app"
  while( arg = process.argv.shift() ) 
    break if arg == 'autorest'

  process.argv.unshift "--version=#{basefolder}/src/autorest-core"
  process.argv.unshift main
  process.argv.unshift node
  cd process.env.INIT_CWD 
  echo process.argv
  require main

task 'init', "" ,(done)->
  Fail "YOU MUST HAVE NODEJS VERSION GREATER THAN 7.10.0" if semver.lt( process.versions.node , "7.10.0" )

  # we no longer need this symlinked in place. remove it if it is there.
  unlink "#{basefolder}/src/core/AutoRest/bin/netcoreapp1.0/node_modules/autorest-core" if  test "-d",  "#{basefolder}/src/core/AutoRest/bin/netcoreapp1.0/node_modules/autorest-core"

  if (! test "-d","#{basefolder}/src/autorest-core") 
    echo warning "\n#{ error 'NOTE:' } #{ info 'src/autorest-core'} appears to be missing \n      fixing with #{ info 'git checkout src/autorest-core'}"
    echo warning "      in the future do a #{ info 'gulp clean'} before using #{ info 'git clean'} .\n"
    exec "git checkout #{basefolder}/src/autorest-core"

  return done() if initialized
  global.initialized = true
  # if the node_modules isn't created, do it.
  if fileExists "#{basefolder}/package-lock.json" 
    doit = true if (newer "#{basefolder}/package.json",  "#{basefolder}/package-lock.json") 
  else 
    doit = true if (newer "#{basefolder}/package.json",  "#{basefolder}/node_modules") 
      
  typescriptProjectFolders()
    .on 'end', -> 
      if doit || force
        rm "#{basefolder}/package-lock.json" if fileExists "#{basefolder}/package-lock.json" 
        echo warning "\n#{ info 'NOTE:' } 'node_modules' may be out of date - running 'npm install' for you.\n"
        echo "Running npm install for all project folders."
        exec "npm install", {cwd:basefolder,silent:true},(c,o,e)->
          echo "Completed Running npm install for project folder."
          done null
      else 
        done null

    .pipe foreach (each,next) -> 
      # is any of the TS projects node_modules out of date?
      if (! test "-d", "#{each.path}/node_modules") or (newer "#{each.path}/package.json",  "#{each.path}/package-lock.json")
        echo warning "#{ info 'NOTE:' } '#{each.path}/node_modules' may be out of date."
        doit = true
      next null

    return null
  return null
