
############################################### 
task 'increment-version', 'increments the version and updates the project files', ->
  newversion = version.split '.'
  newversion[newversion.length-1]++
  newversion = newversion.join '.' 
  global.version = newversion
  run 'set-version'

############################################### 
task 'set-version', 'updates version in the the project files', ->
  # write the version number to the version file
  version .to "#{global.basefolder}/VERSION"