task 'publish/autorest' , '' , ['build/typescript'], (done) ->
  execute "npm publish ", {cwd: "#{basefolder}/src/autorest" }, done

task 'publish/autorest-core', '', ['build/typescript'], (done) ->
  execute "npm publish ", {cwd: "#{basefolder}/src/autorest-core" }, done
