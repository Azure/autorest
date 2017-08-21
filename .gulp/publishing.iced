task 'build/dotnet/binaries','', (done) -> 
  exec "dotnet publish -c #{configuration} #{basefolder}/src/core/AutoRest /nologo /clp:NoSummary", (code, stdout, stderr) ->
    Fail "Build Failed #{ warning stdout } \n#{ error stderr }" if code 
    done();


task 'publish/autorest-classic-generators', 'Builds, signs, publishes autorest binaries to GitHub Release',(done) ->
  run 'clean',
    'restore'
    [ 'build/typescript', 'build/dotnet/binaries' ],
    [ 'sign-assemblies' ],
    -> execute "npm publish ", {cwd: "#{basefolder}/src/core/AutoRest" }, done
    
    
task 'publish/autorest' , '' , ['build/typescript'], (done) ->
  execute "npm publish ", {cwd: "#{basefolder}/src/autorest" }, done

task 'publish/autorest-core', '', ['build/typescript'], (done) ->
  execute "npm publish ", {cwd: "#{basefolder}/src/autorest-core" }, done


