task 'publish-preview' , 'Publishes the the packages to NPM.',['version-number','build'],  (done)->
  publish_core = false
  publish_bootstrapper = false

  execute 'git show --pretty="" --name-only',{silent:true}, (c,o,e)->
    publish_core = true if( o.indexOf("src/") >-1 ) 
    publish_bootstrapper = true if( o.indexOf("src/autorest/") >-1 ) 

    return done() if !publish_core # neither need publishing

    # update core package.json
    package_path = "#{basefolder}/src/autorest-core/package.json"
    package_folder = "#{basefolder}/src/autorest-core"
    package_json = require package_path
    package_json.version = version
    JSON.stringify(package_json,null,'  ').to package_path 

    # publish core package
    execute "npm publish --tag preview",{cwd:package_folder, silent:false }, (c,o,e) -> 
      echo  "\n\nPublished Core:  #{package_json.name}@#{info package_json.version} (tagged as @preview)\n\n"

      return done() if !publish_bootstrapper # doesn't need new bootstrapper

      # update bootstrapepr package.json
      package_path = "#{basefolder}/src/autorest/package.json"
      package_folder = "#{basefolder}/src/autorest"
      package_json = require package_path
      package_json.version = version
      JSON.stringify(package_json,null,'  ').to package_path 

      execute "npm publish --tag preview",{cwd:package_folder, silent:false }, (c,o,e) -> 
        echo  "\n\nPublished Bootstrapper:  #{package_json.name}@#{info package_json.version} (tagged as @preview)\n\n"
        done()