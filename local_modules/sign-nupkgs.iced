through = require 'through2'
util = require 'util'

module.exports = (cmd) ->
  through.obj (file, enc, callback) ->

    # check if the file is an actual file. 
    # if it's not, just skip this tool.
    if !file or !file.path
      return callback null, file


    # unpack the file into 