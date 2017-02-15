
# build task for tsc 
task 'build', 'build:typescript', -> 
  exec "#{basefolder}/node_modules/.bin/tsc"

