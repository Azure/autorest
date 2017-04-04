
############################################### 
task 'test', "runs all tests", (done) ->
    run 'test-dotnet',
      'test-go'
      'test-java'
      'test-node'
      #'test-python'
      #'test-ruby'
      -> done()
   

###############################################
task 'test-go', 'runs Go tests', ['regenerate-go'], (done) ->  # Go does not use generated files as "expected" files and ".gitignore"s them! => need to (and may) just regenerate
  process.env.GOPATH = "#{basefolder}/src/generator/AutoRest.Go.Tests"
  await execute "glide up",               { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }, defer code, stderr, stdout
  await execute "go fmt ./generated/...", { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }, defer code, stderr, stdout
  await execute "go run ./runner.go",     { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }, defer code, stderr, stdout
  done()

###############################################
task 'test-java', 'runs Java tests', (done) ->
  await execute "mvn test -pl src/generator/AutoRest.Java.Tests",       defer code, stderr, stdout
  await execute "mvn test -pl src/generator/AutoRest.Java.Azure.Tests", defer code, stderr, stdout
  done()

###############################################
task 'test-node', 'runs NodeJS tests', (done) ->
  await execute "npm test", { cwd: './src/generator/AutoRest.NodeJS.Tests/' }, defer code, stderr, stdout
  await execute "npm test", { cwd: './src/generator/AutoRest.NodeJS.Azure.Tests/' }, defer code, stderr, stdout
  done()

###############################################
task 'test-python', 'runs Python tests', (done) ->
  await execute "tox", { cwd: './src/generator/AutoRest.Python.Tests/' }, defer code, stderr, stdout
  await execute "tox", { cwd: './src/generator/AutoRest.Python.Azure.Tests/' }, defer code, stderr, stdout
  done()

###############################################
task 'test-ruby', 'runs Ruby tests', ['regenerate-ruby', 'regenerate-rubyazure'], (done) ->  # Ruby does not use generated files as "expected" files and ".gitignore"s them! => need to (and may) just regenerate
  await execute "ruby RspecTests/tests_runner.rb", { cwd: './src/generator/AutoRest.Ruby.Tests/' }, defer code, stderr, stdout
  await execute "ruby RspecTests/tests_runner.rb", { cwd: './src/generator/AutoRest.Ruby.Azure.Tests/' }, defer code, stderr, stdout
  done()
