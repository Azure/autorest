var gulp = require('gulp');
var path = require('path');
var fs = require('fs');
var debug = require('gulp-debug');
var glob = require('glob');
var spawn = require('child_process').spawn;
var assemblyInfo = require('gulp-dotnet-assembly-info');
var nuspecSync = require('./Tools/gulp/gulp-nuspec-sync');
var nugetProjSync = require('./Tools/gulp/gulp-nuget-proj-sync');
var del = require('del');
var gutil = require('gulp-util');
var runSequence = require('run-sequence');

var isWin = /^win/.test(process.platform);

const DEFAULT_ASSEMBLY_VERSION = '0.9.0.0'

var csharpBuild = isWin ? 'msbuild' : 'xbuild';

function basePathOrThrow() {
  if (!gutil.env.basePath) {
    throw new Error('Must provide a --basePath argument upon execution');
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

// Clean related tasks

gulp.task('clean:build', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:clean'], cb);
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

gulp.task('syncNugetProjs', function() {
  var dirs = glob.sync(path.join(basePathOrThrow(), '/**/*.nuget.proj'))
    .map(function(filePath) {
      return path.dirname(filePath);
    });

  gulp.src(dirs.map(function(dir) {
      return path.join(dir, '/**/AssemblyInfo.cs');
    }), {
      base: './'
    })
    .pipe(nugetProjSync({
      default_version: DEFAULT_ASSEMBLY_VERSION
    }))
    .pipe(gulp.dest('.'))
})

gulp.task('syncNuspecs', function() {
  var dirs = glob.sync(path.join(basePathOrThrow(), '/**/packages.config'))
    .map(function(filePath) {
      return path.dirname(filePath);
    });

  gulp.src(dirs.map(function(dir) {
      return path.join(dir, '/**/*.nuspec');
    }), {
      base: './'
    })
    .pipe(nuspecSync())
    .pipe(gulp.dest('.'))
});

gulp.task('syncDotNetDependencies', ['syncNugetProjs', 'syncNuspecs']);

gulp.task('build', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:build', '/p:WarningsNotAsErrors=0219'], cb);
});

gulp.task('package', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:package'], cb);
});

gulp.task('test', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:test'], cb);
});

gulp.task('analysis', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:codeanalysis', '/p:WarningsNotAsErrors=0219'], cb);
});


gulp.task('default', function(cb){
  runSequence('clean', 'build', 'analysis', 'package', 'test', cb);
});
