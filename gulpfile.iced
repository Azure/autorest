# set the base folder of this project
global.basefolder = "#{__dirname}"

# use our tweaked version of gulp with iced coffee.
require './src/local_modules/gulp.iced'

# tasks required for this build 
Tasks "dotnet",  # compiling dotnet
  "typescript",  # compiling typescript
  "test",        # running tests
  "regeneration" # regenerating expected files
  "publishing"   # signing/publishing binaries to github and npm registry

# Settings
Import
  solution: "#{basefolder}/AutoRest.sln"
  packages: "#{basefolder}/packages"
  release_name: if argv.nightly then "#{version}-nightly-#{today}"              else if argv.daily then "#{version}-daily-#{now}"              else "#{version}"
  package_name: if argv.nightly then "autorest-#{version}-nightly-#{today}.zip" else if argv.daily then "autorest-#{version}-daily-#{now}.zip" else "autorest-#{version}.zip"

  # which projects to care about
  projects:() ->
    source 'src/**/*.csproj'
      .pipe except /preview/ig

  # test projects 
  tests:() ->
    source 'src/**/*[Tt]ests.csproj'
      .pipe except /AutoRest.Tests/ig #not used yet.
      .pipe except /AutoRest.AzureResourceSchema.Tests/ig
      #.pipe except /AutoRest.Swagger.Tests/ig
    
  # assemblies that we sign
  assemblies: () -> 
    source "src/core/AutoRest/bin/Release/netcoreapp1.0/publish/**/AutoRest*"
      .pipe except /pdb$/i
      .pipe except /json$/i
      .pipe except /so$/i
      .pipe onlyFiles()

  packagefiles: () -> 
    source "src/core/AutoRest/bin/Release/netcoreapp1.0/publish/**"
      .pipe except /pdb$/i
      .pipe onlyFiles()
  
  typescriptProjectFolders: ()->
    source ["src/autorest", "src/extension", "src/bootstrapper" ]

  typescriptProjects: () -> 
    typescriptProjectFolders()
      .pipe foreach (each,next,more)=>
        source "#{each.path}/tsconfig.json"
          .on 'end', -> 
            next null
          .pipe foreach (e,n)->
            more.push e
            n null

  generatedFiles: () -> 
    typescriptProjectFolders()
      .pipe foreach (each,next,more)=>
        source(["#{each.path}/**/*.js", "#{each.path}/**/*.js.map", "!#{each.path}/node_modules/**"])
          .on 'end', -> 
            next null
          .pipe foreach (e,n)->
            more.push e
            n null
        
  typescriptFiles: () -> 
    typescriptProjectFolders()
      .pipe foreach (each,next,more)=>
        source(["#{each.path}/**/*.ts", "#{each.path}/**/*.json", "!#{each.path}/node_modules/**"])
          .on 'end', -> 
            next null
          .pipe foreach (e,n)->
            e.base = each.base
            more.push e
            n null


task 'autorest', 'Runs AutoRest', (done) ->
  args = process.argv.slice(3)
  exec "dotnet #{basefolder}/src/core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll #{args.join(' ')}" , {cwd: process.env.INIT_CWD}, (code,stdout,stderr) ->
    return done()

task 'autorest-app', "Runs AutoRest (via node)" ,(done)->
  args = process.argv.slice(3)
  exec "node #{basefolder}/src/core/AutoRest/bin/#{configuration}/netcoreapp1.0/node_modules/autorest-app/index.js #{args.join(' ')}" , {cwd: process.env.INIT_CWD}, (code,stdout,stderr) ->
    return done()

autorest = (args,done) ->
  # Run AutoRest from the original current directory.
  echo info "AutoRest #{args.join(' ')}"
  execute "dotnet #{basefolder}/src/core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll #{args.join(' ')}" , {silent:true, cwd: process.env.INIT_CWD}, (code,stdout,stderr) ->
    return done()

if (newer "#{basefolder}/package.json",  "#{basefolder}/node_modules") 
  echo error "\n#{ warning 'WARNING:' } package.json is newer than 'node_modules' - you might want to do an 'npm install'\n"