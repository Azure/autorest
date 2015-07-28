// through2 is a thin wrapper around node transform streams
var through = require('through2');
var gutil = require('gulp-util');
var xml2js = require('xml2js');
var path = require('path');
var fs = require('fs');
var PluginError = gutil.PluginError;

const PLUGIN_NAME = 'gulp-nuspec-sync';

function gulpNuspecSync(opts) {
  // Creating a stream through which each file will pass
  return through.obj(function(file, enc, cb) {
    var pkgConfigPath = path.join(path.dirname(file.path), 'packages.config');
    var pkgConfigString = fs.readFileSync(pkgConfigPath).toString();
    xml2js.parseString(pkgConfigString, function(err, pkgConfigXml) {
      xml2js.parseString(file.contents.toString(), function(err, nuspecXml) {

        gutil.log('Syncing .nuspec and packages.config for: ' + file.path + ' and ' + pkgConfigPath);

        var pkgVersions = {};
        var packages = pkgConfigXml['packages']['package'];
        packages.forEach(function(package) {
          pkgVersions[package.$.id] = package.$.version;
        });

        nuspecXml['package']['metadata'][0]['dependencies'].forEach(function(dependencies) {
          var updateDep = function(depend) {
            depend.forEach(function(dep) {
              if (dep.$.id in pkgVersions) {
                if(pkgVersions[dep.$.id] != dep.$.version){
                  gutil.log('Updating dependency: ' + dep.$.id + ' from: ' + pkgVersions[dep.$.id] + ' to: ' + dep.$.version)
                  dep.$.version = pkgVersions[dep.$.id]
                } else {
                  gutil.log('Skipping dependency: ' + dep.$.id + ' at: ' + pkgVersions[dep.$.id]);
                }
              }
            });
          };

          dependency = dependencies['dependency'];

          if (dependency) {
            updateDep(dependency);
          } else {
            var groupDependencies = dependencies['group'][0]['dependency'];
            if (groupDependencies) {
              updateDep(groupDependencies);
            }
          }
        });

        var builder = new xml2js.Builder();
        var xml = builder.buildObject(nuspecXml);
        file.contents = new Buffer(xml);
        cb(null, file);
      });
    });
  });
}

// Exporting the plugin main function
module.exports = gulpNuspecSync;
