# set the base folder of this project
global.basefolder = "#{__dirname}"

# use our tweaked version of gulp with iced coffee.
require './src/local_modules/gulp.iced'

# tasks required for this build 
Tasks "dotnet", 
  "typescript"

# Settings
Import
  solution: "#{basefolder}/AutoRest.sln"
  packages: "#{basefolder}/packages"

  # which projects to care about
  projects:() ->
    source 'src/**/*.csproj'
      .pipe except /preview/ig

  # which projects to package
  pkgs:() ->
    source 'src/**/*.csproj'
      .pipe except /tests/ig

  # test projects 
  tests:() ->
    source 'src/**/*[Tt]ests.csproj'
      .pipe except /AutoRest.Tests/ig #not used yet.
      .pipe except /AutoRest.AzureResourceSchema.Tests/ig
      #.pipe except /AutoRest.Swagger.Tests/ig
    
  # assemblies that we sign
  assemblies: () -> 
    source "src/**/bin/#{configuration}/**/*.dll"   # the dlls in the ouptut folders
      .pipe except /tests/ig        # except of course, test dlls
      .pipe where (each) ->                         # take only files that are the same name as a folder they are in. (so, no deps.)
        return true for folder in split each.path when folder is basename each.path 


task 'clean','Cleans the the solution', ['clean-packages'], -> 
  exec "git checkout #{basefolder}/packages"  

task 'autorest', 'Runs AutoRest', (done) -> 
  autorest process.argv.slice(3), done

task 'autorest-ng', "Runs AutoRest (via node)", ['build/build:typescript'] ,->
  cd process.env.INIT_CWD
  exec "node #{basefolder}/src/next-gen/autorest/index.js #{process.argv.slice(3).join(' ')}"

autorest = (args,done) ->
  # Run AutoRest from the original current directory.
  cd process.env.INIT_CWD
  echo info "AutoRest #{args.join(' ')}"
  exec "dotnet #{basefolder}/src/core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll #{args.join(' ')}" , {}, (code,stdout,stderr) ->
    return done() if code is 0 
    throw error "AutoRest Failed\n\n#{args.join(' ')}\n\n\{stderr}"

############################################### 
task 'test', "runs all tests", ->
  run 'test-dotnet',
      'test-go'
      'test-java'
      'test-node'
      'test-python'
      'test-ruby'

###############################################
task 'test-go', 'runs Go tests', ['regenerate-go'], (done) ->  # Go does not use generated files as "expected" files and ".gitignore"s them! => need to (and may) just regenerate
  process.env.GOPATH = __dirname + '/src/generator/AutoRest.Go.Tests'
  await exec "glide up",               { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  await exec "go fmt ./generated/...", { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  await exec "go run ./runner.go",     { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  done()

###############################################
task 'test-java', 'runs Java tests', (done) ->
  await exec "mvn test -pl src/generator/AutoRest.Java.Tests",       defer code, stderr, stdout
  throw error stderr if code isnt 0
  await exec "mvn test -pl src/generator/AutoRest.Java.Azure.Tests", defer code, stderr, stdout
  throw error stderr if code isnt 0
  done()

###############################################
task 'test-node', 'runs NodeJS tests', (done) ->
  await exec "npm test", { cwd: './src/generator/AutoRest.NodeJS.Tests/' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  await exec "npm test", { cwd: './src/generator/AutoRest.NodeJS.Azure.Tests/' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  done()

###############################################
task 'test-python', 'runs Python tests', (done) ->
  await exec "tox", { cwd: './src/generator/AutoRest.Python.Tests/' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  await exec "tox", { cwd: './src/generator/AutoRest.Python.Azure.Tests/' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  done()

###############################################
task 'test-ruby', 'runs Ruby tests', (done) ->
  await exec "ruby RspecTests/tests_runner.rb", { cwd: './src/generator/AutoRest.Ruby.Tests/' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  await exec "ruby RspecTests/tests_runner.rb", { cwd: './src/generator/AutoRest.Ruby.Azure.Tests/' }, defer code, stderr, stdout
  throw error stderr if code isnt 0
  done()

###############################################
# LEGACY 
# Instead: have bunch of configuration files sitting in a well-known spot, discover them, feed them to AutoRest, done.




regenExpected = (opts,done) ->
  outputDir = if !!opts.outputBaseDir then "#{opts.outputBaseDir}/#{opts.outputDir}" else opts.outputDir
  instances = 0    

  for key of opts.mappings
    instances++

    optsMappingsValue = opts.mappings[key]
    swaggerFile = if optsMappingsValue instanceof Array then optsMappingsValue[0] else optsMappingsValue
    args = [
      '-SkipValidation',
      '-CodeGenerator', opts.codeGenerator,
      '-OutputDirectory', "#{outputDir}/#{key}",
      '-Input', (if !!opts.inputBaseDir then "#{opts.inputBaseDir}/#{swaggerFile}" else swaggerFile),
      '-Header', (if !!opts.header then opts.header else 'MICROSOFT_MIT_NO_VERSION')      
    ]

    if (opts.modeler)
      args.push('-Modeler')
      args.push(opts.modeler)

    if (opts.addCredentials)
      args.push('-AddCredentials')
    
    if (opts.syncMethods)
      args.push('-SyncMethods')
      args.push(opts.syncMethods)
    
    if (opts.flatteningThreshold)
      args.push('-PayloadFlatteningThreshold')
      args.push(opts.flatteningThreshold)

    if (!!opts.nsPrefix)
      args.push('-Namespace')
      if (optsMappingsValue instanceof Array && optsMappingsValue[1] != undefined)
        args.push(optsMappingsValue[1])
      else
        args.push([opts.nsPrefix, key.replace(/\/|\./, '')].join('.'))

    autorest args,() =>
      instances = instances- 1
      return done() if instances is 0 

defaultMappings = {
  'AcceptanceTests/ParameterFlattening': 'parameter-flattening.json',
  'AcceptanceTests/BodyArray': 'body-array.json',
  'AcceptanceTests/BodyBoolean': 'body-boolean.json',
  'AcceptanceTests/BodyByte': 'body-byte.json',
  'AcceptanceTests/BodyComplex': 'body-complex.json',
  'AcceptanceTests/BodyDate': 'body-date.json',
  'AcceptanceTests/BodyDateTime': 'body-datetime.json',
  'AcceptanceTests/BodyDateTimeRfc1123': 'body-datetime-rfc1123.json',
  'AcceptanceTests/BodyDuration': 'body-duration.json',
  'AcceptanceTests/BodyDictionary': 'body-dictionary.json',
  'AcceptanceTests/BodyFile': 'body-file.json',
  'AcceptanceTests/BodyFormData': 'body-formdata.json',
  'AcceptanceTests/BodyInteger': 'body-integer.json',
  'AcceptanceTests/BodyNumber': 'body-number.json',
  'AcceptanceTests/BodyString': 'body-string.json',
  'AcceptanceTests/Header': 'header.json',
  'AcceptanceTests/Http': 'httpInfrastructure.json',
  'AcceptanceTests/Report': 'report.json',
  'AcceptanceTests/RequiredOptional': 'required-optional.json',
  'AcceptanceTests/Url': 'url.json',
  'AcceptanceTests/Validation': 'validation.json',
  'AcceptanceTests/CustomBaseUri': 'custom-baseUrl.json',
  'AcceptanceTests/CustomBaseUriMoreOptions': 'custom-baseUrl-more-options.json',
  'AcceptanceTests/ModelFlattening': 'model-flattening.json'
}

rubyMappings = {
  'boolean':['body-boolean.json', 'BooleanModule'],
  'integer':['body-integer.json','IntegerModule'],
  'number':['body-number.json','NumberModule'],
  'string':['body-string.json','StringModule'],
  'byte':['body-byte.json','ByteModule'],
  'array':['body-array.json','ArrayModule'],
  'dictionary':['body-dictionary.json','DictionaryModule'],
  'date':['body-date.json','DateModule'],
  'datetime':['body-datetime.json','DatetimeModule'],
  'datetime_rfc1123':['body-datetime-rfc1123.json','DatetimeRfc1123Module'],
  'duration':['body-duration.json','DurationModule'],
  'complex':['body-complex.json','ComplexModule'],
  'url':['url.json','UrlModule'],
  'url_items':['url.json','UrlModule'],
  'url_query':['url.json','UrlModule'],
  'header_folder':['header.json','HeaderModule'],
  'http_infrastructure':['httpInfrastructure.json','HttpInfrastructureModule'],
  'required_optional':['required-optional.json','RequiredOptionalModule'],
  'report':['report.json','ReportModule'],
  'model_flattening':['model-flattening.json', 'ModelFlatteningModule'],
  'parameter_flattening':['parameter-flattening.json', 'ParameterFlatteningModule'],
  'validation':['validation.json', 'ValidationModule'],
  'custom_base_uri':['custom-baseUrl.json', 'CustomBaseUriModule'],
  'custom_base_uri_more':['custom-baseUrl-more-options.json', 'CustomBaseUriMoreModule']
}

goMappings = {
  'body-array':['body-array.json','arraygroup'],
  'body-boolean':['body-boolean.json', 'booleangroup'],
  'body-byte':['body-byte.json','bytegroup'],
  'body-complex':['body-complex.json','complexgroup'],
  'body-date':['body-date.json','dategroup'],
  'body-datetime-rfc1123':['body-datetime-rfc1123.json','datetimerfc1123group'],
  'body-datetime':['body-datetime.json','datetimegroup'],
  'body-dictionary':['body-dictionary.json','dictionarygroup'],
  'body-duration':['body-duration.json','durationgroup'],
  'body-file':['body-file.json', 'filegroup'],
  'body-formdata':['body-formdata.json', 'formdatagroup'],
  'body-integer':['body-integer.json','integergroup'],
  'body-number':['body-number.json','numbergroup'],
  'body-string':['body-string.json','stringgroup'],
  'custom-baseurl':['custom-baseUrl.json', 'custombaseurlgroup'],
  'header':['header.json','headergroup'],
  'httpinfrastructure':['httpInfrastructure.json','httpinfrastructuregroup'],
  'model-flattening':['model-flattening.json', 'modelflatteninggroup'],
  'report':['report.json','report'],
  'required-optional':['required-optional.json','optionalgroup'],
  'url':['url.json','urlgroup'],
  'validation':['validation.json', 'validationgroup'],
  'paging':['paging.json', 'paginggroup'],
  'more-custom-base-uri':['custom-baseUrl-more-options.json', 'morecustombaseurigroup'],
  'azurereport':['azure-report.json', 'azurereport']
}


defaultAzureMappings = {
  'AcceptanceTests/Lro': 'lro.json',
  'AcceptanceTests/Paging': 'paging.json',
  'AcceptanceTests/AzureReport': 'azure-report.json',
  'AcceptanceTests/AzureParameterGrouping': 'azure-parameter-grouping.json',
  'AcceptanceTests/AzureResource': 'azure-resource.json',
  'AcceptanceTests/Head': 'head.json',
  'AcceptanceTests/HeadExceptions': 'head-exceptions.json',
  'AcceptanceTests/SubscriptionIdApiVersion': 'subscriptionId-apiVersion.json',
  'AcceptanceTests/AzureSpecials': 'azure-special-properties.json',
  'AcceptanceTests/CustomBaseUri': 'custom-baseUrl.json'
}

compositeMappings = {
  'AcceptanceTests/CompositeBoolIntClient': 'composite-swagger.json'
}

azureCompositeMappings = {
  'AcceptanceTests/AzureCompositeModelClient': 'azure-composite-swagger.json'
}

nodeAzureMappings = {
  'AcceptanceTests/StorageManagementClient': 'storage.json'
}

nodeMappings = {
  'AcceptanceTests/ComplexModelClient': 'complex-model.json'
}

rubyAzureMappings = {
  'head':['head.json', 'HeadModule'],
  'head_exceptions':['head-exceptions.json', 'HeadExceptionsModule'],
  'paging':['paging.json', 'PagingModule'],
  'azure_resource':['azure-resource.json', 'AzureResourceModule'],
  'lro':['lro.json', 'LroModule'],
  'azure_url':['subscriptionId-apiVersion.json', 'AzureUrlModule'],
  'azure_special_properties': ['azure-special-properties.json', 'AzureSpecialPropertiesModule'],
  'azure_report':['azure-report.json', 'AzureReportModule'],
  'parameter_grouping':['azure-parameter-grouping.json', 'ParameterGroupingModule']
}

mergeOptions = (obj1, obj2) ->
  obj3 = {}
  for attrname of obj1
    obj3[attrname] = obj1[attrname]
  for attrname of obj2
    obj3[attrname] = obj2[attrname]
  return obj3

task 'regenerate-nodecomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': compositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-nodeazurecomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-nodeazure', '', ['regenerate-nodeazurecomposite'], (done) ->
  for p of defaultAzureMappings
    nodeAzureMappings[p] = defaultAzureMappings[p]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': nodeAzureMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-node', '', ['regenerate-nodecomposite'], (done) ->
  for p of defaultMappings
    nodeMappings[p] = defaultMappings[p]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': nodeMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-python', '', (done) ->
  mappings = mergeOptions({ 
    'AcceptanceTests/UrlMultiCollectionFormat' : 'url-multi-collectionFormat.json'
  }, defaultMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Python.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'nsPrefix': "Fixtures"
    'outputDir': 'Expected',
    'codeGenerator': 'Python',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-pythonazure', '', (done) ->
  mappings = mergeOptions({ 
    'AcceptanceTests/AzureBodyDuration': 'body-duration.json',
    'AcceptanceTests/StorageManagementClient': 'storage.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Python.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'nsPrefix': "Fixtures"
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.Python',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-rubyazure', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': rubyAzureMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Azure.Ruby',
    'nsPrefix': 'MyNamespace'
  },done
  return null

task 'regenerate-ruby', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': rubyMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Ruby',
    'nsPrefix': 'MyNamespace'
  },done
  return null

task 'regenerate-javaazure', '', (done) ->
  mappings = {}
  for key of defaultAzureMappings
    mappings[key.substring(16).toLowerCase()] = defaultAzureMappings[key]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Java.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java',
    'nsPrefix': 'Fixtures'
  },done
  return null

task 'regenerate-javaazurefluent', '', (done) ->
  mappings = {}
  for key of defaultAzureMappings
    mappings[key.substring(16).toLowerCase()] = defaultAzureMappings[key]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Java.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java.Fluent',
    'nsPrefix': 'Fixtures'
  },done
  return null

task 'regenerate-java', '', (done) ->
  mappings = {}
  for key of defaultMappings
    mappings[key.substring(16).toLowerCase()] = defaultMappings[key]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Java.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Java',
    'nsPrefix': 'Fixtures'
  },done
  return null

task 'regenerate-csazure', '', ['regenerate-csazurecomposite','regenerate-csazureallsync', 'regenerate-csazurenosync'], (done) ->
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': 'body-duration.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-csazurefluent', '', ['regenerate-csazurefluentcomposite','regenerate-csazurefluentallsync', 'regenerate-csazurefluentnosync'], (done) ->
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': 'body-duration.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-cs', '', ['regenerate-cswithcreds', 'regenerate-cscomposite', 'regenerate-csallsync', 'regenerate-csnosync'], (done) ->
  mappings = mergeOptions({
    'Mirror.RecursiveTypes': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-mirror-recursive-type.json',
    'Mirror.Primitives': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-mirror-primitives.json',
    'Mirror.Sequences': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-mirror-sequences.json',
    'Mirror.Polymorphic': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-mirror-polymorphic.json',
    'Internal.Ctors': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-internal-ctors.json',
    'Additional.Properties': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-additional-properties.yaml',
    'DateTimeOffset': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger-datetimeoffset.json',
    'AcceptanceTests/UrlMultiCollectionFormat' : 'url-multi-collectionFormat.json'
  }, defaultMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-cswithcreds', '', (done) ->
  mappings = {
    'PetstoreV2': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger.2.0.example.v2.json',
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'addCredentials': true
  },done
  return null

task 'regenerate-csallsync', '', (done) ->
  mappings = {
    'PetstoreV2AllSync': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger.2.0.example.v2.json',
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  },done
  return null

task 'regenerate-csnosync', '', (done) ->
  mappings = {
    'PetstoreV2NoSync': '../../../generator/AutoRest.CSharp.Tests/Swagger/swagger.2.0.example.v2.json',
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  },done
  return null

task 'regenerate-csazureallsync', '', (done) ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationAllSync': 'body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  },done
  return null

task 'regenerate-csazurefluentallsync', '', (done) ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationAllSync': 'body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  },done
  return null

task 'regenerate-csazurenosync', '', (done) ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationNoSync': 'body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  },done
  return null

task 'regenerate-csazurefluentnosync', '', (done) ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationNoSync': 'body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  },done
  return null

task 'regenerate-cscomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': compositeMappings,
    'modeler' : 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-csazurecomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-csazurefluentcomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-go', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Go.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': goMappings,
    'outputDir': 'src/tests/generated',
    'nsPrefix': ' ',
    'codeGenerator': 'Go'
  },done
  return null

task 'regenerate-samples', '', ['regenerate-samplesazure'],(done) ->
  count = 0
  content = cat "#{basefolder}/AutoRest.json"
  if (content.charCodeAt(0) == 0xFEFF)
    content = content.slice(1)
  autorestConfig = JSON.parse(content)
  for lang of autorestConfig.plugins
    if (!lang.match(/^Azure\..+/))
      count++
      regenExpected {
        'modeler': 'Swagger',
        'header': 'NONE',
        'outputBaseDir': "#{basefolder}/Samples/petstore/#{lang}",
        'inputBaseDir': 'Samples',
        'mappings': { '': ['petstore/petstore.json', 'Petstore'] },
        'nsPrefix': "Petstore",
        'outputDir': "",
        'codeGenerator': lang
      }, () => 
        count = count - 1
        return done() if count is 0
  return null

task 'regenerate-samplesazure', "regenerate Azure samples", (done) ->
  count = 0
task 'regenerate-samplesazure', '', (done) ->
  content = cat "#{basefolder}/AutoRest.json"
  if (content.charCodeAt(0) == 0xFEFF)
    content = content.slice(1)
  autorestConfig = JSON.parse(content)
  for lang of autorestConfig.plugins
   
    if (lang.match(/^Azure\.[^.]+$/))
      count++
      regenExpected {
        'modeler': 'Swagger',
        'header': 'NONE',
        'outputBaseDir': "#{basefolder}/Samples/azure-storage/#{lang}",
        'inputBaseDir': 'Samples',
        'mappings': { '': ['azure-storage/azure-storage.json', 'Petstore'] },
        'nsPrefix': "Petstore",
        'outputDir': "",
        'codeGenerator': lang
      },() => 
        count = count - 1
        return done() if count is 0 
  return null


task 'regenerate', "regenerate expected code for tests", ['regenerate-delete'], (done) ->
  run 'regenerate-cs',
      'regenerate-csazure'
      'regenerate-csazurefluent'
      'regenerate-node'
      'regenerate-nodeazure'
      'regenerate-ruby'
      'regenerate-rubyazure'
      'regenerate-python'
      'regenerate-pythonazure'
      'regenerate-samples'
      'regenerate-java'
      'regenerate-javaazure'
      'regenerate-javaazurefluent'
      'regenerate-go', done
  return null
  

task 'regenerate-delete', '', ->
  rm "-rf",
    'src/generator/AutoRest.CSharp.Tests/Expected'
    'src/generator/AutoRest.CSharp.Azure.Tests/Expected'
    'src/generator/AutoRest.CSharp.Azure.Fluent.Tests/Expected'
    'src/generator/AutoRest.Go.Tests/src/tests/generated'
    'src/generator/AutoRest.Java.Tests/src/main/java'
    'src/generator/AutoRest.Java.Azure.Tests/src/main/java'
    'src/generator/AutoRest.Java.Azure.Fluent.Tests/src/main/java'
    'src/generator/AutoRest.NodeJS.Tests/Expected'
    'src/generator/AutoRest.NodeJS.Azure.Tests/Expected'
    'src/generator/AutoRest.Python.Tests/Expected'
    'src/generator/AutoRest.Python.Azure.Tests/Expected'
