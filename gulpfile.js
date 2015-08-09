/// <binding />
var gulp = require('gulp');
var msbuild = require('gulp-msbuild');
var debug = require('gulp-debug');
var env = require('gulp-env');
var path = require('path');
var fs = require('fs');
var glob = require('glob');
var spawn = require('child_process').spawn;
var assemblyInfo = require('gulp-dotnet-assembly-info');
var nuspecSync = require('./Tools/gulp/gulp-nuspec-sync');
var runtimeVersionSync = require('./Tools/gulp/gulp-runtime-version-sync');
var nugetProjSync = require('./Tools/gulp/gulp-nuget-proj-sync');
var regenExpected = require('./Tools/gulp/gulp-regenerate-expected');
var del = require('del');
var gutil = require('gulp-util');
var runSequence = require('run-sequence');
var requireDir = require('require-dir')('./Tools/gulp');

const DEFAULT_ASSEMBLY_VERSION = '0.9.0.0';
const MAX_BUFFER = 1024 * 1024;
process.env.MSBUILDDISABLENODEREUSE = 1;

function basePathOrThrow() {
  if (!gutil.env.basePath) {
    return __dirname;
  }
  return gutil.env.basePath;
}

function runProcess(name, args, options, cb){
  if (typeof(options) == 'function') {
    cb = options;
  }

  var child = spawn(name, args, { stdio: ['pipe', process.stdout, process.stderr] });

  child.on('error', function(err){
    cb(err);
  });

  child.on('close', function(code) {
    var message = "Done with exit code " + code;
    gutil.log(message);
    if(code != 0){
      cb(message)
    } else {
      cb();
    }
  });
}

function merge_options(obj1,obj2){
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
}

var defaultMappings = {
  'AcceptanceTests/BodyArray': '../../AcceptanceTests/swagger/body-array.json',
  'AcceptanceTests/BodyBoolean': '../../AcceptanceTests/swagger/body-boolean.json',
  'AcceptanceTests/BodyByte': '../../AcceptanceTests/swagger/body-byte.json',
  'AcceptanceTests/BodyComplex': '../../AcceptanceTests/swagger/body-complex.json',
  'AcceptanceTests/BodyDate': '../../AcceptanceTests/swagger/body-date.json',
  'AcceptanceTests/BodyDateTime': '../../AcceptanceTests/swagger/body-datetime.json',
  'AcceptanceTests/BodyDictionary': '../../AcceptanceTests/swagger/body-dictionary.json',
  'AcceptanceTests/BodyFile': '../../AcceptanceTests/swagger/body-file.json',
  'AcceptanceTests/BodyInteger': '../../AcceptanceTests/swagger/body-integer.json',
  'AcceptanceTests/BodyNumber': '../../AcceptanceTests/swagger/body-number.json',
  'AcceptanceTests/BodyString': '../../AcceptanceTests/swagger/body-string.json',
  'AcceptanceTests/Header': '../../AcceptanceTests/swagger/header.json',
  'AcceptanceTests/Http': '../../AcceptanceTests/swagger/httpInfrastructure.json',
  'AcceptanceTests/Report': '../../AcceptanceTests/swagger/report.json',
  'AcceptanceTests/RequiredOptional': '../../AcceptanceTests/swagger/required-optional.json',
  'AcceptanceTests/Url': '../../AcceptanceTests/swagger/url.json',
  'AcceptanceTests/Validation': '../../AcceptanceTests/swagger/validation.json'
};

var defaultAzureMappings = {
  'AcceptanceTests/Lro': '../../AcceptanceTests/swagger/lro.json',
  'AcceptanceTests/Paging': '../../AcceptanceTests/swagger/paging.json',
  'AcceptanceTests/AzureReport': '../../AcceptanceTests/swagger/azure-report.json',
  'AcceptanceTests/ResourceFlattening': '../../AcceptanceTests/swagger/resource-flattening.json',
  'AcceptanceTests/Head': '../../AcceptanceTests/swagger/head.json',
  'AcceptanceTests/SubscriptionIdApiVersion': '../../AcceptanceTests/swagger/subscriptionId-apiVersion.json',
  'AcceptanceTests/AzureSpecials': '../../AcceptanceTests/swagger/azure-special-properties.json'
};

gulp.task('regenerate:expected', function(cb){
  runSequence('regenerate:delete',
    [
      'regenerate:expected:csazure',
      'regenerate:expected:cs',
      'regenerate:expected:node',
      'regenerate:expected:nodeazure'
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

gulp.task('regenerate:expected:csazure', function(cb){
  mappings = merge_options(defaultAzureMappings);
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
  mappings = merge_options({
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
  var basePath = './AutoRest/Generators/AcceptanceTests/NugetPackageTest';
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

gulp.task('syncDependencies:runtime', ['syncDependencies:runtime:cs', 'syncDependencies:runtime:csazure', 'syncDependencies:runtime:node', 'syncDependencies:runtime:nodeazure']);

gulp.task('syncDependencies', ['syncDependencies:nugetProj', 'syncDependencies:nuspec', 'syncDependencies:runtime']);

gulp.task('build', function(cb) {
  // warning 0219 is for unused variables, which causes the build to fail on xbuild
  return gulp.src('build.proj').pipe(msbuild({
    targets: ['build'],
    stdout: process.stdout,
    stderr: process.stderr,
    maxBuffer: MAX_BUFFER,
    errorOnFail: true,
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' }
  }));
});

gulp.task('package', function(cb) {
  return gulp.src('build.proj').pipe(msbuild({
    targets: ['package'],
    stdout: process.stdout,
    stderr: process.stderr,
    errorOnFail: true,
    maxBuffer: MAX_BUFFER
  }));
});

gulp.task('test', function (cb) {
  return gulp.src('build.proj').pipe(msbuild({
    targets: ['test'],
    stdout: process.stdout,
    stderr: process.stderr,
    errorOnFail: true,
    maxBuffer: MAX_BUFFER,
    properties: { Configuration: 'Debug' }
  }));
});

gulp.task('analysis', function(cb) {
  return gulp.src('build.proj').pipe(msbuild({
    targets: ['codeanalysis'],
    stdout: process.stdout,
    stderr: process.stderr,
    maxBuffer: MAX_BUFFER,
    errorOnFail: true,
    properties: { WarningsNotAsErrors: 0219, Configuration: 'Debug' }
  }));
});

gulp.task('default', function(cb){
  // build is not called here because analysis causes a rebuild of the solutions
  runSequence('clean', 'build', 'analysis', 'package', 'test', cb);
});
