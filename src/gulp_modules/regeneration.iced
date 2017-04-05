
###############################################
# LEGACY 
# Instead: have bunch of configuration files sitting in a well-known spot, discover them, feed them to AutoRest, done.

regenExpected = (opts,done) ->
  outputDir = if !!opts.outputBaseDir then "#{opts.outputBaseDir}/#{opts.outputDir}" else opts.outputDir
  instances = 0    

  for key of opts.mappings
    instances++

    optsMappingsValue = opts.mappings[key]
    swaggerFiles = (if optsMappingsValue instanceof Array then optsMappingsValue[0] else optsMappingsValue).split(";")
    args = [
      '--skip-validation=true',
      "--#{opts.language}",
      "--output-folder=#{outputDir}/#{key}",
      "--license-header=#{if !!opts.header then opts.header else 'MICROSOFT_MIT_NO_VERSION'}"
    ]

    for swaggerFile in swaggerFiles
      args.push("--input-file=#{if !!opts.inputBaseDir then "#{opts.inputBaseDir}/#{swaggerFile}" else swaggerFile}")

    if (opts.addCredentials)
      args.push('--add-credentials=true')

    if (opts.azureArm)
      args.push('--azure-arm=true')

    if (opts.fluent)
      args.push('--fluent=true')
    
    if (opts.syncMethods)
      args.push("--sync-methods=#{opts.syncMethods}")
    
    if (opts.flatteningThreshold)
      args.push("--payload-flattening-threshold=#{opts.flatteningThreshold}")

    if (!!opts.nsPrefix)
      if (optsMappingsValue instanceof Array && optsMappingsValue[1] != undefined)
        args.push("--namespace=#{optsMappingsValue[1]}")
      else
        args.push("--namespace=#{[opts.nsPrefix, key.replace(/\/|\./, '')].join('.')}")

    if (opts['override-info.version'])
      args.push("--override-info.version=#{opts['override-info.version']}")
    if (opts['override-info.title'])
      args.push("--override-info.title=#{opts['override-info.title']}")
    if (opts['override-info.description'])
      args.push("--override-info.description=#{opts['override-info.description']}")

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
  'AcceptanceTests/CompositeBoolIntClient': 'body-boolean.json;body-integer.json'
}

azureCompositeMappings = {
  'AcceptanceTests/AzureCompositeModelClient': 'complex-model.json;body-complex.json'
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

task 'regenerate-nodecomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': compositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'language': 'nodejs',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'override-info.title': "Composite Bool Int",
    'override-info.description': "Composite Swagger Client that represents merging body boolean and body integer swagger clients"
  },done
  return null

task 'regenerate-nodeazurecomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'language': 'nodejs',
    'azureArm': true,
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'override-info.version': "1.0.0",
    'override-info.title': "Azure Composite Model",
    'override-info.description': "Composite Swagger Client that represents merging body complex and complex model swagger clients"
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
    'language': 'nodejs',
    'azureArm': true,
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
    'language': 'nodejs',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-python', '', (done) ->
  mappings = Object.assign({ 
    'AcceptanceTests/UrlMultiCollectionFormat' : 'url-multi-collectionFormat.json'
  }, defaultMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Python.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'nsPrefix': "Fixtures"
    'outputDir': 'Expected',
    'language': 'python',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-pythonazure', '', (done) ->
  mappings = Object.assign({ 
    'AcceptanceTests/AzureBodyDuration': 'body-duration.json',
    'AcceptanceTests/StorageManagementClient': 'storage.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Python.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'nsPrefix': "Fixtures"
    'outputDir': 'Expected',
    'language': 'python',
    'azureArm': true,
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-rubyazure', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': rubyAzureMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
    'azureArm': true,
    'nsPrefix': 'MyNamespace'
  },done
  return null

task 'regenerate-ruby', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': rubyMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
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
    'language': 'java',
    'azureArm': true,
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
    'language': 'java',
    'azureArm': true,
    'fluent': true,
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
    'language': 'java',
    'nsPrefix': 'Fixtures'
  },done
  return null

task 'regenerate-csazure', '', ['regenerate-csazurecomposite','regenerate-csazureallsync', 'regenerate-csazurenosync'], (done) ->
  mappings = Object.assign({
    'AcceptanceTests/AzureBodyDuration': 'body-duration.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'language': 'csharp',
    'azureArm': true,
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-csazurefluent', '', ['regenerate-csazurefluentcomposite','regenerate-csazurefluentallsync', 'regenerate-csazurefluentnosync'], (done) ->
  mappings = Object.assign({
    'AcceptanceTests/AzureBodyDuration': 'body-duration.json'
  }, defaultAzureMappings)
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': mappings,
    'outputDir': 'Expected',
    'language': 'csharp',
    'azureArm': true,
    'fluent': true,
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  },done
  return null

task 'regenerate-cs', '', ['regenerate-cswithcreds', 'regenerate-cscomposite', 'regenerate-csallsync', 'regenerate-csnosync'], (done) ->
  mappings = Object.assign({
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
    'language': 'csharp',
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
    'language': 'csharp',
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
    'language': 'csharp',
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
    'language': 'csharp',
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
    'language': 'csharp',
    'azureArm': true,
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
    'language': 'csharp',
    'azureArm': true,
    'fluent': true,
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
    'language': 'csharp',
    'azureArm': true,
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
    'language': 'csharp',
    'azureArm': true,
    'fluent': true,
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
    'language': 'csharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'override-info.title': "Composite Bool Int",
    'override-info.description': "Composite Swagger Client that represents merging body boolean and body integer swagger clients"
  },done
  return null

task 'regenerate-csazurecomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'language': 'csharp',
    'azureArm': true,
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'override-info.version': "1.0.0",
    'override-info.title': "Azure Composite Model",
    'override-info.description': "Composite Swagger Client that represents merging body complex and complex model swagger clients"
  },done
  return null

task 'regenerate-csazurefluentcomposite', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Fluent.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'language': 'csharp',
    'azureArm': true,
    'fluent': true,
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'override-info.version': "1.0.0",
    'override-info.title': "Azure Composite Model",
    'override-info.description': "Composite Swagger Client that represents merging body complex and complex model swagger clients"
  },done
  return null

task 'regenerate-go', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.Go.Tests',
    'inputBaseDir': 'src/dev/TestServer/swagger',
    'mappings': goMappings,
    'outputDir': 'src/tests/generated',
    'nsPrefix': ' ',
    'language': 'go'
  },done
  return null

task 'regenerate-ars', '', (done) ->
  regenExpected {
    'outputBaseDir': 'src/generator/AutoRest.AzureResourceSchema.Tests',
    'inputBaseDir': 'src/generator/AutoRest.AzureResourceSchema.Tests/Resource/Swagger',
    'mappings': {
      'ApiManagement/2016-07-07':'ApiManagement/2016-07-07/apimanagement.json',
      'ApiManagement/2016-07-07b':'ApiManagement/2016-07-07b/apimanagement.json',
      'Batch/2015-12-01':'Batch/2015-12-01/BatchManagement.json',
      'CDN/2015-06-01':'CDN/2015-06-01/cdn.json',
      'CDN/2016-04-02':'CDN/2016-04-02/cdn.json',
      'CognitiveServices/2016-02-01-preview':'CognitiveServices/2016-02-01-preview/cognitiveservices.json',
      'CommitmentPlans/2016-05-01-preview':'CommitmentPlans/2016-05-01-preview/commitmentPlans.json',
      'Compute/2015-06-15':'Compute/2015-06-15/compute.json',
      'Compute/2016-03-30':'Compute/2016-03-30/compute.json',
      'Compute/2016-03-30b':'Compute/2016-03-30b/compute.json',
      'ContainerService/2016-03-30':'ContainerService/2016-03-30/containerService.json',
      'DataLakeAnalytics/2015-10-01-preview':'DataLakeAnalytics/2015-10-01-preview/account.json',
      'DataLakeStore/2015-10-01-preview':'DataLakeStore/2015-10-01-preview/account.json',
      'DevTestLabs/2015-05-21-preview':'DevTestLabs/2015-05-21-preview/DTL.json',
      'DNS/2015-05-04-preview':'DNS/2015-05-04-preview/dns.json',
      'DNS/2016-04-01':'DNS/2016-04-01/dns.json',
      'Insights/2016-03-01':'Insights/2016-03-01/insightsManagementClient.json',
      'Logic/2015-02-01-preview':'Logic/2015-02-01-preview/logic.json',
      'Logic/2016-06-01':'Logic/2016-06-01/logic.json',
      'MachineLearning/2016-05-01-preview':'MachineLearning/2016-05-01-preview/webservices.json',
      'MobileEngagement/2014-12-01':'MobileEngagement/2014-12-01/mobile-engagement.json',
      'Network/2015-05-01-preview':'Network/2015-05-01-preview/network.json',
      'Network/2015-06-15':'Network/2015-06-15/network.json',
      'Network/2016-03-30':'Network/2016-03-30/network.json',
      'Network/2016-09-01':'Network/2016-09-01/network.json',
      'NotificationHubs/2016-03-01':'NotificationHubs/2016-03-01/notificationhubs.json',
      'PowerBIEmbedded/2016-01-29':'PowerBIEmbedded/2016-01-29/powerbiembedded.json',
      'RecoveryServices/2016-06-01':'RecoveryServices/2016-06-01/recoveryservices.json',
      'Redis/2016-04-01':'Redis/2016-04-01/redis.json',
      'Resources/Locks/2016-09-01':'Resources/Locks/2016-09-01/locks.json',
      'Resources/Resources/2016-09-01':'Resources/Resources/2016-09-01/resources.json',
      'Scheduler/2016-03-01':'Scheduler/2016-03-01/scheduler.json',
      'Search/2015-02-28':'Search/2015-02-28/search.json',
      'ServerManagement/2016-07-01-preview':'ServerManagement/2016-07-01-preview/servermanagement.json',
      'ServiceBus/2015-08-01':'ServiceBus/2015-08-01/servicebus.json',
      'Storage/2015-05-01-preview':'Storage/2015-05-01-preview/storage.json',
      'Storage/2015-06-15':'Storage/2015-06-15/storage.json',
      'Storage/2016-01-01':'Storage/2016-01-01/storage.json',
      'TrafficManager/2015-11-01':'TrafficManager/2015-11-01/trafficmanager.json',
      'Web/2015-08-01':'Web/2015-08-01/web.json'
    },
    'outputDir': 'Resource/Expected',
    'language': 'azureresourceschema'
  },done
  return null

task 'regenerate-samples', '', ['regenerate-samplesazure', 'regenerate-samplesazurefluent'],(done) ->
  count = 0
  for lang in ['CSharp', 'Java', 'Python', 'NodeJS', 'Ruby', 'Go', 'AzureResourceSchema']
    count++
    regenExpected {
      'modeler': 'Swagger',
      'header': 'NONE',
      'outputBaseDir': "#{basefolder}/Samples/petstore/#{lang}",
      'inputBaseDir': 'Samples',
      'mappings': { '': ['petstore/petstore.json', 'Petstore'] },
      'nsPrefix': "Petstore",
      'outputDir': "",
      'language': lang.toLowerCase()
    }, () => 
      count = count - 1
      return done() if count is 0
  return null

task 'regenerate-samplesazure', '', (done) ->
  count = 0
  for lang in ['CSharp', 'Java', 'Python', 'NodeJS', 'Ruby']
    count++
    regenExpected {
      'modeler': 'Swagger',
      'header': 'NONE',
      'outputBaseDir': "#{basefolder}/Samples/azure-storage/Azure.#{lang}",
      'inputBaseDir': 'Samples',
      'mappings': { '': ['azure-storage/azure-storage.json', 'Petstore'] },
      'nsPrefix': "Petstore",
      'outputDir': "",
      'azureArm': true,
      'language': lang.toLowerCase()
    },() => 
      count = count - 1
      return done() if count is 0 
  return null

task 'regenerate-samplesazurefluent', '', (done) ->
  count = 0
  for lang in ['CSharp', 'Java']
    count++
    regenExpected {
      'modeler': 'Swagger',
      'header': 'NONE',
      'outputBaseDir': "#{basefolder}/Samples/azure-storage/Azure.#{lang}.Fluent",
      'inputBaseDir': 'Samples',
      'mappings': { '': ['azure-storage/azure-storage.json', 'Petstore'] },
      'nsPrefix': "Petstore",
      'outputDir': "",
      'azureArm': true,
      'fluent': true,
      'language': lang.toLowerCase()
    },() => 
      count = count - 1
      return done() if count is 0 
  return null

task 'regenerate-samples2', '', (done) ->
  source 'Samples/**/readme.md'
    .pipe foreach (each,next)->
      autorest [each.path], ->
        next null 
  return null

task 'regenerate', "regenerate expected code for tests", ['regenerate-delete'], (done) ->
  run ['regenerate-ars',
      'regenerate-cs'
      'regenerate-csazure'
      'regenerate-csazurefluent'
      'regenerate-go'
      'regenerate-java'
      'regenerate-javaazure'
      'regenerate-javaazurefluent'
      'regenerate-node'
      'regenerate-nodeazure'
      'regenerate-python'
      'regenerate-pythonazure'
      'regenerate-ruby'
      'regenerate-rubyazure'
      'regenerate-samples'], done
  return null
  

path = require('path')

task 'regenerate-delete', '', (done)->
  source 'Samples/*/**/'
    .pipe foreach (each, next) ->
      configFile = path.join(each.path, "../readme.md")
      console.log "rm -rf '#{each.path}" if fs.existsSync configFile
      # execute "rm -rf '#{each.path}" if fs.existsSync configFile
      next null
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
    'src/generator/AutoRest.AzureResourceSchema.Tests/Resource/Expected'
  echo typeof done
  done()

task 'autorest-preview-build', '', ->
  exec "dotnet build #{basefolder}/src/dev/AutoRest.Preview/"

task 'autorest-preview', '', ->
  exec "#{basefolder}/src/dev/AutoRest.Preview/bin/Debug/net461/AutoRest.Preview.exe", {cwd: "./src/dev/AutoRest.Preview"}