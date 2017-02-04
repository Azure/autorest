# set the base folder of this project
global.basefolder = "#{__dirname}"

# use our tweaked version of gulp with iced coffee.
require './local_modules/gulp.iced'

# globals
global.solution = "#{basefolder}/AutoRest.sln"
global.packages = "#{basefolder}/packages"

# projects that we want to include
global.projects = ->
  source 'src/**/*.csproj'

global.pkgs = ->
  source 'src/**/*.csproj'
    .pipe except /tests/ig

# test projects 
global.tests = ->
  source 'src/**/*[Tt]ests.csproj'
    .pipe except /AutoRest.Tests/ig #not used yet.
    .pipe except /AutoRest.AzureResourceSchema.Tests/ig
    .pipe except /AutoRest.Swagger.Tests/ig
    
# assemblies that we sign
global.assemblies = -> 
  source "src/**/bin/#{configuration}/**/*.dll"   # the dlls in the ouptut folders
    .pipe except /tests/ig        # except of course, test dlls
    .pipe where (each) ->                         # take only files that are the same name as a folder they are in. (so, no deps.)
      return true for folder in split each.path when folder is basename each.path 

