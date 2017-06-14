task 'copy-dts-files', '', (done)->
  # this needs to run multiple times.
  global.completed['copy-dts-files'] = false
  
  # copy *.d.ts files 
  source ["#{basefolder}/src/autorest-core/dist/**/*.d.ts","!#{basefolder}/src/autorest-core/dist/test/**" ]
    .pipe destination "#{basefolder}/src/autorest/lib/core"



# build task for tsc 
task 'pre-build', 'typescript', (done)-> 
  # symlink the build into the target folder for the binaries.
  if ! test '-d',"#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules"
    mkdir "-p", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules"

  if ! test '-d', "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules/autorest-core"
    fs.symlinkSync "#{basefolder}/src/autorest-core", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules/autorest-core",'junction' 

  # Compile the core
  execute "#{basefolder}/node_modules/.bin/tsc --project #{basefolder}/src/autorest-core", (c,o,e)-> 
    # after this is compiled, then we can compile the other one.
    run "copy-dts-files", ->
      execute "#{basefolder}/node_modules/.bin/tsc --project #{basefolder}/src/autorest", (cc,oo,ee)-> 
        # after this is compiled we can go into watch mode if we are told to.
        if watch 
          watchFiles ["#{basefolder}/src/autorest-core/**/*.d.ts"], ["copy-dts-files"]

          execute "#{basefolder}/node_modules/.bin/tsc --watch --project #{basefolder}/src/autorest-core", (c,o,e)-> 
            #nothing
            echo "hi"
          , (d) -> echo d.replace(/^src\//mig, "#{basefolder}/src/")
          execute "#{basefolder}/node_modules/.bin/tsc --watch --project #{basefolder}/src/autorest", (c,o,e)->  
            #nothing
            echo "there"
          , (d) -> echo d.replace(/^src\//mig, "#{basefolder}/src/")
        
        done();
      , (d) ->  # fix filenames for vscode consumption
        echo d.replace(/^src\//mig, "#{basefolder}/src/")    

  , (data) -> # fix filenames for vscode consumption
    echo data.replace(/^src\//mig, "#{basefolder}/src/")

  return null

task 'fix-line-endings', 'typescript', ->
  typescriptFiles()
    .pipe eol {eolc: 'LF', encoding:'utf8'}
    .pipe destination 'src'

Import
  install_package: (from,to,done)->
    return setTimeout (->
      install_package from, to, done
    ), 500 if global.ts_ready > 0
   
    Fail "Directory '#{from}' doesn't exist'" if !test "-d", from
    mkdir '-p', to if !test "-d", to

    # create an empty package.json
    "{ }" .to "#{to}/package.json"

    # install the autorest typescript code into the target folder
    execute "npm install #{from}", {cwd : to }, (c,o,e)->
      done();

task 'clean' , 'typescript', (done)->
  typescriptProjectFolders()
    .pipe foreach (each,next)->
      rmdir "#{each.path}/dist/" , ->
        next null

task 'nuke' , '',['clean'], (done)->
  typescriptProjectFolders()
    .pipe foreach (each,next)->
      rmdir "#{each.path}/node_modules/" , ->
        next null

task 'test', 'typescript',['build/typescript'], (done)->
  typescriptProjectFolders()
    .pipe where (each) ->
      return test "-d", "#{each.path}/test"

    .pipe foreach (each,next)->
      execute "#{basefolder}/node_modules/.bin/npm test", {cwd: each.path, silent:false }, (code,stdout,stderr) ->
        next null

task "compile/typescript", '' , (done)->  
  done()

task 'build', 'typescript', (done)-> 
 # watch for changes to these files and propogate them to the right spot.
 watcher = watchFiles ["#{basefolder}/src/autorest-core/**/*.d.ts"], ["copy-dts-files"]

  typescriptProjectFolders()
    .on 'end', -> 
      run 'compile/typescript', -> 
        watcher.close() if !watch
        done()

    .pipe where (each ) -> 
      return test "-f", "#{each.path}/tsconfig.json"
      
    .pipe foreach (each,next ) ->
      fn = filename each.path
      deps =  ("compile/typescript/#{d.substring(d.indexOf('/')+1)}" for d in (global.Dependencies[fn] || []) )
      
      task 'compile/typescript', fn,deps, (fin) ->
        execute "#{basefolder}/node_modules/.bin/tsc --project #{each.path} ", {cwd: each.path }, (code,stdout,stderr) ->
          if watch 
            execute "#{basefolder}/node_modules/.bin/tsc --watch --project #{each.path}", (c,o,e)-> 
             echo "watching #{fn}"
            , (d) -> echo d.replace(/^src\//mig, "#{basefolder}/src/")
          fin()
      next null
    return null

task 'npm-install', '', ['init-deps'], (done)-> 
  global.threshold =1
  typescriptProjectFolders()
    .on 'end', -> 
      run 'npm-install', ->
        done()

    .pipe where (each ) -> 
      return test "-f", "#{each.path}/tsconfig.json"
      
    .pipe foreach (each,next ) ->
      fn = filename each.path
      deps =  ("npm-install/#{d.substring(d.indexOf('/')+1)}" for d in (global.Dependencies[fn] || []) )
      
      task 'npm-install', fn,deps, (fin) ->
        echo "Running npm install for #{each.path}."
        execute "#{basefolder}/node_modules/.bin/npm install", {cwd: each.path, silent:false }, (code,stdout,stderr) ->
          echo stderr
          echo stdout
          fin()

      next null
    return null
