
# build task for tsc 
task 'build', 'builds project (typescript)', -> 
  exec "#{basefolder}/node_modules/.bin/tsc"

