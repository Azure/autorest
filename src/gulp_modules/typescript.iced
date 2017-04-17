task 'copy-dts-files', '', (done)->
  # this needs to run multiple times.
  global.completed['copy-dts-files'] = false
  
  # copy *.d.ts files 
  source ["#{basefolder}/src/autorest-core/**/*.d.ts","!#{basefolder}/src/autorest-core/node_modules/**","!#{basefolder}/src/autorest-core/test/**" ]
    .pipe destination "#{basefolder}/src/autorest/lib/core"

# build task for tsc 
task 'build', 'typescript', (done)-> 
  count = 2
  
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
  generatedFiles()
    .pipe foreach (each,next)->
      rm each.path
      next null

task 'test', 'typescript',['build/typescript'], (done)->
  typescriptProjectFolders()
    .pipe where (each) ->
      return true if test "-d", "#{each.path}/test"
      return false
    .pipe foreach (each,next)->
      if test "-f", "#{each.path}/node_modules/.bin/mocha"
        execute "#{each.path}/node_modules/.bin/mocha test  --timeout 15000", {cwd: each.path}, (c,o,e) ->
          next null
      else
        next null

task 'npm-install', 'typescript', (done)-> 
  count = 5
  npminstalls()
    .pipe foreach (each,next)-> 
      #count++
      execute "npm install", {cwd: each.path }, (code,stdout,stderr) ->
        count--
        if count is 0
          done() 
      next null
  return null
