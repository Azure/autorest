// through is a thin wrapper around node transform streams
var through = require('through2');
var gutil = require('gulp-util');
var xml2js = require('xml2js');
var path = require('path');
var glob = require('glob');
var fs = require('fs');
var PluginError = gutil.PluginError;

const PLUGIN_NAME = 'gulp-nuget-proj-sync';

function gulpNugetProjSync(opts) {
  // Creating a stream through which each file will pass
  return through.obj(function(file, enc, cb) {
    var baseDir = path.dirname(file.path);
    var nuprojPathes = glob.sync(path.join(baseDir, '../*.nuget.proj'));

    var nuprojPath = null;
    if (!nuprojPathes || nuprojPathes.length === 0) {
      throw new PluginError({
        plugin: PLUGIN_NAME,
        message: 'There was no nuget.proj path found in: ' + baseDir
      });
    } else {
      if (nuprojPathes.Length > 1) {
        gutil.warn('Found more than one nuget.proj in ' + baseDir + '. Using first ' + nuprojPathes[0]);
      }
      nuprojPath = nuprojPathes[0];
    }

    var assemblyInfoContents = file.contents.toString();

    var nuprojString = fs.readFileSync(nuprojPath).toString();
    xml2js.parseString(nuprojString, function(err, nuprojXml) {
      var packageVersion = nuprojXml['Project']['ItemGroup'][0]['SdkNuGetPackage'][0]['PackageVersion'][0];

      var tokens = packageVersion.split('.')
      var assemblyFileVersion = packageVersion;
      if (tokens.Length === 3) {
        assemblyFileVersion = packageVersion + '.0';
      }

      var fileVersionRegex = '\[assembly\:\s*AssemblyFileVersion\s*\(\s*"[\d\.\s]+"\s*\)\s*\]';
      var fileVersionContent = '[assembly: AssemblyFileVersion(\"' + assemblyFileVersion + '\")]';

      var assemblyVersion = tokens[0] + '.0.0.0';
      if (tokens[0] == 0) {
        assemblyVersion = opts.default_version || '0.0.1.0';
      }
      var assemblyVersionRegex = '\[assembly\:\s*AssemblyVersion\s*\(\s*"[\d\.\s]+';
      var assemblyVersionContent = '[assembly: AssemblyVersion("' + assemblyVersion;

      gutil.log("Updating AssemblyInfo.cs with path: " + file.path + 'with file version: ' +
        assemblyFileVersion + ' and version: ' + assemblyVersion);
      assemblyInfoContents.replace(fileVersionRegex, fileVersionContent);
      assemblyInfoContents.replace(assemblyVersionRegex, assemblyVersionContent);

      file.contents = new Buffer(assemblyInfoContents);
      cb(null, file);
    });
  });
}

// Exporting the plugin main function
module.exports = gulpNugetProjSync;
