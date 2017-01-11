// through2 is a thin wrapper around node transform streams
var through = require('through2');
var gutil = require('gulp-util');
var path = require('path');
var fs = require('fs');
var Q = require('q');
var spawn = require('child_process').spawn;
var PluginError = gutil.PluginError;

var isWindows = (process.platform.lastIndexOf('win') === 0);
var isLinux= (process.platform.lastIndexOf('linux') === 0);
var isMac = (process.platform.lastIndexOf('darwin') === 0);

function GetAutoRestFolder() {
  if (isWindows) {
    return "src/core/AutoRest/bin/Debug/net451/win7-x64/";
  }
  if (isMac) {
    var mac_os_10_11 = "src/core/AutoRest/bin/Debug/net451/osx.10.11-x64/";
    var mac_os_10_12 = "src/core/AutoRest/bin/Debug/net451/osx.10.12-x64/";
    if (fs.existsSync(mac_os_10_11)) {
      return mac_os_10_11;
    }
    if (fs.existsSync(mac_os_10_12)) {
      return mac_os_10_12;
    }
    throw new Error("Unknown Mac Darwin OS version.");
  } 
  if (isLinux) { 
    return "src/core/AutoRest/bin/Debug/net451/ubuntu.14.04-x64/"
  }
   throw new Error("Unknown platform?");
}


const PLUGIN_NAME = 'gulp-regenerate-expected';

function gulpRegenerateExpected(options, done) {
  var opts = JSON.parse(JSON.stringify(options)); // copy input so we can mutate it

  if (!opts.mappings) {
    throw new PluginError({
      plugin: PLUGIN_NAME,
      message: 'There was no opts.mappings specified'
    });
  }

  if (!opts.outputDir) {
    throw new PluginError({
      plugin: PLUGIN_NAME,
      message: 'There was no opts.outputDir specified'
    });
  }
  opts.outputDir = !!opts.outputBaseDir ? path.join(opts.outputBaseDir, opts.outputDir) : opts.outputDir;

  if (!opts.modeler) {
    opts.modeler = 'Swagger';
    gutil.log('opts.modeler not set, so setting it to "Swagger"');
  }

  if (!opts.codeGenerator) {
    opts.codeGenerator = "CSharp";
    gutil.log('opts.codeGenerator not set, so setting it to "CSharp"');
  }

  if(!opts.nsPrefix){
    opts.nsPrefix = "Fixtures";
    gutil.log('opts.nsPrefix not set, so setting it to "Fixtures"');
  }

  if(!opts.flatteningThreshold){
    opts.flatteningThreshold = "0";
    gutil.log('opts.flatteningThreshold not set, so setting it to "0"');
  }

  if(!opts.addCredentials){
    opts.addCredentials = false;
    gutil.log('opts.addCredentials not set, so setting it to "false"');
  }

  var promises = Object.keys(opts.mappings).map(function(key) {
    var cmd = 'mono';
    var optsMappingsValue = opts.mappings[key];
    var mappingBaseDir = optsMappingsValue instanceof Array ? optsMappingsValue[0] : optsMappingsValue;
    var args = [
      GetAutoRestFolder()+'AutoRest.exe',
//      '-verbose',
      '-Modeler', opts.modeler,
      '-CodeGenerator', opts.codeGenerator,
      '-PayloadFlatteningThreshold', opts.flatteningThreshold,
      '-OutputDirectory', path.join(opts.outputDir, key),
      '-Input', (!!opts.inputBaseDir ? path.join(opts.inputBaseDir, mappingBaseDir) : mappingBaseDir),
      '-Header', (!!opts.header ? opts.header : 'MICROSOFT_MIT_NO_VERSION')      
    ];

    if (opts.addCredentials) {
      args.push('-AddCredentials');
    }
    
    if (opts.syncMethods) {
      args.push('-SyncMethods');
      args.push(opts.syncMethods);
    }

    if (!!opts.nsPrefix) {
      args.push('-Namespace');
      if (optsMappingsValue instanceof Array && optsMappingsValue[1] !== undefined) {
          args.push(optsMappingsValue[1]);
	  }else{
		args.push([opts.nsPrefix, key.replace(/\/|\./, '')].join('.'));
	  }
    }

    var isWin = /^win/.test(process.platform);
    if (isWin) {
      cmd = args.shift();
    }

    gutil.log(PLUGIN_NAME + ': running `', cmd, args.join(', '), '``')

    return exec(cmd, args, {
      stdio: ['pipe', process.stdout, process.stderr]
    })
  });

  Q.allSettled(promises).done(function(args) {
    gutil.log(PLUGIN_NAME + ': done regenerating targeting, ' + opts.outputDir);
    done();
  }, function(args) {
    gutil.log(PLUGIN_NAME + ': done but ran into issues regenerating target, ' + opts.outputDir);
    done(args);
  });
}

function exec(command, args, extArgs) {
  if (!command) {
    return Q.reject(new Error('Both command must be given, not ' + command ));
  }
  if (args && !args.every(function(arg) {
    var type = typeof arg;
    return type === 'boolean' || type === 'string' || type === 'number';
  })) {
    return Q.reject(new Error('All arguments must be a boolean, string or number'));
  }
  var deferred = Q.defer();
  var proc = spawn(command, args, extArgs);
  proc.on('error', function(error) {
    deferred.reject(new Error(command + ' ' + args.join(' ') + ' encountered error ' + error.message));
    // errors aren't halting the gulp script. Fixing that the easy way:
    throw new Error(command + ' ' + args.join(' ') + ' encountered error ' + error.message);
  });
  proc.on('exit', function(code) {
    if (code !== 0) {
      deferred.reject(new Error(command + ' ' + args.join(' ') + ' exited with code ' + code));
      // errors aren't halting the gulp script. Fixing that the easy way:
      throw new Error(command + ' ' + args.join(' ') + ' exited with code ' + code)
    } else {
      deferred.resolve();
    }
  });
  return deferred.promise;
};

module.exports = gulpRegenerateExpected;
