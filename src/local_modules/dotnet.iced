# through = require 'through2'

# tools
csu = "c:/ci-signing/adxsdk/tools/csu/csu.exe"

dotnet = (cmd) ->
  through.obj (file, enc, callback) ->
    # check if the file is an actual file. 
    # if it's not, just skip this tool.
    if !file or !file.path
      return callback null, file
    
    # do something with the file
    await execute "dotnet #{cmd} #{ file.path } /nologo", defer code,stdout,stderr
    # Fail "dotnet #{cmd} failed" if code
    # or just done, no more processing
    return callback null

###############################################
# Common Tasks

###############################################
#task 'clean-packages', 'cleans out the contents of the packages folder', ->  
  #rm '-rf', packages
  #mkdir packages 

############################################### 
task 'reset-dotnet-cache', 'removes installed dotnet-packages so restore is clean', ->  
  rm '-rf', "#{os.homedir()}/.nuget"

###############################################
task 'clean','calls dotnet-clean on the solution', (done)-> 
  execute "dotnet clean #{solution} /nologo",(c,s,e) =>
    done()

###############################################
task 'build','build:dotnet',['restore'], (done) ->
  global.ts_ready++
  execute "dotnet build -c #{configuration} #{solution} /nologo /clp:NoSummary", (code, stdout, stderr) ->
    # Fail "Build Failed #{ stderr }" if code
    # echo "done build"
    global.ts_ready--
    done();
    

###############################################
task 'policheck-assemblies','', -> 
  source 'src/**/*.dll'
    .pipe except /install|testapp|tests/ig 
    .pipe policheck()

###############################################
task 'sign-assemblies','', (done) -> 
  # skip signing if we're not doing a release build
  Fail "signing requires --configuration release" if configuration isnt "release"

  unsigned  = "#{workdir}/unsigned"
  mkdir unsigned 

  signed  = "#{workdir}/signed"
  mkdir signed

  assemblies() 
    # rename the files to flatten folder names out of the way.
    .pipe rename (path) -> 
      flattenEncode path
    
    # copy the files to the destination before signing 
    .pipe destination(unsigned)

    .on 'end', () =>
      # after the files are in the folder, we can call the signing utility
      codesign "Microsoft Azure SDK (Perks)",
        "Microsoft Azure .NET SDK"
        unsigned,
        signed,
        () ->
          # after signing, files are in the signed directory
          source "#{signed}/*"
            .pipe rename (path) -> 
              flattenDecode path 
            .pipe destination "#{__dirname}/src"            
            .on 'end', () => 
              # cleanup!
              rm '-rf', workdir
              done()
    
    return;

############################################### 
task 'restore','restores the dotnet packages for the projects', (done) -> 
  if ! test '-d', "#{os.homedir()}/.nuget"
    global.force = true
  instances = 0 
  _done = () ->
    if instances is 0
      instances--
      done();

  projects()
    .on 'end', -> 
      _done() 
    .pipe where (each) ->  # check for project.assets.json files are up to date  
      return true if force
      assets = "#{folder each.path}/obj/project.assets.json"
      return false if (exists assets) and (newer assets, each.path)
      return true
    .pipe foreach (each,next)->
      any = true
      instances++
      execute "dotnet restore #{ each.path } /nologo",{retry:1} ,(code,stderr,stdout) ->
        instances--
        _done()
      next null  
  return null
  


############################################### 
# task 'dotnet-pack', '', ['clean-packages'] , ->
#  # package the projects
#  pkgs()
#    .pipe dotnet "pack -c #{configuration} --no-build --output #{packages} #{versionsuffix}"

############################################### 
#task 'package','From scratch build, sign, and package ', (done) -> 
#  run 'clean',
#    'restore'
#    'publish'
#    'sign-assemblies'
#    'pack' 
#    'sign-packages'
#    -> done()

############################################### 
task 'test-dotnet', 'runs dotnet tests',['restore'] , (done) ->
  instances = 0    

  # run xunit test in parallel with each other.
  tests()
    .pipe foreach (each,next)->
      instances++
      execute "dotnet test #{ each.path } /nologo", (code,stderr,stdout) ->
        instances--
        done() if instances is 0
      next null  
  return null


global['codesign'] = (description, keywords, input, output, certificate1, certificate2, done)-> 
  done = if done? then done else if certificate2? then certificate2 else if certificate1? then certificate1 else ()->
  certificate1 = if typeof certificate1 is 'number' then certificate1 else 72
  certificate2 = if typeof certificate2 is 'number' then certificate2 else 401

  Fail "Description Required" if not description?
  Fail "Keywords Required" if not keywords?
  Fail "Input Required (folder)" if not input?
  Fail "Output Required (folder)" if  not output?

  execute "#{csu} 
    /c1=#{certificate1}
    /c2=#{certificate2}
    \"/d=#{description}\"
    \"/kw=#{keywords}\"
    \"/i=#{input}\"
    \"/o=#{output}\"
    \"/clean=False\"
  " , (code, stdout, stderr) ->
    Fail error "Code Signing Failed." if code
    echo "done codesigning"
    done();

# the dotnet gulp-plugin.
module.exports = dotnet