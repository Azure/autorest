# set the base folder of this project
global.basefolder = "#{__dirname}"

# use our tweaked version of gulp with iced coffee.
require './src/local_modules/gulp.iced'

# tasks required for this build 
Tasks "dotnet"

# Settings
Import
  solution: "#{basefolder}/AutoRest.sln"
  packages: "#{basefolder}/packages"

  # which projects to care about
  projects:() ->
    source 'src/**/*.csproj'

  # which projects to package
  pkgs:() ->
    source 'src/**/*.csproj'
      .pipe except /tests/ig

  # test projects 
  tests:() ->
    source 'src/**/*[Tt]ests.csproj'
      .pipe except /AutoRest.Tests/ig #not used yet.
      .pipe except /AutoRest.AzureResourceSchema.Tests/ig
      #.pipe except /AutoRest.Swagger.Tests/ig
    
  # assemblies that we sign
  assemblies: () -> 
    source "src/**/bin/#{configuration}/**/*.dll"   # the dlls in the ouptut folders
      .pipe except /tests/ig        # except of course, test dlls
      .pipe where (each) ->                         # take only files that are the same name as a folder they are in. (so, no deps.)
        return true for folder in split each.path when folder is basename each.path 


task 'clean','Cleans the the solution', ['clean-packages'], -> 
  exec "git checkout #{basefolder}/packages"  

task 'autorest', 'Runs AutoRest', -> 
  # Run AutoRest from the original current directory.
  cd process.env.INIT_CWD
  exec "dotnet #{basefolder}/src/core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll #{process.argv.slice(3).join(' ')}"