
task 'regenerate', 'regenerate samples', (done) ->
  execute "node #{basefolder}/src/autorest/dist/app.js --reset --no-upgrade-check --allow-no-input --version=#{basefolder}/src/autorest-core --verbose --debug" , {silent:false }, (code,stdout,stderr) -> 
    count = 0
    # source 'Samples/*/**/readme.md'
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

            # sanitize generated files

            ## clear out generated sources; it's language owner's job to ensure quality of the content,
            ## we just check for existence and basic structure to detect core problems (URI resolution, file emitting, ...) 
            (find path.join(each.path, ".."))
              .filter((file) -> file.match(/\.(cs|go|java|js|ts|php|py|rb)$/))
              .forEach((file) -> "SRC".to(file))
            
            ## source maps and shell stuff (contains platform/folder dependent stuff)
            (find path.join(each.path, ".."))
              .filter((file) -> file.match(/\.(map|txt)$/))
              .forEach((file) -> 
                sed "-i", /\(node:\d+\)/g, "(node)", file  # node process IDs
                # sed "-i", /\bfile:\/\/[^\s]*\/autorest[^\/\\]*/g, "", file  # blame locations
                sed  "-i", new RegExp("\\bfile:\\/\\/\\/#{basefolder.replace(/\\/g,'/')}/","gi") , "/", file  # blame locations
                sed  "-i", new RegExp("\\bversion: .*'#{basefolder.replace(/\\/g,'/')}.src.autorest-core'","gi") , "/", file  # autorest-core path as reported by bootstrapper
                # sed "-i", /\s\'?[^\s]+[\/\\]autorest-core\'?(?=(\b|\\n))/g, " autorest-core", file  # autorest-core path as reported by bootstrapper (configuration artifact's 'version' field)
                sed "-i", /\sat .*/g, "at ...", file                        # exception stack traces
                sed "-i", /mem:\/\/\/[^: ]*/g, "mem", file                  # memory URIs (depend on timing)
                (cat file).replace(/(at \.\.\.\s*)+/g, "at ...\n").to(file) # minify exception stack traces
                (cat file).replace(/.*AutoRest code generation utility.*\n/g, "").to(file) # remove header message 
                (cat file).replace(/.*DeprecationWarning.*\n/g, "(node) DeprecationWarning (trimmed)").to(file) # remove header message
                (cat file).replace(/.*UnhandledPromiseRejectionWarning.*:n/g, "(node) UnhandledPromiseRejectionWarning:").to(file) # remove header message
                
                (cat file).replace(/.*\(C\) \d* Microsoft Corporation.*\n/g, "").to(file) # remove header message 
                
                (cat file).replace(/.* AutoRest extension '.*\n/g, "").to(file) # remove extension loading messages
                (cat file).replace(/.* Loading AutoRest core.*\n/g, "").to(file) # remove core loading messages
                (cat file).replace(/.* -> .*\n/g, "").to(file) # remove bin install messages (npm 5.6.0+)
                (cat file).replace(/Recording package path.*\n/g, "").to(file)  # dotnet-2.0.0 installation message
                (sort file).to(file) if file.endsWith("stdout.txt") || file.endsWith("stderr.txt")
              )
            
            (find path.join(each.path, ".."))
              .filter((file) -> file.match(/\.(yaml)$/))
              .forEach((file) -> 
                sed "-i", /.*autorest[a-zA-Z0-9]*.src.*/ig, "", file  # source file names
              )

            next null
          , true # don't fail on failures (since we wanna record them)
        return null;
    return null
