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
  'AcceptanceTests/BodyArray': '../../../NuGetTests/swagger/body-array.json',
  'AcceptanceTests/BodyBoolean': '../../../NuGetTests/swagger/body-boolean.json',
  'AcceptanceTests/BodyByte': '../../../NuGetTests/swagger/body-byte.json',
  'AcceptanceTests/BodyComplex': '../../../NuGetTests/swagger/body-complex.json',
  'AcceptanceTests/BodyDate': '../../../NuGetTests/swagger/body-date.json',
  'AcceptanceTests/BodyDateTime': '../../../NuGetTests/swagger/body-datetime.json',
  'AcceptanceTests/BodyDictionary': '../../../NuGetTests/swagger/body-dictionary.json',
  'AcceptanceTests/BodyFile': '../../../NuGetTests/swagger/body-file.json',
  'AcceptanceTests/BodyInteger': '../../../NuGetTests/swagger/body-integer.json',
  'AcceptanceTests/BodyNumber': '../../../NuGetTests/swagger/body-number.json',
  'AcceptanceTests/BodyString': '../../../NuGetTests/swagger/body-string.json',
  'AcceptanceTests/Header': '../../../NuGetTests/swagger/header.json',
  'AcceptanceTests/Http': '../../../NuGetTests/swagger/httpInfrastructure.json',
  'AcceptanceTests/Report': '../../../NuGetTests/swagger/report.json',
  'AcceptanceTests/RequiredOptional': '../../../NuGetTests/swagger/required-optional.json',
  'AcceptanceTests/Url': '../../../NuGetTests/swagger/url.json',
  'AcceptanceTests/Validation': '../../../NuGetTests/swagger/validation.json'
};

var rubyMappings = {

    'boolean':['../../../NuGetTests/swagger/body-boolean.json', 'BooleanModule'],
    'integer':['../../../NuGetTests/swagger/body-integer.json','IntegerModule'], 
    'number':['../../../NuGetTests/swagger/body-number.json','NumberModule'],
    'string':['../../../NuGetTests/swagger/body-string.json','StringModule'],
    'byte':['../../../NuGetTests/swagger/body-byte.json','ByteModule'],
    'array':['../../../NuGetTests/swagger/body-array.json','ArrayModule'],
    'dictionary':['../../../NuGetTests/swagger/body-dictionary.json','DictionaryModule'],
    'date':['../../../NuGetTests/swagger/body-date.json','DateModule'],
    'datetime':['../../../NuGetTests/swagger/body-datetime.json','DatetimeModule'],
    'complex':['../../../NuGetTests/swagger/body-complex.json','ComplexModule'],
    'url':['../../../NuGetTests/swagger/url.json','UrlModule'],
    'url_items':['../../../NuGetTests/swagger/url.json','UrlModule'],
    'url_query':['../../../NuGetTests/swagger/url.json','UrlModule'],
    'header_folder':['../../../NuGetTests/swagger/header.json','HeaderModule'],
    'http_infrastructure':['../../../NuGetTests/swagger/httpInfrastructure.json','HttpInfrastructureModule'],
    'required_optional':['../../../NuGetTests/swagger/required-optional.json','RequiredOptionalModule'],
    'report':['../../../NuGetTests/swagger/report.json','ReportModule']
};

var defaultAzureMappings = {
  'AcceptanceTests/Lro': '../../../NuGetTests/swagger/lro.json',
  'AcceptanceTests/Paging': '../../../NuGetTests/swagger/paging.json',
  'AcceptanceTests/AzureReport': '../../../NuGetTests/swagger/azure-report.json',
  'AcceptanceTests/ResourceFlattening': '../../../NuGetTests/swagger/resource-flattening.json',
  'AcceptanceTests/Head': '../../../NuGetTests/swagger/head.json',
  'AcceptanceTests/SubscriptionIdApiVersion': '../../../NuGetTests/swagger/subscriptionId-apiVersion.json',
  'AcceptanceTests/AzureSpecials': '../../../NuGetTests/swagger/azure-special-properties.json'
};

var rubyAzureMappings = {
    'head':['../../../NuGetTests/swagger/head.json', 'HeadModule'],
    'paging':['../../../NuGetTests/swagger/paging.json', 'PagingModule'],
    'resource_flattening':['../../../NuGetTests/swagger/resource-flattening.json', 'ResourceFlatteningModule'],
    'lro':['../../../NuGetTests/swagger/lro.json', 'LroModule'],
    'azure_url':['../../../NuGetTests/swagger/subscriptionId-apiVersion.json', 'AzureUrlModule'],
    'azure_special_properties': ['../../../NuGetTests/swagger/azure-special-properties.json', 'AzureSpecialPropertiesModule'],
    'azure_report':['../../../NuGetTests/swagger/azure-report.json', 'AzureReportModule'],
};

gulp.task('regenerate:expected', function(cb){
  runSequence('regenerate:delete',
    [
      'regenerate:expected:csazure',
      'regenerate:expected:cs',
      'regenerate:expected:node',
      'regenerate:expected:nodeazure',
	  'regenerate:expected:ruby',
      'regenerate:expected:rubyazure'
    ],
    cb);
});

gulp.task('regenerate:delete', function(cb){
  del([
    'AutoRest/Generators/CSharp/Azure.CSharp.Tests/Expected',
    'AutoRest/Generators/CSharp/CSharp.Tests/Expected',
    'AutoRest/Generators/NodeJS/NodeJS.Tests/Expected',
    'AutoRest/Generators/NodeJS/Azure.NodeJS.Tests/Expected'
  ], cb);
});

gulp.task('regenerate:expected:nodeazure', function(cb){
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/NodeJS/Azure.NodeJS.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'mappings': defaultAzureMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.NodeJS'
  }, cb);
})

gulp.task('regenerate:expected:node', function(cb){
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/NodeJS/NodeJS.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/CSharp.Tests',
    'mappings': defaultMappings,
    'outputDir': 'Expected',
    'codeGenerator': 'NodeJS'
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


gulp.task('regenerate:expected:csazure', function(cb){
  mappings = mergeOptions(defaultAzureMappings);
  regenExpected({
    'outputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'inputBaseDir': 'AutoRest/Generators/CSharp/Azure.CSharp.Tests',
    'mappings': mappings,
    'outputDir': 'Expected',
    'codeGenerator': 'Azure.CSharp',
    'nsPrefix': 'Fixtures.Azure'
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
    'nsPrefix': 'Fixtures'
  }, cb);
});

gulp.task('clean:build', function (cb) {
  return gulp.src('build.proj').pipe(msbuild({
    targets: ['clean'],
    stdout: process.stdout,
    stderr: process.stderr,
    maxBuffer: MAX_BUFFER
  }));
});

gulp.task('clean:templates', function(cb) {
  del([
    './AutoRest/**/Templates/*.cs',
  ], cb);
});

gulp.task('clean:generatedTest', function(cb) {
  var basePath = './AutoRest/NuGetTests/NugetPackageTest';
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

var msbuildDefaults = {
  stdout: process.stdout,
  stderr: process.stderr,
  maxBuffer: MAX_BUFFER,
  verbosity: 'minimal',
  errorOnFail: true,
};

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
gulp.task('test:clientruntime:ruby', shell.task('bundle exec rspec', { cwd: './ClientRuntimes/Ruby/ms-rest/', verbosity: 3 }));
gulp.task('test:clientruntime:rubyazure', shell.task('bundle exec rspec', { cwd: './ClientRuntimes/Ruby/ms-rest-azure/', verbosity: 3 }));
gulp.task('test:clientruntime', function (cb) {
  runSequence('test:clientruntime:node', 'test:clientruntime:nodeazure',
    'test:clientruntime:ruby', 'test:clientruntime:rubyazure', cb);
});

gulp.task('test:node', shell.task('npm test', {cwd: './AutoRest/Generators/NodeJS/NodeJS.Tests/', verbosity: 3}));
gulp.task('test:node:azure', shell.task('npm test', {cwd: './AutoRest/Generators/NodeJS/Azure.NodeJS.Tests/', verbosity: 3}));

gulp.task('test:ruby', ['regenerate:expected:ruby'], shell.task('ruby RspecTests/tests_runner.rb', { cwd: './AutoRest/Generators/Ruby/Ruby.Tests', verbosity: 3 }));
gulp.task('test:ruby:azure', ['regenerate:expected:rubyazure'], shell.task('ruby RspecTests/tests_runner.rb', { cwd: './AutoRest/Generators/Ruby/Azure.Ruby.Tests', verbosity: 3 }));

var xunitTestsDlls = [
  'AutoRest/AutoRest.Core.Tests/bin/Net45-Debug/AutoRest.Core.Tests.dll',
  'AutoRest/Generators/Azure.Common/Azure.Common.Tests/bin/Net45-Debug/AutoRest.Generator.Azure.Common.Tests.dll',
  'AutoRest/Generators/CSharp/Azure.CSharp.Tests/bin/Net45-Debug/Azure.CSharp.Tests.dll',
  'AutoRest/Generators/CSharp/CSharp.Tests/bin/Net45-Debug/CSharp.Tests.dll',
  'AutoRest/Modelers/Swagger.Tests/bin/Net45-Debug/AutoRest.Swagger.Tests.dll',
  'ClientRuntimes/CSharp/ClientRuntime.Azure.Tests/bin/Net45-Debug/ClientRuntime.Azure.Tests.dll',
  'ClientRuntimes/CSharp/ClientRuntime.Tests/bin/Net45-Debug/ClientRuntime.Tests.dll',
];

var clrCmd = function(cmd){
  return isWindows ? cmd : ('mono ' + cmd);
};

var execClrCmd = function(cmd, options){
  return shell(clrCmd(cmd), options);
};

var clrTask = function(cmd, options){
  return shell.task(clrCmd(cmd), options);
};

var xunit = function(template, options){
  var xunitRunner = path.resolve('packages/xunit.runner.console.2.1.0-beta4-build3109/tools/xunit.console.x86.exe');
  return execClrCmd(xunitRunner + ' ' + template, options);
}

gulp.task('test:xunit', function () {
  return gulp.src(xunitTestsDlls).pipe(xunit('<%= file.path %> -noshadow -noappdomain', {verbosity: 3}));
});

var nugetPath = path.resolve('Tools/NuGet.exe');
var nugetTestProjDir = path.resolve('AutoRest/NuGetTests/NugetPackageTest');
var packagesDir = path.resolve('binaries/packages');
gulp.task('test:nugetPackagesTest:restore', clrTask(nugetPath + ' restore ' + path.join(nugetTestProjDir, '/NugetPackageTest.sln') + ' -source ' + path.resolve(packagesDir)));

gulp.task('test:nugetPackagesTest:clean', function(){
  return del([path.join(nugetTestProjDir, 'Generated')]);
});

gulp.task('test:nugetPackages', ['test:nugetPackagesTest:restore', 'test:nugetPackagesTest:clean'], function(cb){
  var toolsDir = 'packages/autorest.0.11.0/tools';
  var autoRestExe = fs.readdirSync(path.join(nugetTestProjDir, toolsDir)).filter(function(file) {
    return file.match(/AutoRest.exe$/);
  })[0];
  var csharp = path.join(nugetTestProjDir, toolsDir, autoRestExe) + ' -Modeler Swagger -CodeGenerator CSharp -OutputDirectory ' + path.join(nugetTestProjDir, '/Generated/CSharp') + ' -Namespace Fixtures.Bodynumber -Input <%= file.path %> -Header NONE';
  var nodejs = path.join(nugetTestProjDir, toolsDir, autoRestExe) + ' -Modeler Swagger -CodeGenerator NodeJS -OutputDirectory ' + path.join(nugetTestProjDir, '/Generated/NodeJS') + ' -Input <%= file.path %> -Header NONE';
  var swagger = gulp.src('AutoRest/NuGetTests/swagger/body-number.json');
  var xunitSrc = gulp.src(path.join(nugetTestProjDir, 'bin/Debug/NuGetPackageCSharpTest.dll'));
  return merge(
    [
      swagger.pipe(execClrCmd(csharp, {verbosity: 3})),
      swagger.pipe(execClrCmd(nodejs, {verbosity: 3}))
    ],
    [
      xunitSrc.pipe(xunit('<%= file.path %> -noshadow -noappdomain', {verbosity: 3})),
      shell.task('npm test', {cwd: nugetTestProjDir, verbosity: 3})()
    ]
  );
});

gulp.task('test', function(cb){
  runSequence('test:xunit', 'test:clientruntime', 'test:node', 'test:node:azure', 'test:ruby', 'test:ruby:azure', 'test:nugetPackages', cb);
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
  runSequence('clean', 'build', 'analysis', 'build:release', 'package', 'test', cb);
});
