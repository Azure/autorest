
# use our tweaked version of gulp with iced coffee.
require './common.iced'
semver = require 'semver'

# tasks required for this build 
Tasks  "regeneration" # regenerating expected files
 

# Settings
Import
  initialized: false
  packages: "#{basefolder}/packages"
  autorest: (args,done,ignoreexitcode) ->
    # Run AutoRest from the original current directory.
    echo info "Queuing up: AutoRest #{args.join(' ')}"
    args = args.concat("--clear-output-folder", "--version=#{basefolder}/src/autorest-core") if args[0] != "--reset"
    execute "node #{basefolder}/src/autorest/dist/app.js #{args.map((a) -> "\"#{a}\"").join(' ')} --no-upgrade-check --version=#{basefolder}/src/autorest-core" , {silent:true, ignoreexitcode: ignoreexitcode || false}, (code,stdout,stderr) -> 
      return done(code,stdout,stderr)
  
  typescriptProjectFolders: ()->
    source ["src/autorest-core", "src/autorest" ]

  npminstalls: ()->
    source ["src/autorest-core", "src/autorest" ]

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
  done()

# CI job
task 'testci', "more", [], (done) ->
  ## TEST SUITE
  global.verbose = true
  await run "test", defer _

  ## CLEAN
  await autorest ["--reset","--allow-no-input"], defer code,stdout,stderr

  ## REGRESSION TEST
  global.verbose = false
  # regenerate
  await run "regenerate", defer _
  # diff ('add' first so 'diff' includes untracked files)
  await  execute "git add -A", defer code, stderr, stdout
  await  execute "git diff --staged -w", defer code, stderr, stdout
  # eval
  echo stderr
  echo stdout
  throw "Potentially unnoticed regression (see diff above)! Run `gulp regenerate`, then review and commit the changes." if stdout.length + stderr.length > 0
  done()

