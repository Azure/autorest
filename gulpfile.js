/// <binding />
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
requireDir = require('require-dir')('./Tools/gulp');

const DEFAULT_ASSEMBLY_VERSION = '0.9.0.0';
const DNX_VERSION = '1.0.0-rc1-final';
const MAX_BUFFER = 1024 * 4096;
var isWindows = (process.platform.lastIndexOf('win') === 0);
process.env.MSBUILDDISABLENODEREUSE = 1;

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
  'AcceptanceTests/BodyArray': '../../../TestServer/swagger/body-array.json',
  'AcceptanceTests/BodyBoolean': '../../../TestServer/swagger/body-boolean.json',
  'AcceptanceTests/BodyByte': '../../../TestServer/swagger/body-byte.json',
  'AcceptanceTests/BodyComplex': '../../../TestServer/swagger/body-complex.json',
  'AcceptanceTests/BodyDate': '../../../TestServer/swagger/body-date.json',
  'AcceptanceTests/BodyDateTime': '../../../TestServer/swagger/body-datetime.json',
  'AcceptanceTests/BodyDateTimeRfc1123': '../../../TestServer/swagger/body-datetime-rfc1123.json',
  'AcceptanceTests/BodyDuration': '../../../TestServer/swagger/body-duration.json',
  'AcceptanceTests/BodyDictionary': '../../../TestServer/swagger/body-dictionary.json',
  'AcceptanceTests/BodyFile': '../../../TestServer/swagger/body-file.json',
  'AcceptanceTests/BodyInteger': '../../../TestServer/swagger/body-integer.json',
  'AcceptanceTests/BodyNumber': '../../../TestServer/swagger/body-number.json',
  'AcceptanceTests/BodyString': '../../../TestServer/swagger/body-string.json',
  'AcceptanceTests/Header': '../../../TestServer/swagger/header.json',
  'AcceptanceTests/Http': '../../../TestServer/swagger/httpInfrastructure.json',
  'AcceptanceTests/Report': '../../../TestServer/swagger/report.json',
  'AcceptanceTests/RequiredOptional': '../../../TestServer/swagger/required-optional.json',
  'AcceptanceTests/Url': '../../../TestServer/swagger/url.json',
  'AcceptanceTests/Validation': '../../../TestServer/swagger/validation.json'
};

var rubyMappings = {
  'boolean':['../../../TestServer/swagger/body-boolean.json', 'BooleanModule'],
  'integer':['../../../TestServer/swagger/body-integer.json','IntegerModule'],
  'number':['../../../TestServer/swagger/body-number.json','NumberModule'],
  'string':['../../../TestServer/swagger/body-string.json','StringModule'],
  'byte':['../../../TestServer/swagger/body-byte.json','ByteModule'],
  'array':['../../../TestServer/swagger/body-array.json','ArrayModule'],
  'dictionary':['../../../TestServer/swagger/body-dictionary.json','DictionaryModule'],
  'date':['../../../TestServer/swagger/body-date.json','DateModule'],
  'datetime':['../../../TestServer/swagger/body-datetime.json','DatetimeModule'],
  'datetime_rfc1123':['../../../TestServer/swagger/body-datetime-rfc1123.json','DatetimeRfc1123Module'],
  'duration':['../../../TestServer/swagger/body-duration.json','DurationModule'],
  'complex':['../../../TestServer/swagger/body-complex.json','ComplexModule'],
  'url':['../../../TestServer/swagger/url.json','UrlModule'],
  'url_items':['../../../TestServer/swagger/url.json','UrlModule'],
  'url_query':['../../../TestServer/swagger/url.json','UrlModule'],
  'header_folder':['../../../TestServer/swagger/header.json','HeaderModule'],
  'http_infrastructure':['../../../TestServer/swagger/httpInfrastructure.json','HttpInfrastructureModule'],
  'required_optional':['../../../TestServer/swagger/required-optional.json','RequiredOptionalModule'],
  'report':['../../../TestServer/swagger/report.json','ReportModule']
};

var defaultAzureMappings = {
  'AcceptanceTests/Lro': '../../../TestServer/swagger/lro.json',
  'AcceptanceTests/Paging': '../../../TestServer/swagger/paging.json',
  'AcceptanceTests/AzureReport': '../../../TestServer/swagger/azure-report.json',
  'AcceptanceTests/AzureParameterGrouping': '../../../TestServer/swagger/azure-parameter-grouping.json',
  'AcceptanceTests/ResourceFlattening': '../../../TestServer/swagger/resource-flattening.json',
  'AcceptanceTests/Head': '../../../TestServer/swagger/head.json',
  'AcceptanceTests/SubscriptionIdApiVersion': '../../../TestServer/swagger/subscriptionId-apiVersion.json',
  'AcceptanceTests/AzureSpecials': '../../../TestServer/swagger/azure-special-properties.json'
};

var nodeAzureMappings = {
  'AcceptanceTests/StorageManagementClient': '../../../TestServer/swagger/storage.json'
};

var rubyAzureMappings = {
  'head':['../../../TestServer/swagger/head.json', 'HeadModule'],
  'paging':['../../../TestServer/swagger/paging.json', 'PagingModule'],
  'resource_flattening':['../../../TestServer/swagger/resource-flattening.json', 'ResourceFlatteningModule'],
  'lro':['../../../TestServer/swagger/lro.json', 'LroModule'],
  'azure_url':['../../../TestServer/swagger/subscriptionId-apiVersion.json', 'AzureUrlModule'],
  'azure_special_properties': ['../../../TestServer/swagger/azure-special-properties.json', 'AzureSpecialPropertiesModule'],
  'azure_report':['../../../TestServer/swagger/azure-report.json', 'AzureReportModule'],
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
      'regenerate:expected:javaazure'
    ],
    cb);
});

gulp.task('regenerate:delete', function(cb){
  del([
    'AutoRest/Generators/CSharp/Azure.CSharp.Tests/Expected',
    'AutoRest/Generators/CSharp/CSharp.Tests/Expected',
    'AutoRest/Generators/NodeJS/NodeJS.Tests/Expected',
    'AutoRest/Generators/NodeJS/Azure.NodeJS.Tests/Expected',
    'AutoRest/Generators/Java/Java.Tests/src/main/java',
    'AutoRest/Generators/Java/Azure.Java.Tests/src/main/java'
  ], cb);
});

gulp.task('regenerate:expected:nodeazure', function(cb){
  for (var p in defaultAzureMappings) {
    nodeAzureMappings[p] = defaultAzureMappings[p];
  }

  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/NodeJS/Azure.NodeJS.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'mappings': nodeAzureMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS',
    'flatteningThreshold': '1'
  }, cb);
})

gulp.task('regenerate:expected:node', function(cb){
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/NodeJS/NodeJS.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/CSharp.Tests',
    'mappings': defaultMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS',
    'flatteningThreshold': '1'
  }, cb);
})

gulp.task('regenerate:expected:rubyazure', function(cb){
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/Ruby/Azure.Ruby.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'mappings': rubyAzureMappings,
    'outputDir': 'RspecTests/Generated',
    'codeGenerator': 'Azure.Ruby',
    'nsPrefix': 'MyNamespace'
  }, cb);
})

gulp.task('regenerate:expected:ruby', function(cb){
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/Ruby/Ruby.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/CSharp.Tests',
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
    'outputBaseDir': 'AutoRest/Generators/Java/Azure.Java.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Azure.Java',
    'nsPrefix': 'Fixtures'
  }, cb);
})

gulp.task('regenerate:expected:java', function(cb){
  mappings = {};
  for (var key in defaultMappings) {
    mappings[key.substring(16).toLowerCase()] = defaultMappings[key];
  }
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/Java/Java.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'src/main/java/fixtures',
    'codeGenerator': 'Java',
    'nsPrefix': 'Fixtures'
  }, cb);
})

gulp.task('regenerate:expected:csazure', function(cb){
  mappings = mergeOptions({
    'AcceptanceTests/AzureBodyDuration': '../../../TestServer/swagger/body-duration.json'
  }, defaultAzureMappings);

  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures.Azure',
    'flatteningThreshold': '1'
  }, cb);
});

gulp.task('regenerate:expected:cs', function(cb){
  mappings = mergeOptions({
    'PetstoreV2': 'Swagger/swagger.2.0.example.v2.json',
    'Mirror.RecursiveTypes': 'Swagger/swagger-mirror-recursive-type.json',
    'Mirror.Primitives': 'Swagger/swagger-mirror-primitives.json',
    'Mirror.Sequences': 'Swagger/swagger-mirror-sequences.json',
    'Mirror.Polymorphic': 'Swagger/swagger-mirror-polymorphic.json',
  }, defaultMappings);

  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/CSharp/CSharp.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'CSharp',
    'nsPrefix': 'Fixtures',
    'flatteningThreshold': '1'
  }, cb);
});

var msbuildDefaults = {
  stdout: process.stdout,
  stderr: process.stderr,
  maxBuffer: MAX_BUFFER,
  verbosity: 'minimal',
  errorOnFail: true,
  toolsVersion: 12.0
};

gulp.task('clean:node_modules', function(cb) {
  del(['./AutoRest/**/node_modules', './ClientRuntimes/**/node_modules'], cb)
})

gulp.task('clean:build', ['clean:node_modules'], function (cb) {
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['clean']
  })));
});

gulp.task('clean:templates', function(cb) {
  del([
    './AutoRest/**/Templates/*.cs',
  ], cb);
});

gulp.task('clean:generatedTest', function(cb) {
  var basePath = './AutoRest/NugetPackageTest';
  del([
    path.join(basePath, 'Generated/**/*'),
    path.join(basePath, 'packages/**/*'),
  ], cb);
});

gulp.task('clean', ['clean:build', 'clean:templates', 'clean:generatedTest']);

gulp.task('syncDependencies:nugetProj', function() {
  var dirs = glob.sync(path.join(basePathOrThrow(), '/**/*.nuget.proj'))
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
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' }
  })));
});

gulp.task('build:release', function(cb) {
  // warning 0219 is for unused variables, which causes the build to fail on xbuild
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults,{
    targets: ['build'],
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Release' }
  })));
});

gulp.task('package', function(cb) {
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['package'],
    verbosity: 'normal',
  })));
});

gulp.task('test:clientruntime:node', shell.task('npm test', { cwd: './ClientRuntimes/NodeJS/ms-rest/', verbosity: 3 }));
gulp.task('test:clientruntime:nodeazure', shell.task('npm test', { cwd: './ClientRuntimes/NodeJS/ms-rest-azure/', verbosity: 3 }));
gulp.task('test:clientruntime:ruby', ['syncDependencies:runtime:ruby'], shell.task('bundle exec rspec', { cwd: './ClientRuntimes/Ruby/ms-rest/', verbosity: 3 }));
gulp.task('test:clientruntime:rubyazure', ['syncDependencies:runtime:rubyazure'], shell.task('bundle exec rspec', { cwd: './ClientRuntimes/Ruby/ms-rest-azure/', verbosity: 3 }));
gulp.task('test:clientruntime:java', shell.task(basePathOrThrow() + '/gradlew :client-runtime:check', { cwd: './', verbosity: 3 }));
gulp.task('test:clientruntime:javaazure', shell.task(basePathOrThrow() + '/gradlew :azure-client-runtime:check', { cwd: './', verbosity: 3 }));
gulp.task('test:clientruntime', function (cb) {
  runSequence('test:clientruntime:node', 'test:clientruntime:nodeazure',
    'test:clientruntime:ruby', 'test:clientruntime:rubyazure',
    'test:clientruntime:java', 'test:clientruntime:javaazure', cb);
});

gulp.task('test:node', shell.task('npm test', {cwd: './AutoRest/Generators/NodeJS/NodeJS.Tests/', verbosity: 3}));
gulp.task('test:node:azure', shell.task('npm test', {cwd: './AutoRest/Generators/NodeJS/Azure.NodeJS.Tests/', verbosity: 3}));

gulp.task('test:ruby', ['regenerate:expected:ruby'], shell.task('ruby RspecTests/tests_runner.rb', { cwd: './AutoRest/Generators/Ruby/Ruby.Tests', verbosity: 3 }));
gulp.task('test:ruby:azure', ['regenerate:expected:rubyazure'], shell.task('ruby RspecTests/tests_runner.rb', { cwd: './AutoRest/Generators/Ruby/Azure.Ruby.Tests', verbosity: 3 }));

gulp.task('test:java', shell.task(basePathOrThrow() + '/gradlew :codegen-tests:check', {cwd: './', verbosity: 3}));
gulp.task('test:java:azure', shell.task(basePathOrThrow() + '/gradlew :azure-codegen-tests:check', {cwd: './', verbosity: 3}));

var xunitTestsDlls = [
  'AutoRest/AutoRest.Core.Tests/bin/Net45-Debug/AutoRest.Core.Tests.dll',
  'AutoRest/Modelers/Swagger.Tests/bin/Net45-Debug/AutoRest.Modeler.Swagger.Tests.dll',
  'AutoRest/Generators/Azure.Common/Azure.Common.Tests/bin/Net45-Debug/AutoRest.Generator.Azure.Common.Tests.dll'
];

var xunitDnxXproj = [
  'AutoRest/Generators/CSharp/Azure.CSharp.Tests/project.json',
  'AutoRest/Generators/CSharp/CSharp.Tests/project.json',
  'ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime.Tests/project.json',
  'ClientRuntimes/CSharp/Microsoft.Rest.ClientRuntime.Azure.Tests/project.json'
];

var defaultShellOptions = {
  verbosity: 3,
  env: {
    AUTOREST_TEST_SERVER_PATH: path.resolve('AutoRest/TestServer')
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

var xunitdnx = function(options){
  options.templateData = {
    f: function (s) {
      return path.basename(path.dirname(s))
    }
  };
  var printStatusCodeCmd = 'echo Status code: %errorlevel%';
  if (!isWindows) {
      printStatusCodeCmd = 'echo Status code: $?';
  }
  var dnxScript = 'dnx --project "<%= file.path %>" test -verbose -xml "' + path.join(basePathOrThrow(), '/TestResults/') + '<%= f(file.path) %>.xml" && ' + printStatusCodeCmd;
  return shell(dnxScript, options);
}

gulp.task('test:xunit', ['regenerate:expected:cs', 'regenerate:expected:csazure', 'test:xunit:dnx'], function () {
  return gulp.src(xunitTestsDlls).pipe(xunit('<%= file.path %> -noshadow -noappdomain -diagnostics', defaultShellOptions));
});

gulp.task('test:xunit:dnx', function () {
  return gulp.src(xunitDnxXproj)
        .pipe(debug())
        .pipe(xunitdnx(defaultShellOptions));
});

var nugetPath = path.resolve('Tools/NuGet.exe');
var nugetTestProjDir = path.resolve('AutoRest/NugetPackageTest');
var packagesDir = path.resolve('binaries/packages');
var cachedClientRuntimePackages = path.join(process.env.HOME || (process.env.HOMEDRIVE + process.env.HOMEPATH),
    'AppData', 'Local', 'NuGet', 'Cache', "Microsoft.Rest.ClientRuntime.*.nupkg");
gulp.task('test:nugetPackages:restore', ['test:nugetPackages:clean'], clrTask(nugetPath + ' restore ' + path.join(nugetTestProjDir, '/NugetPackageTest.sln') + ' -source "' + path.resolve(packagesDir) + ';https://www.nuget.org/api/v2/"'));
gulp.task('test:nugetPackages:clean', function () {
  //turn on 'force' so we can remove files outside of repo folder.
  return del([path.join(nugetTestProjDir, 'Generated'), cachedClientRuntimePackages], {'force' : true});
});

var autoRestExe = function(){
  gutil.log(glob.sync(path.join(basePathOrThrow(), 'AutoRest/NugetPackageTest/packages/autorest.*/tools/AutoRest.exe')));
  return glob.sync(path.join(basePathOrThrow(), 'AutoRest/NugetPackageTest/packages/autorest.*/tools/AutoRest.exe'))[0];
}

gulp.task('test:nugetPackages:generate:csharp', ['test:nugetPackages:restore', 'test:nugetPackages:clean'], function(){
  var csharp = autoRestExe() + ' -Modeler Swagger -CodeGenerator CSharp -OutputDirectory ' + path.join(nugetTestProjDir, '/Generated/CSharp') + ' -Namespace Fixtures.Bodynumber -Input <%= file.path %> -Header NONE';
  return gulp.src('AutoRest/TestServer/swagger/body-number.json').pipe(execClrCmd(csharp, {verbosity: 3}));
});

gulp.task('test:nugetPackages:generate:node', ['test:nugetPackages:restore', 'test:nugetPackages:clean'], function(){
  var nodejs = autoRestExe() + ' -Modeler Swagger -CodeGenerator NodeJS -OutputDirectory ' + path.join(nugetTestProjDir, '/Generated/NodeJS') + ' -Input <%= file.path %> -Header NONE';
  return gulp.src('AutoRest/TestServer/swagger/body-number.json').pipe(execClrCmd(nodejs, {verbosity: 3}));
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

gulp.task('test:nugetPackages', ['test:nugetPackages:npm', 'test:nugetPackages:xunit']);

gulp.task('test', function(cb){
  if (isWindows) {
    runSequence(
      'test:xunit',
      'test:clientruntime',
      'test:node',
      'test:node:azure',
      'test:ruby',
      'test:ruby:azure',
      'test:java',
      'test:java:azure',
      'test:nugetPackages',
      cb);
  } else {
    runSequence(
      'test:xunit',
      'test:clientruntime',
      'test:node',
      'test:node:azure',
      'test:ruby',
      'test:ruby:azure',
      'test:java',
      'test:java:azure',
      cb);
  }
});

gulp.task('analysis', function(cb) {
  return gulp.src('build.proj').pipe(msbuild(mergeOptions(msbuildDefaults, {
    targets: ['codeanalysis'],
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' },
  })));
});

gulp.task('default', function(cb){
  // analysis runs rebuild under the covers, so this cause build to be run in debug
  // the build release causes release bits to be built, so we can package release dlls
  // test then runs in debug, but uses the packages created in package
  if (isWindows) {
    runSequence('clean', 'build', 'analysis', 'build:release', 'package', 'test', cb);
  } else {
    runSequence('clean', 'build', 'test', cb);
  }
});
