through = require 'through2'
util = require 'util'

module.exports = (match) ->
  # await through.obj  defer file, enc, callback
   through.obj (file, enc, callback) ->

    # check if the file is an actual file. 
    # if it's not, just skip this tool.
    if !file or !file.path
      return callback null, file
    
    # do something with the file
    if file.path.match( match ) 
        return callback null
    
    return callback null, file