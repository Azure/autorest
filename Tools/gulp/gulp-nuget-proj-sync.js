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
    var projectJsonPaths = glob.sync(path.join(baseDir, '../project.json'));

    var projectJsonPath = null;
    if (!projectJsonPaths || projectJsonPaths.length === 0) {
      return cb(null, file);
    } else {
      if (projectJsonPaths.Length > 1) {
        gutil.warn('Found more than one nuget.proj in ' + baseDir + '. Using first ' + projectJsonPaths[0]);
      }
      projectJsonPath = projectJsonPaths[0];
    }

    var assemblyInfoContents = file.contents.toString();

    var projectJson = JSON.parse(fs.readFileSync(projectJsonPath).toString());
    var packageVersion = projectJson.version;
    var tokens = packageVersion.split('.')
    var assemblyFileVersion = packageVersion;
    if (tokens.length === 3) {
      assemblyFileVersion = packageVersion + '.0';
    } else if (tokens.length === 2) {
      assemblyFileVersion = packageVersion + '.0.0';
    } else if (tokens.length === 1) {
      assemblyFileVersion = packageVersion + '.0.0.0';
    }

    var fileVersionRegex = /\[assembly\:\s*AssemblyFileVersion\s*\(\s*"[\d\.]+"\s*\)\s*\]/;
    var fileVersionContent = '[assembly: AssemblyFileVersion(\"' + assemblyFileVersion + '\")]';

    var assemblyVersion = tokens[0] + '.0.0.0';
    if (tokens[0] == 0) {
      assemblyVersion = opts.default_version || '0.0.1.0';
    }
    var assemblyVersionRegex = /\[assembly\:\s*AssemblyVersion\s*\(\s*"[\d\.]+"/;
    var assemblyVersionContent = '[assembly: AssemblyVersion("' + assemblyVersion + '\"';

    gutil.log("Updating AssemblyInfo.cs with path: " + file.path + ' with file version: ' +
      assemblyFileVersion + ' and version: ' + assemblyVersion);
    assemblyInfoContents = assemblyInfoContents.replace(fileVersionRegex, fileVersionContent);
    assemblyInfoContents = assemblyInfoContents.replace(assemblyVersionRegex, assemblyVersionContent);
    file.contents = new Buffer(assemblyInfoContents);
    cb(null, file);
  });
}

// Exporting the plugin main function
module.exports = gulpNugetProjSync;
