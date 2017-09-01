
task 'regenerate', 'regenerate samples', (done) ->
  count = 0
  source 'Samples/*/**/readme.md'
    .pipe foreach (each,next)->
      count++
      autorest [each.path]
        , (code,stdout,stderr) ->
          setTimeout () => 
            count--
            done() if( count == 0 ) 
          , 100
          outputFolder = path.join(each.path, "../shell")
          mkdir outputFolder if !(test "-d", outputFolder)
          ShellString(code).to(path.join(outputFolder, "code.txt"))
          ShellString(stdout).to(path.join(outputFolder, "stdout.txt"))
          ShellString(stderr).to(path.join(outputFolder, "stderr.txt"))

          # sanitize generated files (source maps and shell stuff may contain file:/// paths)
          (find path.join(each.path, ".."))
            .filter((file) -> file.match(/.(map|txt)$/))
            .forEach((file) -> 
              sed "-i", /\bfile:\/\/[^\s]*\/autorest[^\/\\]*/g, "", file  # blame locations
              sed "-i", /\sat .*/g, "at ...", file                        # exception stack traces
              sed "-i", /mem:\/\/\/[^: ]*/g, "mem", file                  # memory URIs (depend on timing)
              (cat file).replace(/(at \.\.\.\s*)+/g, "at ...\n").to(file) # minify exception stack traces
              (cat file).replace(/^.* AutoRest extension '.*$\s/g, "").to(file) # remove extension messages
              (sort file).to(file) if file.endsWith("stdout.txt") || file.endsWith("stderr.txt")
            )
          
          (find path.join(each.path, ".."))
            .filter((file) -> file.match(/.(yaml)$/))
            .forEach((file) -> 
              sed "-i", /.*autorest[a-zA-Z0-9]*.src.*/ig, "", file  # source file names
            )

          next null
        , true # don't fail on failures (since we wanna record them)
      return null;
  return null
