through = require 'through2'
util = require 'util'

module.exports = (cmd) ->
  through.obj (file, enc, callback) ->

    # check if the file is an actual file. 
    # if it's not, just skip this tool.
    if !file or !file.path
      return callback null, file
    
    # do something with the file
    await exec "dotnet #{cmd} #{ file.path } /nologo", defer code,stdout,stderr

    if code != 0 
      throw "dotnet #{cmd} failed"
    
    # before you go...
    
    # add the file into the stream for the next processor
    # and call the pass it along
    # (this way is handy if you have add more files than just the one we have.)
    # this.push file 
    # callback null
    
    # or say, "pass it along"
    # callback null,file
    
    # or just done, no more processing
    return callback null
