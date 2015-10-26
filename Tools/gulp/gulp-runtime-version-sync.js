var gulp = require('gulp');
var gutil = require('gulp-util');
var replace = require('gulp-replace');
var xml2js = require('xml2js');
var path = require('path');
var fs = require('fs');
var shell = require('gulp-shell')

gulp.task('syncDependencies:runtime:cs', function () {
  gutil.log('Syncing C# client runtime version');
  var runtimePkgPath = './ClientRuntimes/CSharp/ClientRuntime/Microsoft.Rest.ClientRuntime.nuget.proj';
  var runtimePkgString = fs.readFileSync(runtimePkgPath).toString();
  xml2js.parseString(runtimePkgString, function (err, pkgConfigXml) {
    var name = pkgConfigXml['Project']['ItemGroup'][0]['SdkNuGetPackage'][0]['Name'];
    var version = pkgConfigXml['Project']['ItemGroup'][0]['SdkNuGetPackage'][0]['PackageVersion'];

    var codeGeneratorPath = './AutoRest/Generators/CSharp/CSharp/CSharpCodeGenerator.cs';
    gulp.src(codeGeneratorPath, { base: './' })
      .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + '.' + version + '"'))
      .pipe(gulp.dest('.'));

    var pkgTestConfig = './AutoRest/Generators/AcceptanceTests/NugetPackageTest/packages.config';
    gulp.src(pkgTestConfig, { base: './' })
      .pipe(replace(/<package id="Microsoft.Rest.ClientRuntime" version="([\.\d]+)"/, '<package id="Microsoft.Rest.ClientRuntime" version="' + version + '"'))
      .pipe(gulp.dest('.'));
  });
});

gulp.task('syncDependencies:runtime:csazure', function () {
  gutil.log('Syncing Azure C# client runtime version');
  var runtimePkgPath = './ClientRuntimes/CSharp/ClientRuntime.Azure/Microsoft.Rest.ClientRuntime.Azure.nuget.proj';
  var runtimePkgString = fs.readFileSync(runtimePkgPath).toString();
  xml2js.parseString(runtimePkgString, function (err, pkgConfigXml) {
    var name = pkgConfigXml['Project']['ItemGroup'][0]['SdkNuGetPackage'][0]['Name'];
    var version = pkgConfigXml['Project']['ItemGroup'][0]['SdkNuGetPackage'][0]['PackageVersion'];

    var codeGeneratorPath = './AutoRest/Generators/CSharp/Azure.CSharp/AzureCSharpCodeGenerator.cs';
    gulp.src(codeGeneratorPath, { base: './' })
      .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + '.' + version + '"'))
      .pipe(gulp.dest('.'));
  });
});

gulp.task('syncDependencies:runtime:node', function () {
  gutil.log('Syncing NodeJS client runtime version');
  var runtimePkgPath = './ClientRuntimes/NodeJS/ms-rest/package.json';
  var runtimePkgString = fs.readFileSync(runtimePkgPath).toString();
  pkgConfig = JSON.parse(runtimePkgString);
  var name = pkgConfig['name'];
  var version = pkgConfig['version'];

  var codeGeneratorPath = './AutoRest/Generators/NodeJS/NodeJS/NodeJSCodeGenerator.cs';
  gulp.src(codeGeneratorPath, { base: './' })
    .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + ' version ' + version + '"'))
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime:nodeazure', function () {
  gutil.log('Syncing NodeJS client runtime version');
  var runtimePkgPath = './ClientRuntimes/NodeJS/ms-rest-azure/package.json';
  var runtimePkgString = fs.readFileSync(runtimePkgPath).toString();
  pkgConfig = JSON.parse(runtimePkgString);
  var name = pkgConfig['name'];
  var version = pkgConfig['version'];

  var codeGeneratorPath = './AutoRest/Generators/NodeJS/Azure.NodeJS/AzureNodeJSCodeGenerator.cs';
  gulp.src(codeGeneratorPath, { base: './' })
    .pipe(replace(/string ClientRuntimePackage = "(.+)"/, 'string ClientRuntimePackage = "' + name + ' version ' + version + '"'))
    .pipe(gulp.dest('.'));
});

gulp.task('syncDependencies:runtime:ruby', 
  shell.task(['bundle install', 'rake build'], { cwd: './ClientRuntimes/Ruby/ms-rest', verbosity: 3 })
);

gulp.task('syncDependencies:runtime:rubyazure',
  shell.task(['bundle install','rake build'], { cwd: './ClientRuntimes/Ruby/ms-rest-azure', verbosity: 3 })
);

