task 'build/dotnet/binaries','', (done) -> 
  exec "dotnet publish -c #{configuration} #{basefolder}/src/core/AutoRest /nologo /clp:NoSummary", (code, stdout, stderr) ->
    Fail "Build Failed #{ warning stdout } \n#{ error stderr }" if code 
    done();

task 'zip-autorest', '', () ->
  packagefiles()
    .pipe zip package_name
    .pipe destination packages

task 'install/node-files' ,'', (done)->
  if ! test '-d',"#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules"
    mkdir "-p", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules"
  
  if ! test '-d', "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules/autorest-core"
    fs.symlinkSync "#{basefolder}/src/autorest-core", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules/autorest-core",'junction' 
  done();
  return null;

task 'package','From scratch build, sign, and package autorest', (done) -> 
  run 'clean',
    'restore'
    [ 'build/typescript', 'build/dotnet/binaries' ],
    [ 'sign-assemblies', 'install/node-files' ],
    'zip-autorest' 
    -> done()

task 'publish', 'Builds, signs, publishes autorest binaries to GitHub Release',(done) ->
  run 'package',
    'upload/github'
    -> done()

task 'copy-vscode-files-to-work', '', ->
  echo "Copying files into \n#{workdir}"
  src = "#{basefolder}/src/vscode-autorest"
  source ["#{src}/**",
    "!#{src}/*.vsix"
    "!#{src}/node_modules/autorest/node_modules/autorest-core/**"
    "!#{src}/node_modules/autorest/node_modules/@types/**"
    "!#{src}/node_modules/autorest/node_modules/del/**"
    "!#{src}/node_modules/autorest/node_modules/mocha/**"
    "!#{src}/node_modules/autorest/node_modules/mocha-typescript/**"
    "!#{src}/node_modules/autorest/node_modules/typescript/**"
    "!#{src}/node_modules/autorest/node_modules/browser-stdout/**"
    "!#{src}/node_modules/autorest/node_modules/debug/**"
    "!#{src}/node_modules/autorest/node_modules/diff/**"
    "!#{src}/node_modules/autorest/node_modules/globby/**"
    "!#{src}/node_modules/autorest/node_modules/growl/**"
    "!#{src}/node_modules/autorest/node_modules/has-flag/**"
    "!#{src}/node_modules/autorest/node_modules/is-path-cwd/**"
    "!#{src}/node_modules/autorest/node_modules/is-path-in-cwd/**"
    "!#{src}/node_modules/autorest/node_modules/json3/**"
    "!#{src}/node_modules/autorest/node_modules/lodash.create/**"
    "!#{src}/node_modules/autorest/node_modules/array-union/**"
    "!#{src}/node_modules/autorest/node_modules/arrify/**"
    "!#{src}/node_modules/autorest/node_modules/is-path-inside/**"
    "!#{src}/node_modules/autorest/node_modules/lodash._baseassign/**"
    "!#{src}/node_modules/autorest/node_modules/lodash._basecreate/**"
    "!#{src}/node_modules/autorest/node_modules/lodash._isiterateecall/**"
    "!#{src}/node_modules/autorest/node_modules/ms/**"
    "!#{src}/node_modules/autorest/node_modules/object-assign/**"
    "!#{src}/node_modules/autorest/node_modules/array-uniq/**"
    "!#{src}/node_modules/autorest/node_modules/lodash._basecopy/**"
    "!#{src}/node_modules/autorest/node_modules/lodash.keys/**"
    "!#{src}/node_modules/autorest/node_modules/path-is-inside/**"
    "!#{src}/node_modules/autorest/node_modules/lodash._getnative/**"
    "!#{src}/node_modules/autorest/node_modules/lodash.isarguments/**"
    "!#{src}/node_modules/autorest/node_modules/lodash.isarray/**"   

    "!#{src}/node_modules/autorest/node_modules/autorest-core"
    "!#{src}/node_modules/autorest/node_modules/@types"
    "!#{src}/node_modules/autorest/node_modules/del"
    "!#{src}/node_modules/autorest/node_modules/mocha"
    "!#{src}/node_modules/autorest/node_modules/mocha-typescript"
    "!#{src}/node_modules/autorest/node_modules/typescript"
    "!#{src}/node_modules/autorest/node_modules/browser-stdout"
    "!#{src}/node_modules/autorest/node_modules/debug"
    "!#{src}/node_modules/autorest/node_modules/diff"
    "!#{src}/node_modules/autorest/node_modules/globby"
    "!#{src}/node_modules/autorest/node_modules/growl"
    "!#{src}/node_modules/autorest/node_modules/has-flag"
    "!#{src}/node_modules/autorest/node_modules/is-path-cwd"
    "!#{src}/node_modules/autorest/node_modules/is-path-in-cwd"
    "!#{src}/node_modules/autorest/node_modules/json3"
    "!#{src}/node_modules/autorest/node_modules/lodash.create"
    "!#{src}/node_modules/autorest/node_modules/array-union"
    "!#{src}/node_modules/autorest/node_modules/arrify"
    "!#{src}/node_modules/autorest/node_modules/is-path-inside"
    "!#{src}/node_modules/autorest/node_modules/lodash._baseassign"
    "!#{src}/node_modules/autorest/node_modules/lodash._basecreate"
    "!#{src}/node_modules/autorest/node_modules/lodash._isiterateecall"
    "!#{src}/node_modules/autorest/node_modules/ms"
    "!#{src}/node_modules/autorest/node_modules/object-assign"
    "!#{src}/node_modules/autorest/node_modules/array-uniq"
    "!#{src}/node_modules/autorest/node_modules/lodash._basecopy"
    "!#{src}/node_modules/autorest/node_modules/lodash.keys"
    "!#{src}/node_modules/autorest/node_modules/path-is-inside"
    "!#{src}/node_modules/autorest/node_modules/lodash._getnative"
    "!#{src}/node_modules/autorest/node_modules/lodash.isarguments"
    "!#{src}/node_modules/autorest/node_modules/lodash.isarray"       
    "!#{src}/test"
    "!#{src}/test/**"
  ]
    .pipe destination "#{workdir}/" 

task 'package/vscode', "creates the autorest vscode extension package.",(done)-> 
  run "clean", "build", -> 
    echo "updating version in package.json file"
    execute "npm version patch", {cwd: "#{basefolder}/src/vscode-autorest" },(c,o,e)->
      run "copy-vscode-files-to-work", -> 
        echo "patching package.json file to include autorest package"
        pkg = require("#{workdir}/package.json")
        pkg.dependencies.autorest="*"
        JSON.stringify(pkg).to("#{workdir}/package.json");

        execute "vsce package", {cwd: "#{workdir}" },(c,o,e)->
          mv "#{workdir}/*.vsix","#{basefolder}/src/vscode-autorest/"
          rm '-rf', workdir
          name = "#{basefolder}/src/vscode-autorest/autorest-#{pkg.version}.vsix"
          echo "Package Created:\n   #{name}"
          done()

  return null
  
task 'publish/vscode', "uploads the autorest vscode extension package.",(done)-> 
  pkg = require("#{basefolder}/src/vscode-autorest/package.json")
  execute "vsce publish --packagePath #{basefolder}/src/vscode-autorest/autorest-#{pkg.version}.vsix", {silent:false},(c,o,e)->
    done()
    
task 'publish/autorest', '', ['build/typescript'], (done) ->
  execute "npm publish ", {cwd: "#{basefolder}/src/autorest" }, done

task 'upload/github','', ->
  Fail "needs --github_apikey=... or GITHUB_APIKEY set" if !github_apikey
  Fail "Missing package file #{packages}/#{package_name}" if !exists("#{packages}/#{package_name}")

  source "#{packages}/#{package_name}"
    .pipe ghrelease {
      token: github_apikey,   
      owner: github_feed,
      repo: 'autorest',
      tag: "v#{release_name}",       
      name: "#{release_name}", 
      notes: """
This release just contains the binary runtimes for the #{release_name} release of AutoRest.

To Install AutoRest, install nodej.js 6.9.5 or later, and run

> `npm install -g autorest`

(You don't want to download these files directly, there's no point.)
""",                
      draft: false,
      prerelease: if argv.nightly then true else false, 
    }

