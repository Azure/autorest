
############################################### 
task 'test', "runs all tests", (done) ->
    run 'test-dotnet', -> done()
