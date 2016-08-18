/// <binding Clean='clean' />
var gulp = require('gulp'),
msbuild = require('gulp-msbuild'),
debug = require('gulp-debug'),
env = require('gulp-env'),
path = require('path'),
fs = require('fs'),
merge = require('merge2'),
shell = require('gulp-shell'),
glob = require('glob'),
spawn = require('child_process').spawn,
assemblyInfo = require('gulp-dotnet-assembly-info'),
nuspecSync = require('./Tools/gulp/gulp-nuspec-sync'),
runtimeVersionSync = require('./Tools/gulp/gulp-runtime-version-sync'),
nugetProjSync = require('./Tools/gulp/gulp-nuget-proj-sync'),
regenExpected = require('./Tools/gulp/gulp-regenerate-expected'),
del = require('del'),
gutil = require('gulp-util'),
runSequence = require('run-sequence'),
requireDir = require('require-dir')('./Tools/gulp'),
exec = require('child_process').exec;

const DEFAULT_ASSEMBLY_VERSION = '0.9.0.0';
const MAX_BUFFER = 1024 * 4096;
var isWindows = (process.platform.lastIndexOf('win') === 0);
var isLinux= (process.platform.lastIndexOf('linux') === 0);
var isMac = (process.platform.lastIndexOf('darwin') === 0);

process.env.MSBUILDDISABLENODEREUSE = 1;

function GetAutoRestFolder() {
  if (isWindows) {
    return "src/core/AutoRest/bin/Debug/net451/win7-x64/";
  }
  if( isMac ) {
	return "src/core/AutoRest/bin/Debug/net451/osx.10.11-x64/";
  } 
  if( isLinux ) { 
	return "src/core/AutoRest/bin/Debug/net451/ubuntu.14.04-x64/"
  }
   throw new Error("Unknown platform?");
}
function basePathOrThrow() {
  if (!gutil.env.basePath) {
    return __dirname;
  }
  return gutil.env.basePath;
}

function mergeOptions(obj1,obj2){
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
}

var defaultMappings = {
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
};

var rubyMappings = {
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
};

var goMappings = {
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
};

var defaultAzureMappings = {
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
};

var compositeMappings = {
  'AcceptanceTests/CompositeBoolIntClient': '../../dev/TestServer/swagger/composite-swagger.json'
};

var azureCompositeMappings = {
  'AcceptanceTests/AzureCompositeModelClient': '../../dev/TestServer/swagger/azure-composite-swagger.json'
};

var nodeAzureMappings = {
  'AcceptanceTests/StorageManagementClient': '../../dev/TestServer/swagger/storage.json'
};

var nodeMappings = {
  'AcceptanceTests/ComplexModelClient': '../../dev/TestServer/swagger/complex-model.json'
};

var rubyAzureMappings = {
'head':['../../dev/TestServer/swagger/head.json', 'HeadModule'],
  'head_exceptions':['../../dev/TestServer/swagger/head-exceptions.json', 'HeadExceptionsModule'],
  'paging':['../../dev/TestServer/swagger/paging.json', 'PagingModule'],
  'azure_resource':['../../dev/TestServer/swagger/azure-resource.json', 'AzureResourceModule'],
  'lro':['../../dev/TestServer/swagger/lro.json', 'LroModule'],
  'azure_url':['../../dev/TestServer/swagger/subscriptionId-apiVersion.json', 'AzureUrlModule'],
  'azure_special_properties': ['../../dev/TestServer/swagger/azure-special-properties.json', 'AzureSpecialPropertiesModule'],
  'azure_report':['../../dev/TestServer/swagger/azure-report.json', 'AzureReportModule'],
  'parameter_grouping':['../../dev/TestServer/swagger/azure-parameter-grouping.json', 'ParameterGroupingModule']
};

gulp.task('regenerate:expected', function(cb){
  runSequence('regenerate:delete',
    [
      'regenerate:expected:csazure',
      'regenerate:expected:cs',
      'regenerate:expected:node',
      'regenerate:expected:nodeazure',
      'regenerate:expected:ruby',
      'regenerate:expected:rubyazure',
      'regenerate:expected:java',
      'regenerate:expected:javaazure',
      'regenerate:expected:javaazurefluent',
      'regenerate:expected:python',
      'regenerate:expected:pythonazure',
      'regenerate:expected:samples',
      'regenerate:expected:go'
    ],
    cb);
});

gulp.task('regenerate:delete', function(cb){
  del([
    'src/generator/AutoRest.CSharp.Azure.Tests/Expected',
    'src/generator/AutoRest.CSharp.Tests/Expected',
    'src/generator/AutoRest.NodeJS.Tests/Expected',
    'src/generator/AutoRest.NodeJS.Azure.Tests/Expected',
    'src/generator/AutoRest.Java.Tests/src/main/java',
    'src/generator/AutoRest.Java.Azure.Tests/src/main/java',
    'src/generator/AutoRest.Java.Azure.Fluent.Tests/src/main/java',
    'src/generator/AutoRest.Python.Tests/Expected',
    'src/generator/AutoRest.Python.Azure.Tests/Expected',
    'src/generator/AutoRest.Go.Tests/src/tests/generated'
  ], 
  cb);
});

gulp.task('regenerate:expected:nodecomposite', function (cb) {
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'mappings': compositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }, cb);
});

gulp.task('regenerate:expected:nodeazurecomposite', function (cb) {
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }, cb);
});

gulp.task('regenerate:expected:nodeazure', ['regenerate:expected:nodeazurecomposite'], function (cb) {
  for (var p in defaultAzureMappings) {
    nodeAzureMappings[p] = defaultAzureMappings[p];
  }

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': nodeAzureMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'flatteningThreshold': '1'
  }, cb);
})

gulp.task('regenerate:expected:node', ['regenerate:expected:nodecomposite'], function (cb) {
  for (var p in defaultMappings) {
    nodeMappings[p] = defaultMappings[p];
  }
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.NodeJS.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': nodeMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'flatteningThreshold': '1'
  }, cb);
})

gulp.task('regenerate:expected:python', function(cb){
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Python.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': defaultMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Python',
    'flatteningThreshold': '1'
  }, cb);
})

gulp.task('regenerate:expected:pythonazure', function(cb){
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': '../../dev/TestServer/swagger/body-duration.json',
    'AcceptanceTests/StorageManagementClient': '../../dev/TestServer/swagger/storage.json'
  }, defaultAzureMappings);

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Python.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.Python',
    'flatteningThreshold': '1'
  }, cb);
})

gulp.task('regenerate:expected:rubyazure', function(cb){
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': rubyAzureMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Azure.Ruby',
    'nsPrefix': 'MyNamespace'
  }, cb);
})

gulp.task('regenerate:expected:ruby', function(cb){
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Ruby.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': rubyMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Ruby',
    'nsPrefix': 'MyNamespace'
  }, cb);
})

gulp.task('regenerate:expected:javaazure', function(cb){
  mappings = {};
  for (var key in defaultAzureMappings) {
    mappings[key.substring(16).toLowerCase()] = defaultAzureMappings[key];
  }
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Java.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java',
    'nsPrefix': 'Fixtures'
  }, cb);
})

gulp.task('regenerate:expected:javaazurefluent', function(cb){
  mappings = {};
  for (var key in defaultAzureMappings) {
    mappings[key.substring(16).toLowerCase()] = defaultAzureMappings[key];
  }
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Java.Azure.Fluent.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java.Fluent',
    'nsPrefix': 'Fixtures'
  }, cb);
})

gulp.task('regenerate:expected:java', function(cb){
  mappings = {};
  for (var key in defaultMappings) {
    mappings[key.substring(16).toLowerCase()] = defaultMappings[key];
  }
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Java.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Java',
    'nsPrefix': 'Fixtures'
  }, cb);
})

gulp.task('regenerate:expected:csazure', ['regenerate:expected:csazurecomposite','regenerate:expected:csazureallsync', 'regenerate:expected:csazurenosync'], function (cb) {
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': '../../dev/TestServer/swagger/body-duration.json'
  }, defaultAzureMappings);

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  }, cb);
});

gulp.task('regenerate:expected:cs', ['regenerate:expected:cswithcreds', 'regenerate:expected:cscomposite', 'regenerate:expected:csallsync', 'regenerate:expected:csnosync'], function (cb) {
  mappings = mergeOptions({
    'Mirror.RecursiveTypes': 'Swagger/swagger-mirror-recursive-type.json',
    'Mirror.Primitives': 'Swagger/swagger-mirror-primitives.json',
    'Mirror.Sequences': 'Swagger/swagger-mirror-sequences.json',
    'Mirror.Polymorphic': 'Swagger/swagger-mirror-polymorphic.json',
    'Internal.Ctors': 'Swagger/swagger-internal-ctors.json',
    'Additional.Properties': 'Swagger/swagger-additional-properties.yaml',
    'DateTimeOffset': 'Swagger/swagger-datetimeoffset.json',
    'AcceptanceTests/UrlMultiCollectionFormat' : '../../dev/TestServer/swagger/url-multi-collectionFormat.json'
  }, defaultMappings);

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }, cb);
});
 
gulp.task('regenerate:expected:cswithcreds', function(cb){  
  mappings = mergeOptions(
  {
    'PetstoreV2': 'Swagger/swagger.2.0.example.v2.json',
  });

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'addCredentials': true
  }, cb);
});

gulp.task('regenerate:expected:csallsync', function(cb){    
  mappings = mergeOptions(
  {
    'PetstoreV2AllSync': 'Swagger/swagger.2.0.example.v2.json',
  });

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  }, cb);
});

gulp.task('regenerate:expected:csnosync', function(cb){  
  mappings = mergeOptions(
  {
    'PetstoreV2NoSync': 'Swagger/swagger.2.0.example.v2.json',
  });

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  }, cb);
});

gulp.task('regenerate:expected:csazureallsync', function(cb){    
  mappings = mergeOptions(
  {
    'AcceptanceTests/AzureBodyDurationAllSync': '../../dev/TestServer/swagger/body-duration.json'
  });

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'all'
  }, cb);
});

gulp.task('regenerate:expected:csazurenosync', function(cb){  
  mappings = mergeOptions(
  {
    'AcceptanceTests/AzureBodyDurationNoSync': '../../dev/TestServer/swagger/body-duration.json'
  });

  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1',
    'syncMethods': 'none'
  }, cb);
});

gulp.task('regenerate:expected:cscomposite', function (cb) {
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Tests',
    'mappings': compositeMappings,
    'modeler' : 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }, cb);
});

gulp.task('regenerate:expected:csazurecomposite', function (cb) {
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'inputBaseDir': 'src/generator/AutoRest.CSharp.Azure.Tests',
    'mappings': azureCompositeMappings,
    'modeler': 'CompositeSwagger',
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }, cb);
});


gulp.task('regenerate:expected:go', function(cb){
  regenExpected({
    'outputBaseDir': 'src/generator/AutoRest.Go.Tests',
    'inputBaseDir': 'src/generator/AutoRest.Go.Tests',
    'mappings': goMappings,
    'outputDir': 'src/tests/generated',
    'codeGenerator': 'Go'
  }, cb);
  process.env.GOPATH = __dirname + '/src/generator/AutoRest.Go.Tests';
})

gulp.task('regenerate:expected:samples', ['regenerate:expected:samples:azure'], function(){
  var autorestConfigPath = path.join(basePathOrThrow(), GetAutoRestFolder() + 'AutoRest.json');
  var content = fs.readFileSync(autorestConfigPath).toString();
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  var autorestConfig = JSON.parse(content);
  for (var lang in autorestConfig.codeGenerators) {
    if (!lang.match(/^Azure\..+/)) {
      var generateCmd = path.join(basePathOrThrow(), GetAutoRestFolder() + 'AutoRest.exe') + ' -Modeler Swagger -CodeGenerator ' + lang + ' -OutputDirectory ' + path.join(basePathOrThrow(), 'Samples/petstore/' + lang) + ' -Namespace Petstore -Input ' + path.join(basePathOrThrow(), 'Samples/petstore/petstore.json') + ' -Header NONE';
      exec(clrCmd(generateCmd), function(err, stdout, stderr) {
        console.log(stdout);
        console.error(stderr);
      });
    } 
  }
});

gulp.task('regenerate:expected:samples:azure', function(){
  var autorestConfigPath = path.join(basePathOrThrow(), GetAutoRestFolder() + 'AutoRest.json');
  var content = fs.readFileSync(autorestConfigPath).toString();
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  var autorestConfig = JSON.parse(content);
  for (var lang in autorestConfig.codeGenerators) {
    if (lang.match(/^Azure\..+/)) {
      var generateCmd = path.join(basePathOrThrow(), GetAutoRestFolder() + 'AutoRest.exe') + ' -Modeler Swagger -CodeGenerator ' + lang + ' -OutputDirectory ' + path.join(basePathOrThrow(), 'Samples/azure-storage/' + lang) + ' -Namespace Petstore -Input ' + path.join(basePathOrThrow(), 'Samples/azure-storage/azure-storage.json') + ' -Header NONE';
      exec(clrCmd(generateCmd), function(err, stdout, stderr) {
        console.log(stdout);
        console.error(stderr);
      });
    }
  }
});

var msBuildToolsVersion = 12.0;
if (isWindows) {
    fs.readdirSync('C:/Program Files (x86)/MSBuild/').forEach(function (item) {
        var itemAsFloat = parseFloat(item);
        if (itemAsFloat > msBuildToolsVersion && itemAsFloat < 15) {
            msBuildToolsVersion = itemAsFloat;
        }
    });
}

var msbuildDefaults = {
  stdout: process.stdout,
  stderr: process.stderr,
  maxBuffer: MAX_BUFFER,
  verbosity: 'normal',
  errorOnFail: true,
  toolsVersion: msBuildToolsVersion
};

gulp.task('clean:node_modules', function(cb) {
  del(['./src/**/node_modules', './src/client/**/node_modules'], cb)
})

gulp.task('clean:build', ['clean:node_modules'], function (cb) {
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['clean']
  })));
});

gulp.task('clean:templates', function(cb) {
  del([
    './src/**/Templates/*.cs',
  ], cb);
});

gulp.task('clean:generatedTest', function(cb) {
  var basePath = './PackageTest/NugetPackageTest';
  del([
    path.join(basePath, 'Generated/**/*'),
    path.join(basePath, 'packages/**/*'),
  ], cb);
});

gulp.task('clean', ['clean:build', 'clean:templates', 'clean:generatedTest']);

gulp.task('syncDependencies:nugetProj', function() {
  var dirs = glob.sync(path.join(basePathOrThrow(), '/**/project.json'))
    .map(function(filePath) {
      return path.dirname(filePath);
    });

  return gulp.src(dirs.map(function (dir) {
      return path.join(dir, '/**/AssemblyInfo.cs');
    }), {
      base: './'
    })
    .pipe(nugetProjSync({
      default_version: DEFAULT_ASSEMBLY_VERSION
    }))
    .pipe(gulp.dest('.'));
})

gulp.task('syncDependencies:nuspec', function() {
  var dirs = glob.sync(path.join(basePathOrThrow(), '/**/packages.config'))
    .map(function(filePath) {
      return path.dirname(filePath);
    });

  return gulp.src(dirs.map(function (dir) {
      return path.join(dir, '/**/*.nuspec');
    }), {
      base: './'
    })
    .pipe(nuspecSync())
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime', ['syncDependencies:runtime:cs', 'syncDependencies:runtime:csazure', 'syncDependencies:runtime:node', 'syncDependencies:runtime:nodeazure', 'syncDependencies:runtime:ruby', 'syncDependencies:runtime:rubyazure']);

gulp.task('syncDependencies', ['syncDependencies:nugetProj', 'syncDependencies:nuspec', 'syncDependencies:runtime']);

gulp.task('build', function(cb) {
  // warning 0219 is for unused variables, which causes the build to fail on xbuild
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['build'],
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' },
    stdout: true,
    errorOnFail: true
  })));
});

gulp.task('build:release', function(cb) {
  // warning 0219 is for unused variables, which causes the build to fail on xbuild
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults,{
    targets: ['build'],
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Release' }
  })));
});

/*
gulp.task('package', function(cb) {
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['package'],
    verbosity: 'normal',
  })));
});
*/

gulp.task('test:clientruntime:node', shell.task('npm test', { cwd: './src/client/NodeJS/ms-rest/', verbosity: 3 }));
gulp.task('test:clientruntime:nodeazure', shell.task('npm test', { cwd: './src/client/NodeJS/ms-rest-azure/', verbosity: 3 }));
gulp.task('test:clientruntime:ruby', ['syncDependencies:runtime:ruby'], shell.task('bundle exec rspec', { cwd: './src/client/Ruby/ms-rest/', verbosity: 3 }));
gulp.task('test:clientruntime:rubyazure', ['syncDependencies:runtime:rubyazure'], shell.task('bundle exec rspec', { cwd: './src/client/Ruby/ms-rest-azure/', verbosity: 3 }));
gulp.task('test:clientruntime:java', shell.task(basePathOrThrow() + '/gradlew :client-runtime:check', { cwd: './', verbosity: 3 }));
gulp.task('test:clientruntime:javaazure', shell.task(basePathOrThrow() + '/gradlew :azure-client-runtime:check', { cwd: './', verbosity: 3 }));
gulp.task('test:clientruntime:python', shell.task('tox', { cwd: './src/client/Python/msrest/', verbosity: 3 }));
gulp.task('test:clientruntime:pythonazure', shell.task('tox', { cwd: './src/client/Python/msrestazure/', verbose:true }));

gulp.task('test:clientruntime:javaauthjdk', shell.task(basePathOrThrow() + '/gradlew :azure-client-authentication:check', { cwd: './', verbosity: 3 }));
gulp.task('test:clientruntime:javaauthandroid', shell.task(basePathOrThrow() + '/gradlew :azure-android-client-authentication:check', { cwd: './', verbosity: 3 }));
gulp.task('test:clientruntime', function (cb) {
  runSequence('test:clientruntime:node', 'test:clientruntime:nodeazure',
    'test:clientruntime:ruby', 'test:clientruntime:rubyazure',
    'test:clientruntime:python', 'test:clientruntime:pythonazure',
    'test:clientruntime:java', 'test:clientruntime:javaazure',
    'test:clientruntime:javaauthjdk', 'test:clientruntime:javaauthandroid', cb);
});

gulp.task('test:node', shell.task('npm test', {cwd: './src/generator/AutoRest.NodeJS.Tests/', verbosity: 3}));
gulp.task('test:node:azure', shell.task('npm test', {cwd: './src/generator/AutoRest.NodeJS.Azure.Tests/', verbosity: 3}));

gulp.task('test:ruby', ['regenerate:expected:ruby'], shell.task('ruby RspecTests/tests_runner.rb', { cwd: './src/generator/AutoRest.Ruby.Tests', verbosity: 3 }));
gulp.task('test:ruby:azure', ['regenerate:expected:rubyazure'], shell.task('ruby RspecTests/tests_runner.rb', { cwd: './src/generator/AutoRest.Ruby.Azure.Tests', verbosity: 3 }));

gulp.task('test:java', shell.task(basePathOrThrow() + '/gradlew :codegen-tests:check', {cwd: './', verbosity: 3}));
gulp.task('test:java:azure', shell.task(basePathOrThrow() + '/gradlew :azure-codegen-tests:check', {cwd: './', verbosity: 3}));

gulp.task('test:python', shell.task('tox', {cwd: './src/generator/AutoRest.Python.Tests/', verbosity: 3}));
gulp.task('test:python:azure', shell.task('tox', {cwd: './src/generator/AutoRest.Python.Azure.Tests/', verbosity: 3}));

gulp.task('test:go', ['regenerate:expected:go'], shell.task([
    'glide up', 
    'go fmt ./generated/...', 
    'go run ./runner.go'
    ], {cwd: './src/generator/AutoRest.Go.Tests/src/tests', verbosity: 3})
);

var xunitTestsDlls = [
];

var xunitNetCoreXproj = [
  'src/client/Microsoft.Rest.ClientRuntime.Azure.Tests/project.json',
  'src/client/Microsoft.Rest.ClientRuntime.Tests/project.json',
  'src/core/AutoRest.Core.Tests/project.json',
  'src/core/AutoRest.Extensions.Azure.Tests/project.json',
  'src/core/AutoRest.Extensions.Tests/project.json',
  'src/generator/AutoRest.AzureResourceSchema.Tests/project.json',
  'src/generator/AutoRest.CSharp.Azure.Tests/project.json',
  'src/generator/AutoRest.CSharp.Tests/project.json',
  'src/generator/AutoRest.CSharp.Unit.Tests/project.json',
  'src/modeler/AutoRest.CompositeSwagger.Tests/project.json',
  'src/modeler/AutoRest.Swagger.Tests/project.json'
];

var defaultShellOptions = {
  verbosity: 3,
  env: {
    AUTOREST_TEST_SERVER_PATH: path.resolve('./src/dev/TestServer')
  }
};

var clrCmd = function(cmd){
  return isWindows ? cmd : ('mono ' + cmd);
};

var execClrCmd = function(cmd, options){
  gutil.log(cmd);
  return shell(clrCmd(cmd), options);
};

var clrTask = function(cmd, options){
  return shell.task(clrCmd(cmd), options);
};

var xunit = function(template, options){
  var xunitRunner = path.resolve('packages/xunit.runner.console.2.1.0/tools/xunit.console.exe');
  return execClrCmd(xunitRunner + ' ' + template, options);
}

var xunitnetcore = function(options){
  options.templateData = {
    f: function (s) {
      return path.basename(path.dirname(s))
    }
  };
  var printStatusCodeCmd = 'echo Status code: %errorlevel%';
  if (!isWindows) {
      printStatusCodeCmd = 'echo Status code: $?';
  }
  
  var netcoreScript = 'dotnet test "<%= file.path %>" -verbose -xml "' + path.join(basePathOrThrow(), '/TestResults/') + '<%= f(file.path) %>.xml" && ' + printStatusCodeCmd;
  return shell(netcoreScript, options);
}

gulp.task('test:xunit', ['test:xunit:netcore'], function () {
  return gulp.src(xunitTestsDlls).pipe(xunit('<%= file.path %> -noshadow -noappdomain -diagnostics', defaultShellOptions));
});

gulp.task('test:xunit:netcore', ['regenerate:expected:cs', 'regenerate:expected:csazure'], function () {
  return gulp.src(xunitNetCoreXproj)
        .pipe(debug())
        .pipe(xunitnetcore(defaultShellOptions));
});

var nugetPath = path.resolve('Tools/NuGet.exe');
var nugetTestProjDir = path.resolve('PackageTest/NugetPackageTest');
var packagesDir = path.resolve('binaries/packages');
var cachedClientRuntimePackages = path.join(process.env.HOME || (process.env.HOMEDRIVE + process.env.HOMEPATH),
    'AppData', 'Local', 'NuGet', 'Cache', "Microsoft.Rest.ClientRuntime.*.nupkg");
gulp.task('test:nugetPackages:restore', ['test:nugetPackages:clean'], clrTask(nugetPath + ' restore ' + path.join(nugetTestProjDir, '/NugetPackageTest.sln') + ' -source "' + path.resolve(packagesDir) + ';https://www.nuget.org/api/v2/"'));
gulp.task('test:nugetPackages:clean', function () {
  //turn on 'force' so we can remove files outside of repo folder.
  return del([path.join(nugetTestProjDir, 'Generated'), cachedClientRuntimePackages], {'force' : true});
});

var autoRestExe = function(){
  gutil.log(glob.sync(path.join(basePathOrThrow(), 'PackageTest/NugetPackageTest/packages/autorest.*/tools/AutoRest.exe')));
  return glob.sync(path.join(basePathOrThrow(), 'PackageTest/NugetPackageTest/packages/autorest.*/tools/AutoRest.exe'))[0];
}

gulp.task('test:nugetPackages:generate:csharp', ['test:nugetPackages:restore', 'test:nugetPackages:clean'], function(){
  var csharp = autoRestExe() + ' -Modeler Swagger -CodeGenerator CSharp -OutputDirectory ' + path.join(nugetTestProjDir, '/Generated/CSharp') + ' -Namespace Fixtures.Bodynumber -Input <%= file.path %> -Header NONE';
  return gulp.src('src/dev/TestServer/swagger/body-number.json').pipe(execClrCmd(csharp, {verbosity: 3}));
});

gulp.task('test:nugetPackages:generate:node', ['test:nugetPackages:restore', 'test:nugetPackages:clean'], function(){
  var nodejs = autoRestExe() + ' -Modeler Swagger -CodeGenerator NodeJS -OutputDirectory ' + path.join(nugetTestProjDir, '/Generated/NodeJS') + ' -Input <%= file.path %> -Header NONE';
  return gulp.src('src/dev/TestServer/swagger/body-number.json').pipe(execClrCmd(nodejs, {verbosity: 3}));
});

gulp.task('test:nugetPackages:generate', ['test:nugetPackages:generate:csharp', 'test:nugetPackages:generate:node']);

gulp.task('test:nugetPackages:build', ['test:nugetPackages:generate'], function(){
  return gulp.src(path.join(nugetTestProjDir, 'NugetPackageCSharpTest.csproj'))
        .pipe(msbuild(mergeOptions(msbuildDefaults, { targets: ['build'], properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' } })));
});

gulp.task('test:nugetPackages:xunit', ['test:nugetPackages:build'], function(){
  var xunitSrc = gulp.src(path.join(nugetTestProjDir, 'bin/Debug/NuGetPackageCSharpTest.dll'));
  return xunitSrc.pipe(xunit('<%= file.path %> -noshadow -noappdomain', defaultShellOptions))
});

gulp.task('test:nugetPackages:npm', ['test:nugetPackages:generate'], shell.task('npm test', {cwd: nugetTestProjDir, verbosity: 3}))

gulp.task('test', function(cb){
  if (isWindows) {
    runSequence(
      'test:xunit',
      'test:clientruntime',
// DISABLE      'test:nugetPackages:xunit',
      'test:node',
      'test:node:azure',
// DISABLE     'test:nugetPackages:npm',
      'test:ruby',
      'test:ruby:azure',
      'test:java',
      'test:java:azure',
      'test:python',
      'test:python:azure',
      'test:go',
      cb);
  } else {
    runSequence(
//      'test:xunit',
//      'test:clientruntime',
      'test:node',
      'test:node:azure',
      'test:ruby',
      'test:ruby:azure',
      'test:java',
      'test:java:azure',
      'test:python',
      'test:python:azure',
      'test:go',
      cb);
  }
});

/*
gulp.task('analysis', function(cb) {
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['codeanalysis'],
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' },
  })));
});
*/

gulp.task('default', function(cb){
  // Notes: 
  //   Analysis runs rebuild under the covers, so this causes build to be run in DEBUG
  //   The build RELEASE causes release bits to be built, so we can package RELEASE dlls
  //   Test then runs in DEBUG, but uses the packages created in package
  if (isWindows) {
//'analysis',
    runSequence('clean', 'build:release', 'build', 'test', cb);
  } else {
    runSequence('clean', 'build', 'test', cb);
  }
});
