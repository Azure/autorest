# build task for tsc 
task 'build', 'typescript', (done)-> 
  count = 4
  typescriptProjects()
    .pipe foreach (each,next) -> 
      execute "#{basefolder}/node_modules/.bin/tsc --project #{folder each.path}",{retry:1} ,(code,stdout,stderr) ->
        echo stdout.replace("src/","#{basefolder}/src/".trim()) 
        count--
        if count is 0
          if ! test '-d',"#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules"
            mkdir "-p", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules"
  
          if ! test '-d', "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules/autorest-core"
            fs.symlinkSync "#{basefolder}/src/autorest-core", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules/autorest-core",'junction' 
          done()
      next null
  return null

task 'fix-line-endings', 'typescript', ->
  typescriptFiles()
    .pipe eol {eolc: 'LF', encoding:'utf8'}
    .pipe destination 'src'
    #.pipe showFiles()

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
    .pipe foreach (each,next)->
      if test "-f", "#{each.path}/node_modules/.bin/mocha"
        execute "#{each.path}/node_modules/.bin/mocha test  --timeout 5000", {cwd: each.path}, (c,o,e) ->
          next null
      else
        next null

task 'npm-install', 'typescript', (done)-> 
  count = 4
  typescriptProjectFolders()
    .pipe foreach (each,next)-> 
      #count++
      execute "npm install", {cwd: each.path }, (code,stdout,stderr) ->
        count--
        if count is 0
          done() 
      next null
  return null
