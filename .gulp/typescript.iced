task 'copy-dts-files', '', (done)->
  # this needs to run multiple times.
  global.completed['copy-dts-files'] = false
  copyDtsFiles(done)
  return null

copyDtsFiles = (done) =>
  # copy *.d.ts files 
  source ["#{basefolder}/src/autorest-core/dist/**/*.d.ts","!#{basefolder}/src/autorest-core/dist/test/**" ]
    .pipe destination "#{basefolder}/src/autorest/lib/core"
    .on 'end', done
  return null

task 'fix-line-endings', 'typescript', ->
  typescriptFiles()
    .pipe eol {eolc: 'LF', encoding:'utf8'}
    .pipe destination 'src'

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

task 'build', 'typescript',["pre-build"], (done)-> 
  # watch for changes to these files and propogate them to the right spot.
  watcher = watchFiles ["#{basefolder}/src/autorest-core/dist/**/*.d.ts"], ["copy-dts-files"]
  
  typescriptProjectFolders()
    .on 'end', ->
      run 'compile/typescript', ->
        watcher._watcher.close() if !watch
        done()

    .pipe where (each ) ->
      return test "-f", "#{each.path}/tsconfig.json"
      
    .pipe foreach (each,next ) ->
      fn = filename each.path
      deps = ("compile/typescript/#{d.substring(d.indexOf('/')+1)}" for d in (global.Dependencies[fn] || []))
      
      task 'compile/typescript', fn, deps, (fin) ->
        copyDtsFiles ->
          execute "#{basefolder}/node_modules/.bin/tsc --project #{each.path} ", {cwd: each.path }, (code,stdout,stderr) ->
            if watch
              execute "#{basefolder}/node_modules/.bin/tsc --watch --project #{each.path}", (c,o,e) ->
              echo "watching #{fn}"
              , (d) -> echo d.replace(/^src\//mig, "#{basefolder}/src/")
            fin()
          return null;
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

task 'pre-build', 'typescript', (done)-> 
  # symlink the build into the target folder for the binaries.
  if ! test '-d',"#{basefolder}/src/core/AutoRest/bin/netcoreapp1.0/node_modules"
    mkdir "-p", "#{basefolder}/src/core/AutoRest/bin/netcoreapp1.0/node_modules"

  if ! test '-d', "#{basefolder}/src/core/AutoRest/bin/netcoreapp1.0/node_modules/autorest-core"
    fs.symlinkSync "#{basefolder}/src/autorest-core", "#{basefolder}/src/core/AutoRest/bin/netcoreapp1.0/node_modules/autorest-core",'junction' 
  done()