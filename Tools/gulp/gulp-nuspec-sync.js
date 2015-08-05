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
    var pkgNuspecString = file.contents.toString();
    xml2js.parseString(pkgConfigString, function(err, pkgConfigXml) {
      gutil.log('Syncing .nuspec and packages.config for: ' + file.path + ' and ' + pkgConfigPath);

      var packages = pkgConfigXml['packages']['package'];
      packages.forEach(function(pkg) {
        var re = new RegExp('(<dependency\\s+id="' + pkg.$.id + '"\\s+version="\\[?\\(?)((?:\\d+\\.?){1,4}[-\\w]+)((?:\\s?,[\\d\\.]+)?\\)?\\]?")');
        pkgNuspecString = pkgNuspecString.replace(re, '$1' + pkg.$.version + '$3')
      });

      file.contents = new Buffer(pkgNuspecString);
      cb(null, file);
    });
  });
}

// Exporting the plugin main function
module.exports = gulpNuspecSync;
