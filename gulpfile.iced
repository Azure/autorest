# set the base folder of this project
global.basefolder = "#{__dirname}"

# use our tweaked version of gulp with iced coffee.
require './src/local_modules/gulp.iced'

# tasks required for this build 
Tasks "dotnet"

# Settings
Import
  solution: "#{basefolder}/AutoRest.sln"
  packages: "#{basefolder}/packages"

  # which projects to care about
  projects:() ->
    source 'src/**/*.csproj'

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

task 'autorest', 'Runs AutoRest', -> 
  autorest process.argv.slice(3)

autorest = (args) ->
  console.log "AutoRest #{args.join(' ')}"
  exec "dotnet #{basefolder}/src/core/AutoRest/bin/Debug/netcoreapp1.0/AutoRest.dll #{args.join(' ')}"

# NOTE: probably wanna rename the 'test' task in dotnet.iced to something more specific

############################################### 
task 'test-node', 'runs NodeJS tests', ->
  exec "npm test", { cwd: './src/generator/AutoRest.NodeJS.Tests/' }
  exec "npm test", { cwd: './src/generator/AutoRest.NodeJS.Azure.Tests/' }

############################################### 
task 'test-python', 'runs Python tests', ->
  exec "tox", { cwd: './src/generator/AutoRest.Python.Tests/' }
  exec "tox", { cwd: './src/generator/AutoRest.Python.Azure.Tests/' }

############################################### 
task 'test-ruby', 'runs Ruby tests', ->
  exec "ruby RspecTests/tests_runner.rb", { cwd: './src/generator/AutoRest.Ruby.Tests/' }
  exec "ruby RspecTests/tests_runner.rb", { cwd: './src/generator/AutoRest.Ruby.Azure.Tests/' }

############################################### 
task 'test-go', 'runs Go tests', ['regenerate-go'], -> # FAILS, but also on master branch...
  exec "glide up",               { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }
  exec "go fmt ./generated/...", { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }
  exec "go run ./runner.go",     { cwd: './src/generator/AutoRest.Go.Tests/src/tests' }

############################################### 
# LEGACY 
# Instead: have bunch of configuration files sitting in a well-known spot, discover them, feed them to AutoRest, done.

regenExpected = (opts) ->
  outputDir = if !!opts.outputBaseDir then "#{opts.outputBaseDir}/#{opts.outputDir}" else opts.outputDir
  for key of opts.mappings
    optsMappingsValue = opts.mappings[key]
    mappingBaseDir = if optsMappingsValue instanceof Array then optsMappingsValue[0] else optsMappingsValue
    args = [
      '-SkipValidation',
      '-CodeGenerator', opts.codeGenerator,
      '-OutputDirectory', "#{outputDir}/#{key}",
      '-Input', (if !!opts.inputBaseDir then "#{opts.inputBaseDir}/#{mappingBaseDir}" else mappingBaseDir),
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
    autorest args

defaultMappings = {
  'AcceptanceTests/ParameterFlattening': '../../dev/TestServer/swagger/parameter-flattening.json',
  'AcceptanceTests/BodyArray': '../../dev/TestServer/swagger/body-array.json',
  'AcceptanceTests/BodyBoolean': '../../dev/TestServer/swagger/body-boolean.json',
  'AcceptanceTests/BodyByte': '../../dev/TestServer/swagger/body-byte.json',
  'AcceptanceTests/BodyComplex': '../../dev/TestServer/swagger/body-complex.json',
  'AcceptanceTests/BodyDate': '../../dev/TestServer/swagger/body-date.json',
  'AcceptanceTests/BodyDateTime': '../../dev/TestServer/swagger/body-datetime.json',
  'AcceptanceTests/BodyDateTimeRfc1123': '../../dev/TestServer/swagger/body-datetime-rfc1123.json',
  'AcceptanceTests/BodyDuration': '../../dev/TestServer/swagger/body-duration.json',
  'AcceptanceTests/BodyDictionary': '../../dev/TestServer/swagger/body-dictionary.json',
  'AcceptanceTests/BodyFile': '../../dev/TestServer/swagger/body-file.json',
  'AcceptanceTests/BodyFormData': '../../dev/TestServer/swagger/body-formdata.json',
  'AcceptanceTests/BodyInteger': '../../dev/TestServer/swagger/body-integer.json',
  'AcceptanceTests/BodyNumber': '../../dev/TestServer/swagger/body-number.json',
  'AcceptanceTests/BodyString': '../../dev/TestServer/swagger/body-string.json',
  'AcceptanceTests/Header': '../../dev/TestServer/swagger/header.json',
  'AcceptanceTests/Http': '../../dev/TestServer/swagger/httpInfrastructure.json',
  'AcceptanceTests/Report': '../../dev/TestServer/swagger/report.json',
  'AcceptanceTests/RequiredOptional': '../../dev/TestServer/swagger/required-optional.json',
  'AcceptanceTests/Url': '../../dev/TestServer/swagger/url.json',
  'AcceptanceTests/Validation': '../../dev/TestServer/swagger/validation.json',
  'AcceptanceTests/CustomBaseUri': '../../dev/TestServer/swagger/custom-baseUrl.json',
  'AcceptanceTests/CustomBaseUriMoreOptions': '../../dev/TestServer/swagger/custom-baseUrl-more-options.json',
  'AcceptanceTests/ModelFlattening': '../../dev/TestServer/swagger/model-flattening.json'
}

rubyMappings = {
  'boolean':['../../dev/TestServer/swagger/body-boolean.json', 'BooleanModule'],
  'integer':['../../dev/TestServer/swagger/body-integer.json','IntegerModule'],
  'number':['../../dev/TestServer/swagger/body-number.json','NumberModule'],
  'string':['../../dev/TestServer/swagger/body-string.json','StringModule'],
  'byte':['../../dev/TestServer/swagger/body-byte.json','ByteModule'],
  'array':['../../dev/TestServer/swagger/body-array.json','ArrayModule'],
  'dictionary':['../../dev/TestServer/swagger/body-dictionary.json','DictionaryModule'],
  'date':['../../dev/TestServer/swagger/body-date.json','DateModule'],
  'datetime':['../../dev/TestServer/swagger/body-datetime.json','DatetimeModule'],
  'datetime_rfc1123':['../../dev/TestServer/swagger/body-datetime-rfc1123.json','DatetimeRfc1123Module'],
  'duration':['../../dev/TestServer/swagger/body-duration.json','DurationModule'],
  'complex':['../../dev/TestServer/swagger/body-complex.json','ComplexModule'],
  'url':['../../dev/TestServer/swagger/url.json','UrlModule'],
  'url_items':['../../dev/TestServer/swagger/url.json','UrlModule'],
  'url_query':['../../dev/TestServer/swagger/url.json','UrlModule'],
  'header_folder':['../../dev/TestServer/swagger/header.json','HeaderModule'],
  'http_infrastructure':['../../dev/TestServer/swagger/httpInfrastructure.json','HttpInfrastructureModule'],
  'required_optional':['../../dev/TestServer/swagger/required-optional.json','RequiredOptionalModule'],
  'report':['../../dev/TestServer/swagger/report.json','ReportModule'],
  'model_flattening':['../../dev/TestServer/swagger/model-flattening.json', 'ModelFlatteningModule'],
  'parameter_flattening':['../../dev/TestServer/swagger/parameter-flattening.json', 'ParameterFlatteningModule'],
  'validation':['../../dev/TestServer/swagger/validation.json', 'ValidationModule'],
  'custom_base_uri':['../../dev/TestServer/swagger/custom-baseUrl.json', 'CustomBaseUriModule'],
  'custom_base_uri_more':['../../dev/TestServer/swagger/custom-baseUrl-more-options.json', 'CustomBaseUriMoreModule']
}

goMappings = {
  'body-array':['../../dev/TestServer/swagger/body-array.json','arraygroup'],
  'body-boolean':['../../dev/TestServer/swagger/body-boolean.json', 'booleangroup'],
  'body-byte':['../../dev/TestServer/swagger/body-byte.json','bytegroup'],
  'body-complex':['../../dev/TestServer/swagger/body-complex.json','complexgroup'],
  'body-date':['../../dev/TestServer/swagger/body-date.json','dategroup'],
  'body-datetime-rfc1123':['../../dev/TestServer/swagger/body-datetime-rfc1123.json','datetimerfc1123group'],
  'body-datetime':['../../dev/TestServer/swagger/body-datetime.json','datetimegroup'],
  'body-dictionary':['../../dev/TestServer/swagger/body-dictionary.json','dictionarygroup'],
  'body-duration':['../../dev/TestServer/swagger/body-duration.json','durationgroup'],
  'body-file':['../../dev/TestServer/swagger/body-file.json', 'filegroup'],
  'body-formdata':['../../dev/TestServer/swagger/body-formdata.json', 'formdatagroup'],
  'body-integer':['../../dev/TestServer/swagger/body-integer.json','integergroup'],
  'body-number':['../../dev/TestServer/swagger/body-number.json','numbergroup'],
  'body-string':['../../dev/TestServer/swagger/body-string.json','stringgroup'],
  'custom-baseurl':['../../dev/TestServer/swagger/custom-baseUrl.json', 'custombaseurlgroup'],
  'header':['../../dev/TestServer/swagger/header.json','headergroup'],
  'httpinfrastructure':['../../dev/TestServer/swagger/httpInfrastructure.json','httpinfrastructuregroup'],
  'model-flattening':['../../dev/TestServer/swagger/model-flattening.json', 'modelflatteninggroup'],
  'report':['../../dev/TestServer/swagger/report.json','report'],
  'required-optional':['../../dev/TestServer/swagger/required-optional.json','optionalgroup'],
  'url':['../../dev/TestServer/swagger/url.json','urlgroup'],
  'validation':['../../dev/TestServer/swagger/validation.json', 'validationgroup'],
  'paging':['../../dev/TestServer/swagger/paging.json', 'paginggroup'],
  'azurereport':['../../dev/TestServer/swagger/azure-report.json', 'azurereport']
}


defaultAzureMappings = {
  'AcceptanceTests/Lro': '../../dev/TestServer/swagger/lro.json',
  'AcceptanceTests/Paging': '../../dev/TestServer/swagger/paging.json',
  'AcceptanceTests/AzureReport': '../../dev/TestServer/swagger/azure-report.json',
  'AcceptanceTests/AzureParameterGrouping': '../../dev/TestServer/swagger/azure-parameter-grouping.json',
  'AcceptanceTests/AzureResource': '../../dev/TestServer/swagger/azure-resource.json',
  'AcceptanceTests/Head': '../../dev/TestServer/swagger/head.json',
  'AcceptanceTests/HeadExceptions': '../../dev/TestServer/swagger/head-exceptions.json',
  'AcceptanceTests/SubscriptionIdApiVersion': '../../dev/TestServer/swagger/subscriptionId-apiVersion.json',
  'AcceptanceTests/AzureSpecials': '../../dev/TestServer/swagger/azure-special-properties.json',
  'AcceptanceTests/CustomBaseUri': '../../dev/TestServer/swagger/custom-baseUrl.json'
}

compositeMappings = {
  'AcceptanceTests/CompositeBoolIntClient': '../../dev/TestServer/swagger/composite-swagger.json'
}

azureCompositeMappings = {
  'AcceptanceTests/AzureCompositeModelClient': '../../dev/TestServer/swagger/azure-composite-swagger.json'
}

nodeAzureMappings = {
  'AcceptanceTests/StorageManagementClient': '../../dev/TestServer/swagger/storage.json'
}

nodeMappings = {
  'AcceptanceTests/ComplexModelClient': '../../dev/TestServer/swagger/complex-model.json'
}

rubyAzureMappings = {
  'head':['../../dev/TestServer/swagger/head.json', 'HeadModule'],
  'head_exceptions':['../../dev/TestServer/swagger/head-exceptions.json', 'HeadExceptionsModule'],
  'paging':['../../dev/TestServer/swagger/paging.json', 'PagingModule'],
  'azure_resource':['../../dev/TestServer/swagger/azure-resource.json', 'AzureResourceModule'],
  'lro':['../../dev/TestServer/swagger/lro.json', 'LroModule'],
  'azure_url':['../../dev/TestServer/swagger/subscriptionId-apiVersion.json', 'AzureUrlModule'],
  'azure_special_properties': ['../../dev/TestServer/swagger/azure-special-properties.json', 'AzureSpecialPropertiesModule'],
  'azure_report':['../../dev/TestServer/swagger/azure-report.json', 'AzureReportModule'],
  'parameter_grouping':['../../dev/TestServer/swagger/azure-parameter-grouping.json', 'ParameterGroupingModule']
}

mergeOptions = (obj1, obj2) ->
  obj3 = {}
  for attrname of obj1
    obj3[attrname] = obj1[attrname]
  for attrname of obj2
    obj3[attrname] = obj2[attrname]
  return obj3

task 'regenerate-nodecomposite', "regenerate expected composite swaggers for NodeJS", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'mappings': compositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }

task 'regenerate-nodeazurecomposite', "regenerate expected composite swaggers for NodeJS Azure", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }

task 'regenerate-nodeazure', "regenerate expected swaggers for NodeJS Azure", ['regenerate-nodeazurecomposite'], ->
  for p of defaultAzureMappings
    nodeAzureMappings[p] = defaultAzureMappings[p]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': nodeAzureMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'flatteningThreshold': '1'
  }

task 'regenerate-node', "regenerate expected swaggers for NodeJS", ['regenerate-nodecomposite'], ->
  for p of defaultMappings
    nodeMappings[p] = defaultMappings[p]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': nodeMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'flatteningThreshold': '1'
  }

task 'regenerate-python', "regenerate expected swaggers for Python", ->
  mappings = mergeOptions({ 
    'AcceptanceTests/UrlMultiCollectionFormat' : '../../dev/TestServer/swagger/url-multi-collectionFormat.json'
  }, defaultMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Python.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Python',
    'flatteningThreshold': '1'
  }

task 'regenerate-pythonazure', "regenerate expected swaggers for Python Azure", ->
  mappings = mergeOptions({ 
    'AcceptanceTests/AzureBodyDuration': '../../dev/TestServer/swagger/body-duration.json',
    'AcceptanceTests/StorageManagementClient': '../../dev/TestServer/swagger/storage.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Python.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.Python',
    'flatteningThreshold': '1'
  }

task 'regenerate-rubyazure', "regenerate expected swaggers for Ruby Azure", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': rubyAzureMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Azure.Ruby',
    'nsPrefix': 'MyNamespace'
  }

task 'regenerate-ruby', "regenerate expected swaggers for Ruby", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': rubyMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Ruby',
    'nsPrefix': 'MyNamespace'
  }

task 'regenerate-javaazure', "regenerate expected swaggers for Java Azure", ->
  mappings = {};
  for key of defaultAzureMappings
    mappings[key.substring(16).toLowerCase()] = defaultAzureMappings[key]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Java.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java',
    'nsPrefix': 'Fixtures'
  }

task 'regenerate-javaazurefluent', "regenerate expected swaggers for Java Azure Fluent", ->
  mappings = {};
  for key of defaultAzureMappings
    mappings[key.substring(16).toLowerCase()] = defaultAzureMappings[key]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Java.Azure.Fluent.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java.Fluent',
    'nsPrefix': 'Fixtures'
  }

task 'regenerate-java', "regenerate expected swaggers for Java", ->
  mappings = {};
  for key of defaultMappings
    mappings[key.substring(16).toLowerCase()] = defaultMappings[key]
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Java.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Java',
    'nsPrefix': 'Fixtures'
  }

task 'regenerate-csazure', "regenerate expected swaggers for C# Azure", ['regenerate-csazurecomposite','regenerate-csazureallsync', 'regenerate-csazurenosync'], ->
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': '../../dev/TestServer/swagger/body-duration.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  }

task 'regenerate-csazurefluent', "regenerate expected swaggers for C# Azure Fluent", ['regenerate-csazurefluentcomposite','regenerate-csazurefluentallsync', 'regenerate-csazurefluentnosync'], ->
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': '../../dev/TestServer/swagger/body-duration.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  }

task 'regenerate-cs', "regenerate expected swaggers for C#", ['regenerate-cswithcreds', 'regenerate-cscomposite', 'regenerate-csallsync', 'regenerate-csnosync'], ->
  mappings = mergeOptions({
    'Mirror.RecursiveTypes': 'Swagger/swagger-mirror-recursive-type.json',
    'Mirror.Primitives': 'Swagger/swagger-mirror-primitives.json',
    'Mirror.Sequences': 'Swagger/swagger-mirror-sequences.json',
    'Mirror.Polymorphic': 'Swagger/swagger-mirror-polymorphic.json',
    'Internal.Ctors': 'Swagger/swagger-internal-ctors.json',
    'Additional.Properties': 'Swagger/swagger-additional-properties.yaml',
    'DateTimeOffset': 'Swagger/swagger-datetimeoffset.json',
    'AcceptanceTests/UrlMultiCollectionFormat' : '../../dev/TestServer/swagger/url-multi-collectionFormat.json'
  }, defaultMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }

task 'regenerate-cswithcreds', "regenerate expected swaggers for C# with credentials", ->
  mappings = {
    'PetstoreV2': 'Swagger/swagger.2.0.example.v2.json',
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'addCredentials': true
  }

task 'regenerate-csallsync', "regenerate expected swaggers for C# with all synchronous methods", ->
  mappings = {
    'PetstoreV2AllSync': 'Swagger/swagger.2.0.example.v2.json',
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  }

task 'regenerate-csnosync', "regenerate expected swaggers for C# with no synchronous methods", ->
  mappings = {
    'PetstoreV2NoSync': 'Swagger/swagger.2.0.example.v2.json',
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  }

task 'regenerate-csazureallsync', "regenerate expected swaggers for C# Azure with all synchronous methods", ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationAllSync': '../../dev/TestServer/swagger/body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  }

task 'regenerate-csazurefluentallsync', "regenerate expected swaggers for C# Azure Fluent with all synchronous methods", ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationAllSync': '../../dev/TestServer/swagger/body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  }

task 'regenerate-csazurenosync', "regenerate expected swaggers for C# Azure with no synchronous methods", ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationNoSync': '../../dev/TestServer/swagger/body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  }

task 'regenerate-csazurefluentnosync', "regenerate expected swaggers for C# Azure Fluent with no synchronous methods", ->
  mappings = {
    'AcceptanceTests/AzureBodyDurationNoSync': '../../dev/TestServer/swagger/body-duration.json'
  }
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  }

task 'regenerate-cscomposite', "regenerate expected composite swaggers for C#", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': compositeMappings,
    'modeler' : 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }

task 'regenerate-csazurecomposite', "regenerate expected composite swaggers for C# Azure", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }

task 'regenerate-csazurefluentcomposite', "regenerate expected composite swaggers for C# Azure Fluent", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp.Fluent',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }

task 'regenerate-go', "regenerate expected swaggers for Go", ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Go.Tests',
    'inputBaseDir': 'src/generator/AutoRest.Go.Tests',
    'mappings': goMappings,
    'outputDir': 'src/tests/generated',
    'codeGenerator': 'Go'
  }
  process.env.GOPATH = __dirname + '/src/generator/AutoRest.Go.Tests'

task 'regenerate-samples', "regenerate samples", ['regenerate-samples:azure'], ->
  autorestConfigPath = "#{basefolder}/AutoRest.json"
  content = fs.readFileSync(autorestConfigPath).toString()
  if (content.charCodeAt(0) == 0xFEFF)
    content = content.slice(1);
  autorestConfig = JSON.parse(content)
  for lang of autorestConfig.plugins
    if (!lang.match(/^Azure\..+/))
      regenExpected {
        'modeler': 'Swagger',
        'Header': 'NONE',
        'outputBaseDir': "#{basefolder}/Samples/petstore/#{lang}",
        'inputBaseDir': 'Samples',
        'mappings': { '': 'petstore/petstore.json' },
        'mappings': { '': ['petstore/petstore.json', 'Petstore'] },
        'nsPrefix': "",
        'outputDir': 'src/tests/generated',
        'codeGenerator': lang
      }

task 'regenerate-samples:azure', "regenerate Azure samples", ->
  autorestConfigPath = "#{basefolder}/AutoRest.json"
  content = fs.readFileSync(autorestConfigPath).toString()
  if (content.charCodeAt(0) == 0xFEFF)
    content = content.slice(1);
  autorestConfig = JSON.parse(content)
  for lang of autorestConfig.plugins
    if (!lang.match(/^Azure\..+/))
      regenExpected {
        'modeler': 'Swagger',
        'Header': 'NONE',
        'outputBaseDir': "#{basefolder}/Samples/azure-storage/#{lang}",
        'inputBaseDir': 'Samples',
        'mappings': { '': ['petstore/azure-storage/azure-storage.json', 'Petstore'] },
        'nsPrefix': "",
        'outputDir': 'src/tests/generated',
        'codeGenerator': lang
      }

task 'regenerate', "regenerate expected code for tests", ['regenerate-delete'], ->
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
      'regenerate-go'
      -> done()

task 'regenerate-delete', "regenerate expected code for tests", ->
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
  done()