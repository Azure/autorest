<#
## TEST SUITE
 await run "test", defer _

 ## CLEAN
 await autorest ["--reset","--allow-no-input"], defer code,stdout,stderr

 ## REGRESSION TEST
 global.verbose = false
 # regenerate
 await run "regenerate", defer _
 # diff ('add' first so 'diff' includes untracked files)
 await  execute "git add -A", defer code, stderr, stdout
 await  execute "git diff --staged -w", defer code, stderr, stdout
 # eval
 echo stderr
 echo stdout
 throw "Potentially unnoticed regression (see diff above)! Run `gulp regenerate`, then review and commit the changes." if stdout.length + stderr.length > 0

 #>