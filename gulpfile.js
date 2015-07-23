var gulp = require('gulp');
var path = require('path');
var debug = require('gulp-debug');
var glob = require('glob');
var spawn = require('child_process').spawn;
var assemblyInfo = require('gulp-dotnet-assembly-info');
var nuspecSync = require('./Tools/gulp/gulp-nuspec-sync');
var nugetProjSync = require('./Tools/gulp/gulp-nuget-proj-sync');
var gutil = require('gulp-util');

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

  child.on('close', function(code) {
    gutil.log("Done with exit code", code);
    cb();
  });
}

// Clean related tasks

gulp.task('cleanBuild', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:clean'], cb);
});

gulp.task('cleanTemplates', function(cb) {
  glob('./AutoRest/**/Templates/*.cs', function(files){
    (files || []).forEach(function(file) { fs.unlink(file) });
    cb();
  });
});

gulp.task('clean', ['cleanBuild', 'cleanTemplates']);

// Build related tasks

gulp.task('build', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/p:WarningsNotAsErrors=0219'], cb);
});

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


// Test related tasks

gulp.task('package', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:package'], cb);
});

gulp.task('test', function(cb) {
  runProcess(csharpBuild, ['build.proj', '/t:test'], cb);
});
