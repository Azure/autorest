# use our tweaked version of gulp with iced coffee.
require './local_modules/gulp.iced'

# globals
packages = "#{__dirname}/packages"
version = cat "VERSION"
configuration = argv.configuration or "debug"
force = argv.force or false
solution = "#{__dirname}/AutoRest.sln"

# a default task
task 'default', ->
  echo marked """
# Usage
# =======

## gulp commands
  gulp **build** - builds the project 
  gulp **package** - all-in-one to build/sign/package the nupkgs (will sign only when **--configuration=release** )
  gulp **restore** - does a *dotnet restore*
  gulp **publish** - pushes signed packages to nuget

## available switches 
  *--force*          specify when you want to force an action (restore, etc)
  *--configuration*  'debug' or 'release'

""" 

task 'autorest', -> 
  exec "dotnet #{__dirname}/src/core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll #{process.argv.slice(3).join(' ')}"

# clean/create package folders
task 'clean-packages', ->  
  rm '-rf', packages
  mkdir packages 

# clean out bin/obj directories        
task 'clean',['clean-packages'], -> 
  exec 'dotnet clean #{solution} /nologo'

# check for project.assets.json files are up to date  
task 'restore', -> 
  source 'src/**/*.csproj'
    .pipe except /install|testapp/ig
    .pipe where (each) -> 
      return true if force
      assets = "#{folder each.path}/obj/project.assets.json"
      return false if (exists assets) and (newer assets, each.path)
      return true
    .pipe dotnet "restore"

# build the project
task 'build', ['restore'], (done) ->
  exec "dotnet build -c #{configuration} #{solution} /nologo /m:1", (code, stdout, stderr) ->
    if code 
      throw error "Build Failed #{ stderr }"
    echo "done build"
    done();

task 'policheck-assemblies', -> 
  return done() 

task 'sign-assemblies', (done) -> 
  # skip signing if we're not doing a release build
  return done() 

task 'sign-packages', (done) ->
  return done() 

task 'publish-packages', (done) ->
  return done() 

task 'pack', ['clean-packages'] , ->
  # package the projects
  source 'src/**/*.csproj'
    .pipe except /install|testapp|tests/ig
    .pipe dotnet "pack -c release --no-build --output #{packages}"
  
task 'package', (done) -> 
  run 'clean',
    'restore'
    'build'
    'sign-assemblies'
    'pack' 
    'sign-packages'
    -> done()

task 'test', (done) ->
  source 'src/**/*[Tt]ests.csproj'
    .pipe except /AutoRest.Tests/ig #not used yet.
    .pipe showFiles()
    .pipe dotnet "test"
