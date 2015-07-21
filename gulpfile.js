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

function handleProcess(child, cb){
  var stdout = '';
  var stderr = '';

  // child.stdout.setEncoding('utf8');
  //
  // child.stdout.on('data', function(data) {
  //   stdout += data;
  //   gutil.log(data);
  // });
  //
  // child.stderr.setEncoding('utf8');
  // child.stderr.on('data', function(data) {
  //   stderr += data;
  //   gutil.log(gutil.colors.red(data));
  //   gutil.beep();
  // });

  child.on('close', function(code) {
    gutil.log("Done with exit code", code);
    cb();
  });
}

gulp.task('clean', function(cb) {
  var child = spawn(csharpBuild,
    ['build.proj', '/t:clean'],
    { stdio: ['pipe', process.stdout, process.stderr] });
  handleProcess(child, cb);
});

gulp.task('build', function(cb) {
  var child = spawn(csharpBuild,
    ['build.proj', '/p:WarningsNotAsErrors=0219'],
    { stdio: ['pipe', process.stdout, process.stderr] });
  handleProcess(child, cb);
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
