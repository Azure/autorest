# build task for tsc 
task 'build', 'build:typescript', (done)-> 
  c = 0
  count = 0
  typescriptProjects()
    .pipe foreach (each,next) -> 
      count++
      exec "#{basefolder}/node_modules/.bin/tsc --project #{folder each.path}", {silent:true}, (code,stdout,stderr) ->
        c+= code
        echo stdout.replace("src/next-gen","#{basefolder}/src/next-gen") 
        count--
        if count is 0
          Fail "Typescript compilation failed." if c 
          done() 

      next null

    return null
    
    
    
