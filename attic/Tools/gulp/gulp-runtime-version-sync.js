var gulp = require('gulp');
var gutil = require('gulp-util');
var replace = require('gulp-replace');
var xml2js = require('xml2js');
var path = require('path');
var fs = require('fs');
var shell = require('gulp-shell')

gulp.task('syncDependencies:runtime:cs', function () {
  gutil.log('Syncing C# client runtime version');
  var runtimePkgPath = './src/client/Microsoft.Rest.ClientRuntime/project.json';
  pkgJsonConfig = JSON.parse(fs.readFileSync(runtimePkgPath, 'utf8'));
  var name = 'Microsoft.Rest.ClientRuntime';
  var version = pkgJsonConfig.version;

  var codeGeneratorPath = './src/generator/AutoRest.CSharp/CSharpCodeGenerator.cs';
  gulp.src(codeGeneratorPath, { base: './' })
    .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + '.' + version + '"'))
    .pipe(gulp.dest('.'));

  var pkgTestConfig = './PackageTest/NugetPackageTest/packages.config';
  gulp.src(pkgTestConfig, { base: './' })
    .pipe(replace(/<package id="Microsoft.Rest.ClientRuntime" version="([\.\d]+)"/, '<package id="Microsoft.Rest.ClientRuntime" version="' + version + '"'))
    .pipe(gulp.dest('.'));

  var pkgTestCsproj = './PackageTest/NugetPackageTest/NugetPackageCSharpTest.csproj';
  gulp.src(pkgTestCsproj, { base: './' })
    .pipe(replace(/Microsoft.Rest.ClientRuntime.([\.\d]+)/, 'Microsoft.Rest.ClientRuntime.' + version + ''))
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime:csazure', function () {
  gutil.log('Syncing Azure C# client runtime version');
  var runtimePkgPath = './src/client/Microsoft.Rest.ClientRuntime.Azure/project.json';
  pkgJsonConfig = JSON.parse(fs.readFileSync(runtimePkgPath, 'utf8'));
  var name = 'Microsoft.Rest.ClientRuntime.Azure';
  var version = pkgJsonConfig.version;

  var codeGeneratorPath = './src/generator/AutoRest.CSharp.Azure/AzureCSharpCodeGenerator.cs';
  gulp.src(codeGeneratorPath, { base: './' })
    .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + '.' + version + '"'))
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime:node', function () {
  gutil.log('Syncing NodeJS client runtime version');
  var runtimePkgPath = './src/client/NodeJS/ms-rest/package.json';
  var runtimePkgString = fs.readFileSync(runtimePkgPath).toString();
  pkgConfig = JSON.parse(runtimePkgString);
  var name = pkgConfig['name'];
  var version = pkgConfig['version'];

  var codeGeneratorPath = './src/generator/AutoRest.NodeJS/NodeJSCodeGenerator.cs';
  gulp.src(codeGeneratorPath, { base: './' })
    .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + ' version ' + version + '"'))
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime:nodeazure', function () {
  gutil.log('Syncing NodeJS client runtime version');
  var runtimePkgPath = './src/client/NodeJS/ms-rest-azure/package.json';
  var runtimePkgString = fs.readFileSync(runtimePkgPath).toString();
  pkgConfig = JSON.parse(runtimePkgString);
  var name = pkgConfig['name'];
  var version = pkgConfig['version'];

  var codeGeneratorPath = './src/generator/AutoRest.NodeJS.Azure/AzureNodeJSCodeGenerator.cs';
  gulp.src(codeGeneratorPath, { base: './' })
    .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + ' version ' + version + '"'))
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime:ruby', 
  shell.task(['bundle install', 'rake build'], { cwd: './src/client/Ruby/ms-rest', verbosity: 3 })
);

gulp.task('syncDependencies:runtime:rubyazure',
  shell.task(['bundle install', 'rake build'], { cwd: './src/client/Ruby/ms-rest-azure', verbosity: 3 })
);

