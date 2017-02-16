# build task for tsc 
task 'build', 'build:typescript', (done)-> 
  count = 0
  typescriptProjects()
    .pipe foreach (each,next) -> 
      count++
      execute "#{basefolder}/node_modules/.bin/tsc --project #{folder each.path}", (code,stdout,stderr) ->
        echo stdout.replace("src/next-gen","#{basefolder}/src/next-gen") 
        count--
        if count is 0
          done() 

      next null
    return null
    
task 'install', 'install:typescript', (done)-> 
  count = 0
  typescriptProjects()
    .pipe foreach (each,next) -> 
      count++
      execute "npm install", {cwd: folder each.path}, (code,stdout,stderr) ->
        count--
        if count is 0
          done() 
      next null

    return null
    
    
    
    
    
