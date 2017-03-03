task 'build/dotnet/binaries','', (done) -> 
  exec "dotnet publish -c #{configuration} #{basefolder}/src/core/AutoRest /nologo /clp:NoSummary", (code, stdout, stderr) ->
    Fail "Build Failed #{ warning stdout } \n#{ error stderr }" if code 
    done();

task 'zip-autorest', '', (done) ->
  packagefiles()
    .pipe zip package_name
    .pipe destination packages

task 'install-node-files' ,'', (done)->
  # install autorest files into dotnet-output-folder
  # install_package "#{basefolder}/src/autorest", "src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish",done
  if ! test '-d',"#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules"
    mkdir "-p", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules"
  
  if ! test '-d', "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules/autorest-core"
    fs.symlinkSync "#{basefolder}/src/autorest-core", "#{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/publish/node_modules/autorest-core",'junction' 
    
  return null;

task 'package','From scratch build, sign, and package autorest', (done) -> 
  run 'clean',
    'restore'
    [ 'build/typescript', 'build/dotnet/binaries' ],
    [ 'sign-assemblies', 'install-node-files' ],
    'zip-autorest' 
    -> done()

task 'publish', 'Builds, signs, publishes autorest binaries to GitHub Release',(done) ->
  run 'package',
    'upload:github'
    -> done()

task 'publish/autorest', '', ['build/typescript'], (done) ->
  execute "npm publish ", {cwd: "#{basefolder}/src/autorest" }, done

task 'upload:github','', ->
  Fail "needs --github_apikey=... or GITHUB_APIKEY set" if !github_apikey
  Fail "Missing package file #{packages}/#{package_name}" if !exists("#{packages}/#{package_name}")

  source "#{packages}/#{package_name}"
    .pipe ghrelease {
      token: github_apikey,   
      owner: 'azure',
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

